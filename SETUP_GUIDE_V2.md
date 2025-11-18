# Firebase Setup Guide - Version 2.0

Complete step-by-step guide to set up Firebase for the Product Manager app.

---

## 📋 Prerequisites

- Flutter SDK installed
- Node.js and npm installed
- Google account
- Android Studio / Xcode (for mobile testing)

---

## 🚀 Step 1: Create Firebase Project

### 1.1 Firebase Console Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Enter project name: `product-manager-app`
4. **Enable Google Analytics**: Yes (recommended)
5. Choose Analytics account or create new
6. Click **"Create project"**
7. Wait for project creation (30-60 seconds)

### 1.2 Enable Required Services

**Authentication:**
1. In Firebase Console, go to **Authentication**
2. Click **"Get started"**
3. Enable **Email/Password**
   - Toggle "Email/Password" → Enable
   - Click "Save"
4. Enable **Phone** (optional for MVP, add later)
   - Toggle "Phone" → Enable
   - Add test phone numbers for development

**Firestore Database:**
1. Go to **Firestore Database**
2. Click **"Create database"**
3. Choose **"Start in test mode"** (we'll add rules later)
4. Select location: `us-central` or nearest region
5. Click **"Enable"**

**Storage:**
1. Go to **Storage**
2. Click **"Get started"**
3. Start in **test mode**
4. Use same location as Firestore
5. Click **"Done"**

**Hosting:**
1. Go to **Hosting**
2. Click **"Get started"**
3. Follow wizard (we'll configure via CLI later)

---

## 🔧 Step 2: Install Firebase CLI

### 2.1 Install Firebase Tools

```bash
# Install Firebase CLI globally
npm install -g firebase-tools

# Verify installation
firebase --version
```

### 2.2 Login to Firebase

```bash
# Login with your Google account
firebase login

# You should see: "Success! Logged in as your-email@gmail.com"
```

---

## 📱 Step 3: Add Firebase to Flutter App

### 3.1 Install FlutterFire CLI

```bash
# Activate FlutterFire CLI
dart pub global activate flutterfire_cli

# Verify installation
flutterfire --version
```

### 3.2 Configure Firebase for Your App

```bash
# Navigate to your project
cd /path/to/Productapp

# Configure FlutterFire (this creates firebase_options.dart)
flutterfire configure

# Select your Firebase project: product-manager-app
# Select platforms: iOS, Android, Web
# This will create: lib/firebase_options.dart
```

### 3.3 Update pubspec.yaml

Add Firebase dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.1

  # Firebase core
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  firebase_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  firebase_analytics: ^10.7.4

  # Image handling
  image_picker: ^1.0.7
  flutter_image_compress: ^2.1.0

  # Existing dependencies...
  shared_preferences: ^2.2.3
  uuid: ^4.4.0
  flutter_screenutil: ^5.9.3
  google_fonts: ^6.2.1
  file_picker: ^8.0.0+1
  image: ^4.1.7
  url_launcher: ^6.2.5
  intl: ^0.20.2
```

Install dependencies:

```bash
flutter pub get
```

---

## 🔐 Step 4: Initialize Firebase in App

### 4.1 Update main.dart

Replace your `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Product Manager',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: child,
        );
      },
      child: const HomeScreen(),
    );
  }
}
```

---

## 🛡️ Step 5: Deploy Security Rules

### 5.1 Create firestore.rules

Create file: `firestore.rules`

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(shopId) {
      return isSignedIn() && request.auth.uid == shopId;
    }

    // Templates
    match /shops/{shopId}/templates/{templateId} {
      allow read: if true;
      allow create, update, delete: if isOwner(shopId);
    }

    // Products
    match /shops/{shopId}/products/{productId} {
      allow read: if true;
      allow create, update, delete: if isOwner(shopId);
    }
  }
}
```

### 5.2 Create storage.rules

Create file: `storage.rules`

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    match /shops/{shopId}/products/{productId}/{imageFile} {
      allow read: if true;
      allow write: if request.auth != null
        && request.auth.uid == shopId
        && request.resource.size < 5 * 1024 * 1024
        && request.resource.contentType.matches('image/.*');
    }
  }
}
```

### 5.3 Deploy Rules

```bash
# Initialize Firebase in project
firebase init

# Select:
# - Firestore
# - Storage
# - Hosting

# Use existing firestore.rules and storage.rules

# Deploy rules
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
```

---

## 📊 Step 6: Create Firestore Indexes

### 6.1 Create firestore.indexes.json

Create file: `firestore.indexes.json`

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
  ],
  "fieldOverrides": []
}
```

