# Product Manager - Complete Architecture Documentation

## 🏗️ System Architecture

### Overview
Multi-tenant SaaS platform built on Flutter + Firebase for mobile-first product catalog management.

## Technology Stack

### Frontend
- **Flutter**: 3.24.0+ (latest stable)
- **Dart**: 3.5.0+
- **State Management**: Riverpod 2.5.0+
- **Navigation**: go_router 14.0.0+
- **UI Framework**: Material 3

### Backend
- **Firebase**:
  - Authentication (Email/Google/Phone)
  - Firestore (Multi-tenant database)
  - Cloud Storage (Images/media)
  - Cloud Functions (Node.js 20)
  - Firebase Hosting (PWA deployment)
  - Firebase Analytics
  - Cloud Messaging (Notifications)

### Search & Analytics
- **Algolia**: Product search & filtering
- **Firebase Analytics**: User behavior tracking
- **Custom Analytics**: Product performance metrics

### Media Processing
- **Cloud Functions**: Image compression, WebP/AVIF generation
- **Sharp**: Image processing library
- **Cloud Storage**: CDN-optimized delivery

## 🗂️ Project Structure

```
product_manager/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── config/
│   │   │   ├── firebase_config.dart
│   │   │   ├── algolia_config.dart
│   │   │   └── app_config.dart
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── field_types.dart
│   │   │   └── card_layouts.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── color_schemes.dart
│   │   │   ├── text_styles.dart
│   │   │   └── dimensions.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── formatters.dart
│   │   │   ├── extensions.dart
│   │   │   └── helpers.dart
│   │   ├── errors/
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   └── router/
│   │       ├── app_router.dart
│   │       └── route_guards.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── shop_model.dart
│   │   │   ├── template_model.dart
│   │   │   ├── product_model.dart
│   │   │   ├── field_model.dart
│   │   │   ├── card_style_model.dart
│   │   │   ├── card_preset_model.dart
│   │   │   ├── analytics_model.dart
│   │   │   └── user_model.dart
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── shop_repository.dart
│   │   │   ├── template_repository.dart
│   │   │   ├── product_repository.dart
│   │   │   ├── card_preset_repository.dart
│   │   │   ├── storage_repository.dart
│   │   │   ├── analytics_repository.dart
│   │   │   └── search_repository.dart
│   │   └── services/
│   │       ├── firebase_service.dart
│   │       ├── storage_service.dart
│   │       ├── algolia_service.dart
│   │       ├── image_compression_service.dart
│   │       └── offline_sync_service.dart
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── shop.dart
│   │   │   ├── template.dart
│   │   │   ├── product.dart
│   │   │   ├── field.dart
│   │   │   └── card_style.dart
│   │   └── usecases/
│   │       ├── template/
│   │       │   ├── create_template.dart
│   │       │   ├── update_template.dart
│   │       │   └── delete_template.dart
│   │       ├── product/
│   │       │   ├── create_product.dart
│   │       │   ├── update_product.dart
│   │       │   └── delete_product.dart
│   │       └── analytics/
│   │           ├── track_product_view.dart
│   │           └── get_analytics_data.dart
│   │
│   ├── presentation/
│   │   ├── providers/
│   │   │   ├── auth_provider.dart
│   │   │   ├── shop_provider.dart
│   │   │   ├── template_provider.dart
│   │   │   ├── product_provider.dart
│   │   │   ├── card_style_provider.dart
│   │   │   ├── analytics_provider.dart
│   │   │   └── theme_provider.dart
│   │   │
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── signup_screen.dart
│   │   │   │   └── onboarding_screen.dart
│   │   │   ├── dashboard/
│   │   │   │   ├── dashboard_screen.dart
│   │   │   │   └── widgets/
│   │   │   ├── templates/
│   │   │   │   ├── template_list_screen.dart
│   │   │   │   ├── template_builder_screen.dart
│   │   │   │   ├── template_preview_screen.dart
│   │   │   │   └── widgets/
│   │   │   ├── products/
│   │   │   │   ├── product_list_screen.dart
│   │   │   │   ├── product_form_screen.dart
│   │   │   │   ├── product_detail_screen.dart
│   │   │   │   ├── bulk_import_screen.dart
│   │   │   │   └── widgets/
│   │   │   ├── card_builder/
│   │   │   │   ├── card_style_editor_screen.dart
│   │   │   │   ├── card_preview_screen.dart
│   │   │   │   └── widgets/
│   │   │   ├── storefront/
│   │   │   │   ├── storefront_home_screen.dart
│   │   │   │   ├── storefront_product_screen.dart
│   │   │   │   ├── storefront_category_screen.dart
│   │   │   │   └── widgets/
│   │   │   ├── analytics/
│   │   │   │   ├── analytics_dashboard_screen.dart
│   │   │   │   └── widgets/
│   │   │   └── settings/
│   │   │       ├── settings_screen.dart
│   │   │       ├── shop_settings_screen.dart
│   │   │       └── profile_screen.dart
│   │   │
│   │   └── widgets/
│   │       ├── common/
│   │       │   ├── app_button.dart
│   │       │   ├── app_text_field.dart
│   │       │   ├── loading_indicator.dart
│   │       │   ├── error_widget.dart
│   │       │   └── empty_state.dart
│   │       ├── fields/
│   │       │   ├── dynamic_field_widget.dart
│   │       │   ├── text_field_widget.dart
│   │       │   ├── dropdown_field_widget.dart
│   │       │   ├── image_field_widget.dart
│   │       │   └── multivalue_field_widget.dart
│   │       └── cards/
│   │           ├── product_card.dart
│   │           ├── card_grid_compact.dart
│   │           ├── card_grid_large.dart
│   │           ├── card_list_view.dart
│   │           ├── card_media_dominant.dart
│   │           ├── card_minimal.dart
│   │           └── card_premium.dart
│   │
│   └── generated/
│       └── (freezed/json_serializable generated files)
│
├── firebase/
│   ├── functions/
│   │   ├── src/
│   │   │   ├── index.ts
│   │   │   ├── imageProcessing.ts
│   │   │   ├── seoPrerender.ts
│   │   │   ├── algoliaSync.ts
│   │   │   ├── analytics.ts
│   │   │   └── triggers.ts
│   │   ├── package.json
│   │   └── tsconfig.json
│   ├── firestore.rules
│   ├── storage.rules
│   └── firestore.indexes.json
│
├── web/
│   ├── index.html
│   ├── manifest.json
│   ├── firebase-config.js
│   └── service-worker.js
│
├── assets/
│   ├── images/
│   ├── icons/
│   ├── fonts/
│   └── presets/
│
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
│
├── docs/
│   ├── API.md
│   ├── DEPLOYMENT.md
│   └── USER_GUIDE.md
│
├── scripts/
│   ├── deploy.sh
│   └── setup.sh
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── deploy.yml
│
├── pubspec.yaml
├── analysis_options.yaml
├── firebase.json
├── .firebaserc
└── README.md
```

