import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import slugify from 'slugify';

const db = admin.firestore();

/**
 * Generate slug for new shops
 */
export const generateShopSlug = functions.firestore
  .document('shops/{shopId}')
  .onCreate(async (snapshot, context) => {
    const shopData = snapshot.data();
    const shopName = shopData.name;

    // Generate base slug
    let slug = slugify(shopName, {
      lower: true,
      strict: true,
      remove: /[*+~.()'"!:@]/g,
    });

    // Ensure slug is unique
    let isUnique = false;
    let counter = 0;
    let finalSlug = slug;

    while (!isUnique) {
      const existingShop = await db.collection('shops').where('slug', '==', finalSlug).get();

      if (existingShop.empty) {
        isUnique = true;
      } else {
        counter++;
        finalSlug = `${slug}-${counter}`;
      }
    }

    // Update shop with slug
    await snapshot.ref.update({
      slug: finalSlug,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`Generated slug for shop ${context.params.shopId}: ${finalSlug}`);
    return null;
  });

/**
 * Generate slug for new products
 */
export const generateProductSlug = functions.firestore
  .document('shops/{shopId}/products/{productId}')
  .onCreate(async (snapshot, context) => {
    const productData = snapshot.data();
    const productTitle = productData.title;
    const shopId = context.params.shopId;

    // Generate base slug
    let slug = slugify(productTitle, {
      lower: true,
      strict: true,
      remove: /[*+~.()'"!:@]/g,
    });

    // Ensure slug is unique within shop
    let isUnique = false;
    let counter = 0;
    let finalSlug = slug;

    while (!isUnique) {
      const existingProduct = await db
        .collection('shops')
        .doc(shopId)
        .collection('products')
        .where('slug', '==', finalSlug)
        .get();

      if (existingProduct.empty) {
        isUnique = true;
      } else {
        counter++;
        finalSlug = `${slug}-${counter}`;
      }
    }

    // Update product with slug
    await snapshot.ref.update({
      slug: finalSlug,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`Generated slug for product ${context.params.productId}: ${finalSlug}`);
    return null;
  });

/**
 * Update product count when products are created/deleted
 */
export const updateProductCount = functions.firestore
  .document('shops/{shopId}/products/{productId}')
  .onWrite(async (change, context) => {
    const shopId = context.params.shopId;
    const shopRef = db.collection('shops').doc(shopId);

    const before = change.before.exists && change.before.data()?.isActive;
    const after = change.after.exists && change.after.data()?.isActive;

    let increment = 0;

    if (!before && after) {
      // Product became active
      increment = 1;
    } else if (before && !after) {
      // Product became inactive or deleted
      increment = -1;
    }

    if (increment !== 0) {
      await shopRef.update({
        productCount: admin.firestore.FieldValue.increment(increment),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`Updated product count for shop ${shopId}: ${increment > 0 ? '+' : ''}${increment}`);
    }

    return null;
  });

/**
 * Create default card presets when shop is created
 */
export const createDefaultPresets = functions.firestore
  .document('shops/{shopId}')
  .onCreate(async (snapshot, context) => {
    const shopId = context.params.shopId;
    const presetsRef = db.collection('shops').doc(shopId).collection('card_presets');

    // Default preset configurations
    const defaultPresets = [
      {
        id: 'default_compact',
        name: 'Compact Grid',
        description: 'Compact grid layout for many products',
        layout: 'grid_compact',
        style: {
          visibleFields: ['title', 'price', 'category'],
          imageAspectRatio: '1:1',
          borderRadius: 8,
          elevation: 2,
          typography: {
            titleSize: 14,
            priceSize: 16,
          },
          badges: {
            showNew: true,
            showSale: true,
            position: 'topRight',
          },
          ctaButton: {
            type: 'enquire',
            style: 'filled',
          },
        },
        isDefault: true,
        isActive: true,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      {
        id: 'default_large',
        name: 'Large Grid',
        description: 'Large grid cards with prominent images',
        layout: 'grid_large',
        style: {
          visibleFields: ['title', 'price', 'description'],
          imageAspectRatio: '4:3',
          borderRadius: 12,
          elevation: 3,
          typography: {
            titleSize: 18,
            priceSize: 20,
          },
          badges: {
            showNew: true,
            showSale: true,
            position: 'topRight',
          },
          ctaButton: {
            type: 'whatsapp',
            style: 'filled',
          },
        },
        isDefault: false,
        isActive: true,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
    ];

    // Create presets
    const batch = db.batch();
    defaultPresets.forEach((preset) => {
      const presetRef = presetsRef.doc(preset.id);
      batch.set(presetRef, preset);
    });

    await batch.commit();

    console.log(`Created ${defaultPresets.length} default presets for shop ${shopId}`);
    return null;
  });

/**
 * Send welcome email when user signs up
 * Requires SendGrid or similar email service configured
 */
export const sendWelcomeEmail = functions.auth.user().onCreate(async (user) => {
  const email = user.email;
  const displayName = user.displayName || 'there';

  console.log(`New user signed up: ${email}`);

  // TODO: Implement email sending using SendGrid, Mailgun, or similar
  // For now, just log
  console.log(`Would send welcome email to ${displayName} (${email})`);

  return null;
});

/**
 * Clean up user data when account is deleted
 */
export const cleanupUserData = functions.auth.user().onDelete(async (user) => {
  const userId = user.uid;

  console.log(`User deleted: ${userId}`);

  // Get user's shops
  const shopsSnapshot = await db.collection('shops').where('ownerId', '==', userId).get();

  // Delete or transfer shops
  const batch = db.batch();

  shopsSnapshot.docs.forEach((doc) => {
    // For now, just mark as inactive
    // In production, you might want to transfer ownership or fully delete
    batch.update(doc.ref, {
      isActive: false,
      deletedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  });

  // Delete user document
  const userRef = db.collection('users').doc(userId);
  batch.delete(userRef);

  await batch.commit();

  console.log(`Cleaned up data for deleted user: ${userId}`);
  return null;
});