### 6.2 Deploy Indexes

```bash
firebase deploy --only firestore:indexes
```

---

## 🌐 Step 7: Configure Hosting

### 7.1 Build Flutter Web

```bash
flutter build web --release
```

### 7.2 Create firebase.json

Create file: `firebase.json`

```json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "storage": {
    "rules": "storage.rules"
  },
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
      }
    ]
  }
}
```

### 7.3 Deploy to Hosting

```bash
firebase deploy --only hosting
```

Your app will be live at: `https://product-manager-app.web.app`

---

## 🧪 Step 8: Test Firebase Integration

### 8.1 Test Authentication

```bash
# Run app
flutter run -d chrome

# Test:
# 1. Sign up with email/password
# 2. Sign in
# 3. Check Firebase Console → Authentication → Users
```

### 8.2 Test Firestore

```bash
# Create a template
# Check Firebase Console → Firestore → shops/{uid}/templates

# Create a product
# Check Firebase Console → Firestore → shops/{uid}/products
```

### 8.3 Test Storage

```bash
# Upload an image in a product
# Check Firebase Console → Storage → shops/{uid}/products
```

---

## 📈 Step 9: Enable Offline Persistence

Add to your Firestore service:

```dart
import 'package:firebase_firestore/firebase_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> enableOffline() async {
    await _firestore.enablePersistence(
      const PersistenceSettings(synchronizeTabs: true),
    );
  }
}
```

Call in main.dart:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable offline persistence
  await FirebaseFirestore.instance.enablePersistence();

  runApp(const ProviderScope(child: MyApp()));
}
```

---

## 🔔 Step 10: Set Up Billing Alerts

### 10.1 Enable Billing

1. Go to Firebase Console
2. Click **"Upgrade"** (Blaze plan - pay as you go)
3. Set up billing account
4. Set budget alerts:
   - $5 threshold → email alert
   - $10 threshold → email alert
   - $20 threshold → email alert

### 10.2 Monitor Usage

**Daily checks:**
- Firestore reads/writes
- Storage size
- Hosting bandwidth

**Weekly checks:**
- Cost dashboard
- Usage patterns
- Optimization opportunities

---

## 🐛 Troubleshooting

### Common Issues

**Issue: "Firebase app not initialized"**
```dart
// Solution: Ensure Firebase.initializeApp() is called before runApp()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}
```

**Issue: "Permission denied" when writing to Firestore**
```javascript
// Solution: Check your firestore.rules
// Ensure user is authenticated and owns the shop
match /shops/{shopId}/products/{productId} {
  allow write: if request.auth != null && request.auth.uid == shopId;
}
```

**Issue: "Storage upload failed"**
```javascript
// Solution: Check storage.rules and file size
match /shops/{shopId}/products/{productId}/{imageFile} {
  allow write: if request.auth != null
    && request.auth.uid == shopId
    && request.resource.size < 5 * 1024 * 1024;  // 5MB limit
}
```

**Issue: "Index required" error**
```bash
# Solution: Firebase will show exact index needed in error
# Either:
# 1. Click the link in error to auto-create index
# 2. Add to firestore.indexes.json and deploy
```

---

## ✅ Verification Checklist

- [ ] Firebase project created
- [ ] Authentication enabled (Email/Password)
- [ ] Firestore database created
- [ ] Storage bucket created
- [ ] FlutterFire CLI installed
- [ ] `firebase_options.dart` generated
- [ ] Firebase packages added to pubspec.yaml
- [ ] Security rules deployed
- [ ] Indexes created
- [ ] Offline persistence enabled
- [ ] Hosting configured
- [ ] Billing alerts set up
- [ ] Test user created
- [ ] Test template created
- [ ] Test product created
- [ ] Test image uploaded

---

## 📚 Next Steps

1. **Implement Authentication UI** → See `FIREBASE_AUTH_V2.md`
2. **Create Firestore Services** → See `FIRESTORE_SERVICES_V2.md`
3. **Add Image Upload** → See `IMAGE_UPLOAD_V2.md`
4. **Deploy to Production** → See `DEPLOYMENT_V2.md`

---

## 🆘 Support Resources

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Firebase Support](https://firebase.google.com/support)
- [StackOverflow - Firebase](https://stackoverflow.com/questions/tagged/firebase)
- [FlutterFire GitHub Issues](https://github.com/firebase/flutterfire/issues)

---

**Version**: 2.0
**Last Updated**: 2024-11-18