## 🗄️ Database Schema (Firestore)

### Multi-Tenant Structure

```
firestore/
│
├── users/
│   └── {userId}
│       ├── email: string
│       ├── displayName: string
│       ├── photoUrl: string
│       ├── role: string
│       ├── shopId: string (reference)
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── shops/
│   └── {shopId}
│       ├── name: string
│       ├── slug: string (unique)
│       ├── ownerId: string
│       ├── description: string
│       ├── logo: string
│       ├── coverImage: string
│       ├── brandColors: object
│       │   ├── primary: string
│       │   └── accent: string
│       ├── contactInfo: object
│       │   ├── phone: string
│       │   ├── whatsapp: string
│       │   ├── email: string
│       │   └── address: string
│       ├── socialLinks: object
│       ├── seoSettings: object
│       │   ├── title: string
│       │   ├── description: string
│       │   └── keywords: array
│       ├── isActive: boolean
│       ├── plan: string (free/pro/enterprise)
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── shops/{shopId}/templates/
│   └── {templateId}
│       ├── name: string
│       ├── description: string
│       ├── icon: string
│       ├── category: string
│       ├── fields: array<Field>
│       │   ├── id: string
│       │   ├── label: string
│       │   ├── type: string
│       │   ├── required: boolean
│       │   ├── order: number
│       │   ├── group: string
│       │   ├── options: array (for dropdown/multiselect)
│       │   ├── validation: object
│       │   └── conditionalLogic: object
│       ├── defaultCardPresetId: string
│       ├── isActive: boolean
│       ├── isPublic: boolean
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── shops/{shopId}/products/
│   └── {productId}
│       ├── templateId: string
│       ├── templateName: string (denormalized)
│       ├── slug: string
│       ├── title: string (indexed)
│       ├── data: map<string, dynamic>
│       ├── images: array<object>
│       │   ├── url: string
│       │   ├── thumbUrl: string
│       │   ├── mediumUrl: string
│       │   └── order: number
│       ├── tags: array<string> (indexed)
│       ├── category: string (indexed)
│       ├── price: number (indexed)
│       ├── compareAtPrice: number
│       ├── inStock: boolean
│       ├── featured: boolean
│       ├── cardPresetId: string
│       ├── seo: object
│       │   ├── title: string
│       │   ├── description: string
│       │   └── keywords: array
│       ├── isActive: boolean
│       ├── createdAt: timestamp
│       ├── updatedAt: timestamp
│       └── publishedAt: timestamp
│
├── shops/{shopId}/card_presets/
│   └── {presetId}
│       ├── name: string
│       ├── description: string
│       ├── layout: string (grid_compact/grid_large/list/media_dominant/minimal/premium)
│       ├── style: object
│       │   ├── visibleFields: array<string>
│       │   ├── fieldOrder: array<string>
│       │   ├── imageAspectRatio: string
│       │   ├── borderRadius: number
│       │   ├── elevation: number
│       │   ├── showShadow: boolean
│       │   ├── typography: object
│       │   │   ├── titleSize: number
│       │   │   ├── priceSize: number
│       │   │   └── bodySize: number
│       │   ├── badges: object
│       │   │   ├── showNew: boolean
│       │   │   ├── showSale: boolean
│       │   │   ├── showOutOfStock: boolean
│       │   │   ├── position: string
│       │   │   └── colors: object
│       │   ├── ctaButton: object
│       │   │   ├── type: string (call/whatsapp/enquire/cart)
│       │   │   ├── label: string
│       │   │   └── style: object
│       │   └── colors: object
│       ├── isDefault: boolean
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── shops/{shopId}/analytics/
│   ├── daily/
│   │   └── {yyyy-mm-dd}
│   │       ├── totalViews: number
│   │       ├── uniqueVisitors: number
│   │       ├── productViews: map<productId, number>
│   │       ├── ctaClicks: map<type, number>
│   │       └── topProducts: array
│   ├── weekly/{yyyy-Www}/
│   └── monthly/{yyyy-mm}/
│
├── shops/{shopId}/leads/
│   └── {leadId}
│       ├── productId: string
│       ├── type: string (call/whatsapp/enquire)
│       ├── customerInfo: object
│       ├── message: string
│       ├── source: string
│       ├── createdAt: timestamp
│       └── status: string
│
└── templates_public/
    └── {templateId}
        ├── name: string
        ├── description: string
        ├── category: string
        ├── icon: string
        ├── fields: array<Field>
        ├── previewImage: string
        ├── usageCount: number
        ├── rating: number
        └── createdBy: string
```

