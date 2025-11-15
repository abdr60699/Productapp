import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import algoliasearch from 'algoliasearch';

const db = admin.firestore();

// Initialize Algolia client
const algoliaClient = algoliasearch(
  functions.config().algolia?.appid || process.env.ALGOLIA_APP_ID!,
  functions.config().algolia?.apikey || process.env.ALGOLIA_API_KEY!
);

/**
 * Sync product to Algolia when created or updated
 */
export const syncProductToAlgolia = functions.firestore
  .document('shops/{shopId}/products/{productId}')
  .onWrite(async (change, context) => {
    const shopId = context.params.shopId;
    const productId = context.params.productId;

    const indexName = `shops_${shopId}_products`;
    const index = algoliaClient.initIndex(indexName);

    // If product is deleted
    if (!change.after.exists) {
      console.log('Deleting product from Algolia:', productId);
      await index.deleteObject(productId);
      return null;
    }

    const productData = change.after.data();

    // Only index active products
    if (!productData?.isActive) {
      console.log('Product is inactive, removing from Algolia:', productId);
      try {
        await index.deleteObject(productId);
      } catch (error) {
        console.log('Product not in index, skipping deletion');
      }
      return null;
    }

    // Prepare data for Algolia
    const algoliaObject = {
      objectID: productId,
      shopId,
      title: productData.title,
      slug: productData.slug,
      templateId: productData.templateId,
      templateName: productData.templateName,
      category: productData.category || '',
      tags: productData.tags || [],
      price: productData.price || 0,
      compareAtPrice: productData.compareAtPrice,
      inStock: productData.inStock !== false,
      featured: productData.featured === true,
      images: productData.images || [],
      primaryImage: productData.images?.[0]?.thumbUrl || productData.images?.[0]?.url || '',

      // Flatten product data for searching
      ...flattenProductData(productData.data || {}),

      // Timestamps for sorting
      createdAt: productData.createdAt?.toMillis() || Date.now(),
      updatedAt: productData.updatedAt?.toMillis() || Date.now(),
      publishedAt: productData.publishedAt?.toMillis(),

      // Computed fields
      isOnSale: (productData.compareAtPrice || 0) > (productData.price || 0),
      discount: calculateDiscount(productData.price, productData.compareAtPrice),
    };

    console.log('Indexing product to Algolia:', productId);
    await index.saveObject(algoliaObject);

    return null;
  });

/**
 * Configure Algolia index settings when shop is created
 */
export const setupAlgoliaIndex = functions.firestore
  .document('shops/{shopId}')
  .onCreate(async (snapshot, context) => {
    const shopId = context.params.shopId;
    const indexName = `shops_${shopId}_products`;
    const index = algoliaClient.initIndex(indexName);

    // Configure index settings
    await index.setSettings({
      // Searchable attributes
      searchableAttributes: [
        'title',
        'category',
        'tags',
        'templateName',
        'unordered(data_description)',
        'unordered(data_brand)',
        'unordered(data_model)',
      ],

      // Attributes for faceting
      attributesForFaceting: [
        'filterOnly(shopId)',
        'category',
        'tags',
        'templateName',
        'inStock',
        'featured',
        'isOnSale',
      ],

      // Custom ranking
      customRanking: [
        'desc(featured)',
        'desc(publishedAt)',
        'asc(price)',
      ],

      // Attributes to retrieve
      attributesToRetrieve: [
        'objectID',
        'title',
        'slug',
        'category',
        'price',
        'compareAtPrice',
        'primaryImage',
        'inStock',
        'featured',
        'isOnSale',
        'discount',
      ],

      // Pagination
      hitsPerPage: 20,
      paginationLimitedTo: 1000,

      // Highlighting
      attributesToHighlight: ['title', 'category'],

      // Snippeting
      attributesToSnippet: ['data_description:50'],
    });

    console.log('Algolia index configured:', indexName);
    return null;
  });

/**
 * Helper: Flatten nested product data for Algolia
 */
function flattenProductData(data: Record<string, any>): Record<string, any> {
  const flattened: Record<string, any> = {};

  for (const [key, value] of Object.entries(data)) {
    // Skip null/undefined values
    if (value === null || value === undefined) continue;

    // Convert arrays to strings for searching
    if (Array.isArray(value)) {
      flattened[`data_${key}`] = value.join(' ');
      flattened[`data_${key}_array`] = value;
    } else if (typeof value === 'object') {
      // Convert objects to strings
      flattened[`data_${key}`] = JSON.stringify(value);
    } else {
      flattened[`data_${key}`] = value;
    }
  }

  return flattened;
}

/**
 * Helper: Calculate discount percentage
 */
function calculateDiscount(price?: number, compareAtPrice?: number): number {
  if (!price || !compareAtPrice || compareAtPrice <= price) {
    return 0;
  }
  return Math.round(((compareAtPrice - price) / compareAtPrice) * 100);
}

/**
 * Bulk reindex all products for a shop
 */
export const reindexShopProducts = functions.https.onCall(async (data, context) => {
  // Verify authentication
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const shopId = data.shopId;

  if (!shopId) {
    throw new functions.https.HttpsError('invalid-argument', 'shopId is required');
  }

  // Verify user has access to shop
  const shopDoc = await db.collection('shops').doc(shopId).get();
  if (!shopDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Shop not found');
  }

  const shopData = shopDoc.data();
  if (shopData?.ownerId !== context.auth.uid) {
    throw new functions.https.HttpsError('permission-denied', 'Not authorized');
  }

  const indexName = `shops_${shopId}_products`;
  const index = algoliaClient.initIndex(indexName);

  // Get all products
  const productsSnapshot = await db
    .collection('shops')
    .doc(shopId)
    .collection('products')
    .where('isActive', '==', true)
    .get();

  const algoliaObjects = productsSnapshot.docs.map((doc) => {
    const productData = doc.data();
    return {
      objectID: doc.id,
      shopId,
      title: productData.title,
      slug: productData.slug,
      templateId: productData.templateId,
      templateName: productData.templateName,
      category: productData.category || '',
      tags: productData.tags || [],
      price: productData.price || 0,
      compareAtPrice: productData.compareAtPrice,
      inStock: productData.inStock !== false,
      featured: productData.featured === true,
      primaryImage: productData.images?.[0]?.thumbUrl || productData.images?.[0]?.url || '',
      ...flattenProductData(productData.data || {}),
      createdAt: productData.createdAt?.toMillis() || Date.now(),
      updatedAt: productData.updatedAt?.toMillis() || Date.now(),
      publishedAt: productData.publishedAt?.toMillis(),
      isOnSale: (productData.compareAtPrice || 0) > (productData.price || 0),
      discount: calculateDiscount(productData.price, productData.compareAtPrice),
    };
  });

  // Clear existing index and save new objects
  await index.clearObjects();
  await index.saveObjects(algoliaObjects);

  console.log(`Reindexed ${algoliaObjects.length} products for shop ${shopId}`);

  return {
    success: true,
    count: algoliaObjects.length,
  };
});
