import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as express from 'express';
import * as cors from 'cors';

const db = admin.firestore();
const app = express();

// Enable CORS for all routes
app.use(cors({ origin: true }));

/**
 * Public API to get shop data
 */
app.get('/shop/:slug', async (req, res) => {
  try {
    const slug = req.params.slug;

    const shopsSnapshot = await db
      .collection('shops')
      .where('slug', '==', slug)
      .where('isActive', '==', true)
      .limit(1)
      .get();

    if (shopsSnapshot.empty) {
      res.status(404).json({ error: 'Shop not found' });
      return;
    }

    const shopDoc = shopsSnapshot.docs[0];
    const shopData = shopDoc.data();

    res.json({
      id: shopDoc.id,
      name: shopData.name,
      slug: shopData.slug,
      description: shopData.description,
      logo: shopData.logo,
      coverImage: shopData.coverImage,
      brandColors: shopData.brandColors,
      contactInfo: shopData.contactInfo,
      socialLinks: shopData.socialLinks,
    });
  } catch (error) {
    console.error('Error fetching shop:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Public API to get shop products
 */
app.get('/shop/:slug/products', async (req, res) => {
  try {
    const slug = req.params.slug;
    const page = parseInt(req.query.page as string) || 1;
    const limit = Math.min(parseInt(req.query.limit as string) || 20, 100);
    const category = req.query.category as string;
    const featured = req.query.featured === 'true';

    // Get shop
    const shopsSnapshot = await db
      .collection('shops')
      .where('slug', '==', slug)
      .where('isActive', '==', true)
      .limit(1)
      .get();

    if (shopsSnapshot.empty) {
      res.status(404).json({ error: 'Shop not found' });
      return;
    }

    const shopDoc = shopsSnapshot.docs[0];
    const shopId = shopDoc.id;

    // Build query
    let query = db
      .collection('shops')
      .doc(shopId)
      .collection('products')
      .where('isActive', '==', true) as admin.firestore.Query;

    if (category) {
      query = query.where('category', '==', category);
    }

    if (featured) {
      query = query.where('featured', '==', true);
    }

    query = query.orderBy('createdAt', 'desc').limit(limit);

    // Apply pagination
    if (page > 1) {
      const offset = (page - 1) * limit;
      const previousSnapshot = await query.get();
      if (previousSnapshot.docs.length > 0) {
        const lastDoc = previousSnapshot.docs[previousSnapshot.docs.length - 1];
        query = query.startAfter(lastDoc);
      }
    }

    const productsSnapshot = await query.get();

    const products = productsSnapshot.docs.map((doc) => {
      const data = doc.data();
      return {
        id: doc.id,
        title: data.title,
        slug: data.slug,
        category: data.category,
        price: data.price,
        compareAtPrice: data.compareAtPrice,
        images: data.images,
        tags: data.tags,
        inStock: data.inStock,
        featured: data.featured,
        createdAt: data.createdAt,
      };
    });

    res.json({
      products,
      page,
      limit,
      hasMore: products.length === limit,
    });
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Public API to get single product
 */
app.get('/shop/:slug/product/:productSlug', async (req, res) => {
  try {
    const { slug, productSlug } = req.params;

    // Get shop
    const shopsSnapshot = await db
      .collection('shops')
      .where('slug', '==', slug)
      .where('isActive', '==', true)
      .limit(1)
      .get();

    if (shopsSnapshot.empty) {
      res.status(404).json({ error: 'Shop not found' });
      return;
    }

    const shopDoc = shopsSnapshot.docs[0];
    const shopId = shopDoc.id;

    // Get product
    const productsSnapshot = await db
      .collection('shops')
      .doc(shopId)
      .collection('products')
      .where('slug', '==', productSlug)
      .where('isActive', '==', true)
      .limit(1)
      .get();

    if (productsSnapshot.empty) {
      res.status(404).json({ error: 'Product not found' });
      return;
    }

    const productDoc = productsSnapshot.docs[0];
    const productData = productDoc.data();

    res.json({
      id: productDoc.id,
      ...productData,
      shop: {
        id: shopDoc.id,
        name: shopDoc.data().name,
        slug: shopDoc.data().slug,
      },
    });
  } catch (error) {
    console.error('Error fetching product:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * API to create lead/enquiry
 */
app.post('/shop/:slug/lead', async (req, res) => {
  try {
    const slug = req.params.slug;
    const { productId, type, customerInfo, message } = req.body;

    if (!productId || !type) {
      res.status(400).json({ error: 'productId and type are required' });
      return;
    }

    // Get shop
    const shopsSnapshot = await db
      .collection('shops')
      .where('slug', '==', slug)
      .where('isActive', '==', true)
      .limit(1)
      .get();

    if (shopsSnapshot.empty) {
      res.status(404).json({ error: 'Shop not found' });
      return;
    }

    const shopDoc = shopsSnapshot.docs[0];
    const shopId = shopDoc.id;

    // Create lead
    const leadRef = await db
      .collection('shops')
      .doc(shopId)
      .collection('leads')
      .add({
        shopId,
        productId,
        type,
        customerInfo: customerInfo || {},
        message: message || '',
        source: 'storefront',
        status: 'new',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    res.json({
      success: true,
      leadId: leadRef.id,
    });
  } catch (error) {
    console.error('Error creating lead:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Export the Express app as a Cloud Function
export const api = functions.https.onRequest(app);