## 🔐 Security Rules

### Firestore Rules Strategy

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function isShopOwner(shopId) {
      return isAuthenticated() &&
        get(/databases/$(database)/documents/shops/$(shopId)).data.ownerId == request.auth.uid;
    }

    function isShopMember(shopId) {
      return isAuthenticated() &&
        exists(/databases/$(database)/documents/shops/$(shopId)/members/$(request.auth.uid));
    }

    function hasShopAccess(shopId) {
      return isShopOwner(shopId) || isShopMember(shopId);
    }

    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated() && request.auth.uid == userId;
      allow create: if isAuthenticated() && request.auth.uid == userId;
      allow update: if isAuthenticated() && request.auth.uid == userId;
    }

    // Shops collection
    match /shops/{shopId} {
      allow read: if true; // Public storefront
      allow create: if isAuthenticated();
      allow update, delete: if isShopOwner(shopId);

      // Templates subcollection
      match /templates/{templateId} {
        allow read: if hasShopAccess(shopId);
        allow write: if hasShopAccess(shopId);
      }

      // Products subcollection
      match /products/{productId} {
        allow read: if true; // Public products
        allow write: if hasShopAccess(shopId);
      }

      // Card presets subcollection
      match /card_presets/{presetId} {
        allow read: if hasShopAccess(shopId);
        allow write: if hasShopAccess(shopId);
      }

      // Analytics subcollection
      match /analytics/{document=**} {
        allow read: if hasShopAccess(shopId);
        allow write: if false; // Only Cloud Functions
      }

      // Leads subcollection
      match /leads/{leadId} {
        allow read: if hasShopAccess(shopId);
        allow create: if true; // Public can create leads
        allow update: if hasShopAccess(shopId);
      }
    }

    // Public templates
    match /templates_public/{templateId} {
      allow read: if true;
      allow write: if false; // Only admins via Cloud Functions
    }
  }
}
```

## 🔄 State Management (Riverpod)

### Provider Architecture

```dart
// Global Providers
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final storageProvider = Provider((ref) => FirebaseStorage.instance);

