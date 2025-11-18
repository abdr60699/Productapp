# Product Manager App - Version 2.0 Architecture

## 🎯 MVP Scope - Build Fast, Iterate Faster

This document outlines the Firebase-based architecture for the Product Manager app, designed to scale from free tier to production.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Firebase Components](#firebase-components)
3. [Firestore Schema](#firestore-schema)
4. [Implementation Plan](#implementation-plan)
5. [Cost Optimization](#cost-optimization)
6. [Security Rules](#security-rules)
7. [Performance Guidelines](#performance-guidelines)

---

## Overview

### Core Features (MVP)

✅ **User Authentication** - Firebase Auth (Email + Phone OTP)
✅ **Template Builder** - Visual form builder for shop owners
✅ **Product CRUD** - Dynamic product creation via templates
✅ **Image Upload** - Firebase Storage with client-side compression
✅ **Display & Search** - Grid/List/Card views with full-text search
✅ **PWA Hosting** - Firebase Hosting for web storefront

### Key Differentiator

**No fixed class names** - Everything is data-driven. Templates define the structure, products store data as maps.

---

## Firebase Components

### 1. Firebase Authentication
- **Purpose**: Shop owners and optionally customers
- **Methods**: Email/Password, Phone OTP
- **User ID**: Each shop owner has a unique `uid`

### 2. Cloud Firestore
- **Purpose**: Templates & product metadata
- **Benefits**:
  - Structured queries
  - Offline sync
  - Real-time updates
  - Free tier: 1 GiB storage + 50k reads/day + 20k writes/day

### 3. Firebase Storage
- **Purpose**: Product images, thumbnails
- **Strategy**:
  - Store originals + compressed thumbnails
  - Keep URLs in Firestore documents
  - Client-side compression before upload

### 4. Firebase Hosting
- **Purpose**: Host web PWA / public storefront
- **Features**:
  - CDN-backed
  - SSL by default
  - Preview channels
  - Automatic rollbacks

---

## Firestore Schema

### Collection Structure

```
shops/{shopId}/templates/{templateId}
shops/{shopId}/products/{productId}
```

### Template Document

**Path**: `shops/{shopId}/templates/{templateId}`

```json
{
  "id": "template_001",
  "name": "Dress Template",
  "description": "For women's dresses",
  "fields": [
    {
      "id": "f_1",
      "key": "product_name",
      "label": "Product Name",
      "type": "text",
      "options": null,
      "required": true,
      "order": 0,
      "placeholder": "e.g. Summer Dress"
    },
    {
      "id": "f_2",
      "key": "cloth_type",
      "label": "Cloth Type",
      "type": "dropdown",
      "options": ["Cotton", "Silk", "Polyester"],
      "required": false,
      "order": 1
    },
    {
      "id": "f_3",
      "key": "price",
      "label": "Price",
      "type": "number",
      "required": true,
      "order": 2,
      "placeholder": "0.00"
    },
    {
      "id": "f_4",
      "key": "sizes",
      "label": "Available Sizes",
      "type": "multivalue",
      "options": null,
      "required": false,
      "order": 3
    },
    {
      "id": "f_5",
      "key": "images",
      "label": "Product Images",
      "type": "image",
      "required": false,
      "order": 4
    }
  ],
  "createdAt": "2024-11-18T10:00:00Z",
  "updatedAt": "2024-11-18T10:00:00Z",
  "isActive": true
}
```

### Product Document

**Path**: `shops/{shopId}/products/{productId}`

```json
{
  "id": "product_001",
  "templateId": "template_001",
  "templateName": "Dress Template",
  "data": {
    "product_name": "Floral Midi Dress",
    "cloth_type": "Cotton",
    "price": 899.0,
    "sizes": ["S", "M", "L"],
    "images": [
      "gs://bucket/shops/shop_001/products/product_001/img1.jpg",
      "gs://bucket/shops/shop_001/products/product_001/img2.jpg"
    ],
    "description": "Beautiful floral print midi dress"
  },
  "searchTerms": ["floral", "midi", "dress", "cotton"],
  "createdAt": "2024-11-18T11:30:00Z",
  "updatedAt": "2024-11-18T11:30:00Z",
  "isActive": true
}
```

### Field Types Supported

| Type | Description | Example |
|------|-------------|---------|
| `text` | Single-line text input | Product name |
| `number` | Numeric input | Price, quantity |
| `email` | Email validation | Contact email |
| `phone` | Phone number | Contact number |
| `dropdown` | Single selection | Category, size |
| `multiselect` | Multiple checkboxes | Features, colors |
| `radio` | Single choice | Gender, availability |
| `textarea` | Multi-line text | Description |
| `date` | Date picker | Manufacture date |
| `checkbox` | Boolean toggle | Is featured |
| `image` | Image upload | Product photos |
| `multivalue` | Comma-separated values | Tags, sizes |
| `youtube` | YouTube URL | Product video |
| `title` | Display-only heading | Section headers |

---

## Implementation Plan

### Sprint 0: Design & Prototype (3-5 days)

**Tasks:**
- [ ] Wireframes for all screens
- [ ] Firebase project setup
- [ ] Choose field types for MVP
- [ ] Design template builder UX

**Deliverables:**
- UI mockups
- Firebase project created
- Field type specifications

### Sprint 1: MVP Core (1-2 weeks)

**Week 1:**
- [ ] Firebase Auth integration
- [ ] Firestore collections setup
- [ ] Basic security rules
- [ ] Template builder UI
- [ ] Template CRUD operations

**Week 2:**
- [ ] Product form (dynamic rendering)
- [ ] Product CRUD operations
- [ ] Image upload to Storage
- [ ] Product list (grid view)
- [ ] Product detail screen

**Deliverables:**
- Working auth flow
- Template builder functional
- Products can be created/viewed

### Sprint 2: Polish & Operations (1 week)

**Tasks:**
- [ ] Offline persistence
- [ ] Form validation
- [ ] Image compression & thumbnails
- [ ] Firebase Hosting setup
- [ ] Public storefront page
- [ ] Basic analytics
- [ ] Owner dashboard

**Deliverables:**
- Offline-capable app
- Optimized images
- Public storefront live
- Analytics tracking

### Sprint 3: Stability & Scale (1-2 weeks)

**Tasks:**
- [ ] Pagination for product lists
- [ ] Full-text search
- [ ] Template caching
- [ ] Template presets (Clothing, Electronics, etc.)
- [ ] Template import/export (JSON)
- [ ] Security rules review
- [ ] Staging environment
- [ ] Performance optimization

**Deliverables:**
- Scalable product lists
- Search functionality
- Production-ready security
- Performance benchmarks

---

## Cost Optimization

### Free Tier Limits (Important!)

**Firestore:**
- Storage: 1 GiB
- Reads: 50,000/day
- Writes: 20,000/day
- Deletes: 20,000/day

**Storage:**
- Storage: 5 GB
- Downloads: 1 GB/day
- Uploads: Unlimited

**Hosting:**
- Storage: 10 GB
- Transfer: 360 MB/day

### Strategies to Stay Within Free Tier

#### 1. Image Optimization (Critical!)

```dart
// Client-side compression before upload
Future<File> compressImage(File image) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    image.absolute.path,
    image.path + '_compressed.jpg',
    quality: 85,
    minWidth: 800,
    minHeight: 800,
  );
  return result!;
}

// Generate thumbnail
Future<File> generateThumbnail(File image) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    image.absolute.path,
    image.path + '_thumb.jpg',
    quality: 70,
    minWidth: 200,
    minHeight: 200,
  );
  return result!;
}
```

**Limits:**
- Max 3 images per product
- Original: Max 800KB
- Thumbnail: Max 50KB

#### 2. Reduce Firestore Reads

**Cache templates locally:**
```dart
// Load once, cache in SharedPreferences
Future<void> cacheTemplate(Template template) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    'template_${template.id}',
    jsonEncode(template.toJson()),
  );
}

// Check cache first
Future<Template?> getTemplate(String id) async {
  final prefs = await SharedPreferences.getInstance();
  final cached = prefs.getString('template_$id');
  if (cached != null) {
    return Template.fromJson(jsonDecode(cached));
  }
  // Fetch from Firestore if not cached
  return await _fetchFromFirestore(id);
}
```

**Pagination:**
```dart
// Load products in batches
Query query = FirebaseFirestore.instance
    .collection('shops/$shopId/products')
    .limit(20);

if (lastDocument != null) {
  query = query.startAfterDocument(lastDocument);
}
```

#### 3. Minimize Real-Time Listeners

```dart
// BAD: Listen to entire collection
FirebaseFirestore.instance
    .collection('shops/$shopId/products')
    .snapshots(); // 🚫 Expensive!

// GOOD: Load once, update when needed
final snapshot = await FirebaseFirestore.instance
    .collection('shops/$shopId/products')
    .limit(20)
    .get(); // ✅ One-time read
```

#### 4. Batch Operations

```dart
// Batch writes (single write count)
final batch = FirebaseFirestore.instance.batch();

batch.set(productRef, productData);
batch.set(searchIndexRef, searchData);
batch.update(statsRef, {'productCount': FieldValue.increment(1)});

await batch.commit(); // Counts as 3 writes total
```

### Storage Cost Calculation

**Example: Small shop with 500 products**

```
Products: 500
Images per product: 3 (original + 2 angles)
Thumbnails per product: 3

Original images:
500 × 3 × 800 KB = 1,200 MB = 1.2 GB ⚠️ Over limit!

Optimized:
Originals: 500 × 3 × 400 KB = 600 MB
Thumbnails: 500 × 3 × 50 KB = 75 MB
Total: 675 MB ✅ Within 1 GB free tier
```

### Monitoring & Alerts

**Set up billing alerts:**
1. Firebase Console → Usage and billing
2. Set budget alert at $5, $10, $20
3. Monitor daily read/write counts
4. Track storage usage weekly

**Key metrics to watch:**
- Firestore document reads/day
- Storage size (MB)
- Hosting bandwidth (MB/day)
- Active users

---

## Security Rules

### Firestore Rules

**File**: `firestore.rules`

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(shopId) {
      return isSignedIn() && request.auth.uid == shopId;
    }

    // Templates collection
    match /shops/{shopId}/templates/{templateId} {
      // Public read for storefront
      allow read: if true;

      // Only shop owner can write
      allow create, update, delete: if isOwner(shopId);
    }

    // Products collection
    match /shops/{shopId}/products/{productId} {
      // Public read for storefront
      allow read: if true;

      // Only shop owner can write
      allow create, update, delete: if isOwner(shopId);

      // Validate product data
      allow create, update: if isOwner(shopId)
        && request.resource.data.keys().hasAll(['id', 'templateId', 'data'])
        && request.resource.data.data is map;
    }

    // User profiles (optional)
    match /users/{userId} {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && request.auth.uid == userId;
    }
  }
}
```

### Storage Rules

**File**: `storage.rules`

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    // Shop product images
    match /shops/{shopId}/products/{productId}/{imageFile} {
      // Public read for storefront
      allow read: if true;

      // Only shop owner can upload/delete
      allow write: if request.auth != null
        && request.auth.uid == shopId;

      // Validate file size (max 5MB per image)
      allow write: if request.resource.size < 5 * 1024 * 1024;

      // Validate file type (images only)
      allow write: if request.resource.contentType.matches('image/.*');
    }

    // Profile pictures
    match /users/{userId}/profile/{imageFile} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId
        && request.resource.size < 2 * 1024 * 1024
        && request.resource.contentType.matches('image/.*');
    }
  }
}
```

---

## Performance Guidelines

### 1. Offline Persistence

```dart
// Enable offline persistence
await FirebaseFirestore.instance
    .enablePersistence(const PersistenceSettings(synchronizeTabs: true));
```

**Benefits:**
- Works offline
- Faster initial loads
- Reduces read costs

### 2. Index Optimization

**Firestore auto-indexes single fields, but composite indexes must be created manually.**

Example composite index needed:
```
Collection: shops/{shopId}/products
Fields: isActive (Ascending), createdAt (Descending)
```

Create via Firebase Console or `firestore.indexes.json`:

```json
{
  "indexes": [
    {
      "collectionGroup": "products",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "isActive", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "products",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "templateId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

### 3. Query Best Practices

```dart
// GOOD: Specific query with limit
final products = await FirebaseFirestore.instance
    .collection('shops/$shopId/products')
    .where('isActive', isEqualTo: true)
    .orderBy('createdAt', descending: true)
    .limit(20)
    .get();

// BAD: Fetching everything
final allProducts = await FirebaseFirestore.instance
    .collection('shops/$shopId/products')
    .get(); // 🚫 Can be expensive!
```

### 4. Search Implementation

**Simple approach (free tier friendly):**

```dart
// Add search terms array to product
final productData = {
  'data': {...},
  'searchTerms': [
    'floral',
    'midi',
    'dress',
    'cotton',
    'summer'
  ],
};

// Search query
final results = await FirebaseFirestore.instance
    .collection('shops/$shopId/products')
    .where('searchTerms', arrayContains: searchTerm.toLowerCase())
    .limit(20)
    .get();
```

**Advanced approach (if budget allows):**
- Use Algolia (free tier: 10k searches/month)
- Use FlutterFire Cloud Functions with Algolia sync

---

## Mobile-First UX Guidelines

### Form Design

✅ **DO:**
- Vertical single-column forms
- Large tappable targets (min 48dp)
- Bottom-aligned primary actions (thumb zone)
- Camera-first image upload
- Auto-focus first field
- Show validation inline

❌ **DON'T:**
- Multi-column forms on mobile
- Small touch targets
- Top-aligned CTAs
- Require typing URLs
- Show errors in dialogs

### Template Builder UX

**Features:**
- Drag-to-reorder fields
- Inline field editing
- Quick-add presets (Clothing, Electronics, Food)
- Field type icons
- Live preview
- Undo/redo support

**Example preset templates:**
```dart
final clothingPreset = {
  'name': 'Clothing Store',
  'fields': [
    {'key': 'product_name', 'type': 'text', 'required': true},
    {'key': 'price', 'type': 'number', 'required': true},
    {'key': 'sizes', 'type': 'multivalue', 'required': false},
    {'key': 'colors', 'type': 'multiselect', 'required': false},
    {'key': 'images', 'type': 'image', 'required': false},
  ]
};
```

### Product List

**Grid view (default):**
- 2 columns on mobile
- 3-4 columns on tablet
- 5 columns on desktop
- Image-first cards
- Quick actions on long-press

**List view:**
- Full-width items
- Thumbnail + title + price
- Swipe actions (edit, delete)

### Accessibility

- High contrast (4.5:1 minimum)
- Large labels (16sp minimum)
- Touch targets (48dp minimum)
- Screen reader support
- RTL language support

---

## Deployment & Hosting

### Firebase Hosting Setup

**1. Install Firebase CLI:**
```bash
npm install -g firebase-tools
firebase login
```

**2. Initialize Firebase:**
```bash
cd productapp
firebase init hosting
```

**3. Build Flutter web:**
```bash
flutter build web --release
```

**4. Deploy:**
```bash
firebase deploy --only hosting
```

### Hosting Configuration

**File**: `firebase.json`

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(jpg|jpeg|gif|png|webp|svg)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=86400"
          }
        ]
      },
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=604800"
          }
        ]
      }
    ]
  }
}
```

### CI/CD with GitHub Actions

**File**: `.github/workflows/deploy.yml`

```yaml
name: Deploy to Firebase Hosting

on:
  push:
    branches: [ main ]

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - run: flutter pub get
      - run: flutter test
      - run: flutter build web --release

      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          channelId: live
          projectId: your-project-id
```

---

## Monitoring & Analytics

### Firebase Analytics Events

```dart
// Track template creation
await FirebaseAnalytics.instance.logEvent(
  name: 'template_created',
  parameters: {
    'template_id': templateId,
    'field_count': fields.length,
  },
);

// Track product creation
await FirebaseAnalytics.instance.logEvent(
  name: 'product_created',
  parameters: {
    'template_id': templateId,
    'has_images': images.isNotEmpty,
  },
);

// Track image uploads
await FirebaseAnalytics.instance.logEvent(
  name: 'image_uploaded',
  parameters: {
    'file_size': fileSize,
    'compression_ratio': originalSize / compressedSize,
  },
);
```

### Owner Dashboard Metrics

Display to shop owners:
- Total products
- Active products
- Total templates
- Storage used (MB)
- Products by template
- Recent activity

```dart
// Example stats document
final stats = {
  'totalProducts': 150,
  'activeProducts': 145,
  'totalTemplates': 5,
  'storageUsedMB': 245.3,
  'lastProductCreated': '2024-11-18T14:30:00Z',
  'productsByTemplate': {
    'template_001': 80,
    'template_002': 50,
    'template_003': 20,
  }
};
```

---

## Quick Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Exceed 1 GB storage | App stops working | Image compression, thumbnails, limit images/product |
| High read costs | Billing charges | Cache templates, paginate lists, reduce listeners |
| Slow image uploads | Poor UX | Client compression, progress indicators, retry logic |
| Security breach | Data exposed | Proper Firestore rules, auth validation, regular audits |
| Offline conflicts | Data loss | Firestore offline persistence, conflict resolution UI |

---

## Next Steps

1. **Set up Firebase project** - Create project in Firebase Console
2. **Add Firebase to Flutter app** - Install FlutterFire CLI
3. **Implement authentication** - Email + Phone OTP
4. **Create Firestore services** - Template & Product CRUD
5. **Add image upload** - Storage integration with compression
6. **Deploy security rules** - Test in Firebase Console
7. **Enable offline persistence** - Better UX
8. **Set up hosting** - Deploy public storefront
9. **Add analytics** - Track usage
10. **Monitor costs** - Set billing alerts

---

## Useful Resources

- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firestore Pricing](https://firebase.google.com/pricing)
- [Firebase Hosting Docs](https://firebase.google.com/docs/hosting)
- [Cloud Storage Best Practices](https://firebase.google.com/docs/storage/best-practices)

---

**Version**: 2.0
**Last Updated**: 2024-11-18
**Author**: Product Manager Team
