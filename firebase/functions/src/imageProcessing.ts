import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as sharp from 'sharp';
import * as path from 'path';
import * as os from 'os';
import * as fs from 'fs';

const storage = admin.storage();
const db = admin.firestore();

/**
 * Process uploaded images:
 * - Generate thumbnails (200x200)
 * - Generate medium size (600x600)
 * - Generate WebP versions
 * - Generate AVIF versions
 * - Update product/shop document with URLs
 */
export const processImage = functions.storage.object().onFinalize(async (object) => {
  const filePath = object.name;
  const contentType = object.contentType;

  if (!filePath || !contentType) {
    console.log('No file path or content type');
    return null;
  }

  // Only process images
  if (!contentType.startsWith('image/')) {
    console.log('Not an image');
    return null;
  }

  // Don't process already processed images
  if (filePath.includes('/processed/') || filePath.includes('/temp/')) {
    console.log('Already processed or temp file');
    return null;
  }

  const bucket = storage.bucket(object.bucket);
  const fileName = path.basename(filePath);
  const fileDir = path.dirname(filePath);

  // Download file to temp directory
  const tempFilePath = path.join(os.tmpdir(), fileName);
  await bucket.file(filePath).download({ destination: tempFilePath });

  console.log('Image downloaded to', tempFilePath);

  try {
    // Extract metadata
    const metadata = await sharp(tempFilePath).metadata();
    console.log('Image metadata:', metadata);

    // Define sizes and formats
    const sizes = [
      { name: 'thumb', width: 200, height: 200 },
      { name: 'medium', width: 600, height: 600 },
      { name: 'large', width: 1200, height: 1200 },
    ];

    const formats = ['jpeg', 'webp', 'avif'];

    const processedUrls: Record<string, string> = {};

    // Generate all combinations
    for (const size of sizes) {
      for (const format of formats) {
        const outputFileName = `${path.parse(fileName).name}_${size.name}.${format}`;
        const outputPath = path.join(os.tmpdir(), outputFileName);
        const uploadPath = `processed/${fileDir}/${outputFileName}`;

        // Process image
        await sharp(tempFilePath)
          .resize(size.width, size.height, {
            fit: 'inside',
            withoutEnlargement: true,
          })
          .toFormat(format as keyof sharp.FormatEnum, {
            quality: format === 'avif' ? 50 : format === 'webp' ? 80 : 85,
          })
          .toFile(outputPath);

        // Upload processed image
        await bucket.upload(outputPath, {
          destination: uploadPath,
          metadata: {
            contentType: `image/${format}`,
            metadata: {
              originalName: fileName,
              size: size.name,
              format: format,
            },
          },
        });

        // Get public URL
        const file = bucket.file(uploadPath);
        await file.makePublic();
        const publicUrl = `https://storage.googleapis.com/${bucket.name}/${uploadPath}`;

        processedUrls[`${size.name}_${format}`] = publicUrl;

        // Clean up temp file
        fs.unlinkSync(outputPath);
      }
    }

    // Clean up original temp file
    fs.unlinkSync(tempFilePath);

    console.log('Processed URLs:', processedUrls);

    // Update Firestore document with processed URLs
    await updateDocumentWithUrls(filePath, processedUrls);

    return processedUrls;
  } catch (error) {
    console.error('Error processing image:', error);
    // Clean up temp file on error
    if (fs.existsSync(tempFilePath)) {
      fs.unlinkSync(tempFilePath);
    }
    throw error;
  }
});

/**
 * Update product or shop document with processed image URLs
 */
async function updateDocumentWithUrls(
  filePath: string,
  urls: Record<string, string>
): Promise<void> {
  // Parse file path to determine document type and ID
  // Examples:
  // - products/{shopId}/{productId}/image1.jpg
  // - shops/{shopId}/logo/logo.jpg

  const pathParts = filePath.split('/');

  if (pathParts[0] === 'products') {
    // Product image
    const shopId = pathParts[1];
    const productId = pathParts[2];
    const fileName = pathParts[3];

    const productRef = db.collection('shops').doc(shopId).collection('products').doc(productId);

    // Get current product data
    const productDoc = await productRef.get();
    if (!productDoc.exists) {
      console.log('Product not found:', productId);
      return;
    }

    const productData = productDoc.data();
    const images = productData?.images || [];

    // Find existing image or add new one
    const existingImageIndex = images.findIndex((img: any) =>
      img.url.includes(fileName) || img.url.includes(pathParts.slice(0, -1).join('/'))
    );

    const processedImageData = {
      url: urls.large_jpeg || urls.medium_jpeg,
      thumbUrl: urls.thumb_webp || urls.thumb_jpeg,
      mediumUrl: urls.medium_webp || urls.medium_jpeg,
      webp: {
        thumb: urls.thumb_webp,
        medium: urls.medium_webp,
        large: urls.large_webp,
      },
      avif: {
        thumb: urls.thumb_avif,
        medium: urls.medium_avif,
        large: urls.large_avif,
      },
      order: existingImageIndex >= 0 ? images[existingImageIndex].order : images.length,
    };

    if (existingImageIndex >= 0) {
      images[existingImageIndex] = {
        ...images[existingImageIndex],
        ...processedImageData,
      };
    } else {
      images.push(processedImageData);
    }

    await productRef.update({
      images,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log('Updated product images:', productId);
  } else if (pathParts[0] === 'shops') {
    // Shop logo or cover
    const shopId = pathParts[1];
    const imageType = pathParts[2]; // 'logo' or 'cover'

    const shopRef = db.collection('shops').doc(shopId);

    const updateData: Record<string, any> = {
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    if (imageType === 'logo') {
      updateData.logo = urls.medium_webp || urls.medium_jpeg;
      updateData.logoProcessed = {
        jpeg: urls.medium_jpeg,
        webp: urls.medium_webp,
        avif: urls.medium_avif,
      };
    } else if (imageType === 'cover') {
      updateData.coverImage = urls.large_webp || urls.large_jpeg;
      updateData.coverImageProcessed = {
        jpeg: urls.large_jpeg,
        webp: urls.large_webp,
        avif: urls.large_avif,
      };
    }

    await shopRef.update(updateData);

    console.log('Updated shop image:', shopId, imageType);
  }
}

/**
 * Delete processed images when original is deleted
 */
export const deleteProcessedImages = functions.storage.object().onDelete(async (object) => {
  const filePath = object.name;

  if (!filePath) {
    return null;
  }

  // Don't process if already a processed image
  if (filePath.includes('/processed/')) {
    return null;
  }

  const bucket = storage.bucket(object.bucket);
  const fileName = path.basename(filePath);
  const fileDir = path.dirname(filePath);
  const baseName = path.parse(fileName).name;

  // Delete all processed versions
  const sizes = ['thumb', 'medium', 'large'];
  const formats = ['jpeg', 'webp', 'avif'];

  const deletePromises: Promise<any>[] = [];

  for (const size of sizes) {
    for (const format of formats) {
      const processedFileName = `${baseName}_${size}.${format}`;
      const processedPath = `processed/${fileDir}/${processedFileName}`;

      deletePromises.push(
        bucket.file(processedPath).delete().catch((error) => {
          console.log(`Failed to delete ${processedPath}:`, error.message);
        })
      );
    }
  }

  await Promise.all(deletePromises);

  console.log('Deleted processed images for:', fileName);

  return null;
});