// Current User
final currentUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// Current Shop
final currentShopProvider = StreamProvider<Shop?>((ref) async* {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) {
    yield null;
    return;
  }

  final userDoc = await ref.read(firestoreProvider)
    .collection('users')
    .doc(user.uid)
    .get();

  final shopId = userDoc.data()?['shopId'];
  if (shopId == null) {
    yield null;
    return;
  }

  yield* ref.read(shopRepositoryProvider).watchShop(shopId);
});

// Templates
final templatesProvider = StreamProvider.family<List<Template>, String>((ref, shopId) {
  return ref.read(templateRepositoryProvider).watchTemplates(shopId);
});

// Products
final productsProvider = StreamProvider.family<List<Product>, String>((ref, shopId) {
  return ref.read(productRepositoryProvider).watchProducts(shopId);
});

// Card Presets
final cardPresetsProvider = StreamProvider.family<List<CardPreset>, String>((ref, shopId) {
  return ref.read(cardPresetRepositoryProvider).watchPresets(shopId);
});

// Analytics
final analyticsProvider = FutureProvider.family<AnalyticsData, DateRange>((ref, dateRange) {
  final shopId = ref.watch(currentShopProvider).value?.id;
  if (shopId == null) throw Exception('No shop');
  return ref.read(analyticsRepositoryProvider).getAnalytics(shopId, dateRange);
});
```

## 🎨 Theme System (Material 3)

### Dynamic Theming Based on Shop Brand Colors

```dart
final themeProvider = Provider<ThemeData>((ref) {
  final shop = ref.watch(currentShopProvider).value;
  final isDark = ref.watch(isDarkModeProvider);

  final primaryColor = shop?.brandColors.primary ?? Colors.orange;
  final accentColor = shop?.brandColors.accent ?? Colors.deepOrange;

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ),
    // ... rest of theme config
  );
});
```

## 📡 API Integration Points

### Algolia Search

```typescript
// Index structure
const productIndex = {
  indexName: `shops_${shopId}_products`,
  settings: {
    searchableAttributes: [
      'title',
      'tags',
      'category',
      'data.*'
    ],
    attributesForFaceting: [
      'category',
      'tags',
      'inStock',
      'featured'
    ],
    customRanking: ['desc(featured)', 'desc(createdAt)']
  }
};
```

## 🚀 Deployment Architecture

### Hosting Structure

```
Firebase Hosting:
├── /admin -> Flutter Web (Admin dashboard)
├── /shop/{slug} -> Pre-rendered storefront pages
└── /api -> Cloud Functions endpoints
```

### CI/CD Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main]
jobs:
  deploy:
    steps:
      - Build Flutter web
      - Deploy to Firebase Hosting
      - Deploy Cloud Functions
      - Update Algolia indexes
```

## 📊 Performance Optimizations

1. **Image Optimization**: WebP/AVIF, lazy loading, responsive images
2. **Code Splitting**: Route-based code splitting
3. **Caching**: Service Worker caching, Firestore offline persistence
4. **CDN**: Firebase Hosting CDN for global delivery
5. **Indexing**: Composite indexes for complex queries
6. **Pagination**: Cursor-based pagination for large lists

## 🔒 Security Best Practices

1. **Multi-tenant isolation**: Shop-level security rules
2. **Role-based access**: Owner/Editor/Viewer roles
3. **Data validation**: Server-side validation in Cloud Functions
4. **Rate limiting**: Cloud Functions rate limiting
5. **CORS**: Proper CORS configuration
6. **API keys**: Environment-based key management

---

This architecture supports:
- ✅ Scalability to 100k+ shops
- ✅ Offline-first mobile experience
- ✅ SEO-optimized public storefronts
- ✅ Real-time updates
- ✅ Multi-tenant isolation
- ✅ Production-grade security
