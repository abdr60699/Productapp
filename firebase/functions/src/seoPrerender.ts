import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore();

/**
 * Generate SEO metadata for product pages
 * This can be called by the web app or used for static generation
 */
export const generateProductSEO = functions.https.onCall(async (data, context) => {
  const { shopId, productId } = data;

  if (!shopId || !productId) {
    throw new functions.https.HttpsError('invalid-argument', 'shopId and productId required');
  }

  // Get product data
  const productDoc = await db
    .collection('shops')
    .doc(shopId)
    .collection('products')
    .doc(productId)
    .get();

  if (!productDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Product not found');
  }

  // Get shop data
  const shopDoc = await db.collection('shops').doc(shopId).get();

  if (!shopDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Shop not found');
  }

  const product = productDoc.data()!;
  const shop = shopDoc.data()!;

  // Generate meta tags
  const seo = {
    title: product.seo?.title || `${product.title} | ${shop.name}`,
    description:
      product.seo?.description ||
      product.data?.description ||
      `Buy ${product.title} from ${shop.name}. ${product.category || ''}`,
    keywords: product.seo?.keywords || product.tags || [],
    canonicalUrl: `https://${shop.slug}.productmanager.app/product/${product.slug}`,

    // Open Graph
    og: {
      title: product.seo?.title || product.title,
      description:
        product.seo?.description ||
        product.data?.description ||
        `Buy ${product.title} from ${shop.name}`,
      image: product.images?.[0]?.mediumUrl || product.images?.[0]?.url || shop.logo,
      url: `https://${shop.slug}.productmanager.app/product/${product.slug}`,
      type: 'product',
      siteName: shop.name,
    },

    // Twitter Card
    twitter: {
      card: 'summary_large_image',
      title: product.seo?.title || product.title,
      description:
        product.seo?.description ||
        product.data?.description ||
        `Buy ${product.title} from ${shop.name}`,
      image: product.images?.[0]?.mediumUrl || product.images?.[0]?.url,
    },

    // JSON-LD Product Schema
    jsonLd: generateProductSchema(product, shop),
  };

  return seo;
});

/**
 * Generate JSON-LD structured data for products
 * Helps with Google rich results
 */
function generateProductSchema(product: any, shop: any): object {
  const schema = {
    '@context': 'https://schema.org',
    '@type': 'Product',
    name: product.title,
    description: product.data?.description || product.title,
    image: product.images?.map((img: any) => img.url) || [],
    sku: product.id,
    brand: {
      '@type': 'Brand',
      name: product.data?.brand || shop.name,
    },
  };

  // Add offers if price is available
  if (product.price) {
    (schema as any).offers = {
      '@type': 'Offer',
      url: `https://${shop.slug}.productmanager.app/product/${product.slug}`,
      priceCurrency: 'INR', // TODO: Make this dynamic based on shop settings
      price: product.price,
      priceValidUntil: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0], // 30 days
      itemCondition: 'https://schema.org/NewCondition',
      availability: product.inStock
        ? 'https://schema.org/InStock'
        : 'https://schema.org/OutOfStock',
      seller: {
        '@type': 'Organization',
        name: shop.name,
      },
    };
  }

  // Add aggregate rating if available
  if (product.rating) {
    (schema as any).aggregateRating = {
      '@type': 'AggregateRating',
      ratingValue: product.rating,
      reviewCount: product.reviewCount || 1,
    };
  }

  return schema;
}

/**
 * Generate sitemap.xml for shop
 */
export const generateSitemap = functions.https.onRequest(async (req, res) => {
  const shopSlug = req.hostname.split('.')[0]; // Assuming subdomain-based routing

  // Get shop by slug
  const shopsSnapshot = await db.collection('shops').where('slug', '==', shopSlug).limit(1).get();

  if (shopsSnapshot.empty) {
    res.status(404).send('Shop not found');
    return;
  }

  const shopDoc = shopsSnapshot.docs[0];
  const shopId = shopDoc.id;
  const shop = shopDoc.data();

  // Get all active products
  const productsSnapshot = await db
    .collection('shops')
    .doc(shopId)
    .collection('products')
    .where('isActive', '==', true)
    .orderBy('updatedAt', 'desc')
    .get();

  // Generate sitemap XML
  const baseUrl = `https://${shop.slug}.productmanager.app`;
  let sitemap = '<?xml version="1.0" encoding="UTF-8"?>\n';
  sitemap += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n';

  // Add homepage
  sitemap += `  <url>\n`;
  sitemap += `    <loc>${baseUrl}</loc>\n`;
  sitemap += `    <changefreq>daily</changefreq>\n`;
  sitemap += `    <priority>1.0</priority>\n`;
  sitemap += `  </url>\n`;

  // Add product pages
  productsSnapshot.docs.forEach((doc) => {
    const product = doc.data();
    const lastmod = product.updatedAt?.toDate().toISOString().split('T')[0];

    sitemap += `  <url>\n`;
    sitemap += `    <loc>${baseUrl}/product/${product.slug}</loc>\n`;
    if (lastmod) sitemap += `    <lastmod>${lastmod}</lastmod>\n`;
    sitemap += `    <changefreq>weekly</changefreq>\n`;
    sitemap += `    <priority>0.8</priority>\n`;
    sitemap += `  </url>\n`;
  });

  sitemap += '</urlset>';

  res.set('Content-Type', 'application/xml');
  res.send(sitemap);
});

/**
 * Generate robots.txt
 */
export const generateRobotsTxt = functions.https.onRequest(async (req, res) => {
  const shopSlug = req.hostname.split('.')[0];

  const robotsTxt = `User-agent: *
Allow: /
Disallow: /admin/
Disallow: /api/

Sitemap: https://${shopSlug}.productmanager.app/sitemap.xml
`;

  res.set('Content-Type', 'text/plain');
  res.send(robotsTxt);
});
