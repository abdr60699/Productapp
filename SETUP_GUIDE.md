# Quick Setup Guide

## ⚡ Fix the Errors & See the UI

Follow these steps on your local machine:

### Step 1: Install Dependencies

```bash
flutter pub get
```

This will install all the packages including:
- `freezed_annotation` - For model annotations
- `cloud_firestore` - For Firebase integration
- `freezed` - For code generation

### Step 2: Generate Required Files

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This command will generate:
- `*.freezed.dart` files (for Freezed models)
- `*.g.dart` files (for JSON serialization)

The generation might take 1-2 minutes. You'll see output like:
```
[INFO] Generating build script completed, took 442ms
[INFO] Creating build script snapshot... completed, took 10.7s
[INFO] Building new asset graph completed, took 1.2s
[INFO] Checking for unexpected pre-existing outputs. completed, took 1ms
[INFO] Running build completed, took 12.3s
[INFO] Caching finalized dependency graph completed, took 38ms
[INFO] Succeeded after 12.4s with 38 outputs
```

### Step 3: Test with Sample Data

The sample data file has been created at:
```
lib/data/sample_data.dart
```

It contains:
- ✅ **1 Sample Shop** (StyleHub Fashion Store)
- ✅ **1 Template** (Clothing template with 9 fields)
- ✅ **5 Sample Products**:
  1. Cotton Casual T-Shirt (Black) - ₹799 (Featured, On Sale)
  2. Denim Jeans (Blue Slim Fit) - ₹1499 (On Sale)
  3. Floral Summer Dress - ₹1299 (Featured)
  4. Kids Cartoon Hoodie - ₹899 (On Sale)
  5. Premium Leather Jacket - ₹4999 (Featured, Out of Stock, On Sale)
- ✅ **3 Card Presets** (Compact, Large, Premium)

### Step 4: Use Sample Data in Your App

In any screen, you can use the sample data:

```dart
import 'package:productapp/data/sample_data.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get sample products
    final products = SampleData.products;

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          title: Text(product.title),
          subtitle: Text('₹${product.price}'),
          leading: Image.network(
            product.primaryImageThumbUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
```

### Step 5: Run Your App

```bash
# Run on Android/iOS
flutter run

# Or run on Web
flutter run -d chrome
```

---

## 🎨 Sample Data Details

### Shop Data
```dart
final shop = SampleData.shop;
print(shop.name); // "StyleHub Fashion Store"
print(shop.brandColors.primary); // "#FF6B35"
print(shop.contactInfo.phone); // "+91 98765 43210"
```

### Template Data
```dart
final template = SampleData.clothingTemplate;
print(template.name); // "Clothing"
print(template.fields.length); // 9 fields
```

### Product Data
```dart
final products = SampleData.products;
print(products.length); // 5 products

// First product details
final product = products[0];
print(product.title); // "Cotton Casual T-Shirt - Black"
print(product.price); // 799
print(product.compareAtPrice); // 1299
print(product.discountPercentage); // 38.49%
print(product.isOnSale); // true
print(product.featured); // true
print(product.images.length); // 2 images
```

### Card Preset Data
```dart
final presets = SampleData.cardPresets;
print(presets.length); // 3 presets

final compact = presets[0];
print(compact.layout); // CardLayout.gridCompact
print(compact.style.borderRadius); // 8.0
```

---

## 🐛 Troubleshooting

### Error: "Could not find package"
**Solution**: Run `flutter pub get` again

### Error: "Build runner failed"
**Solution**:
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error: "URI doesn't exist" after running build_runner
**Solution**: Restart your IDE/VS Code after build_runner completes

---

## ✅ What You'll See

After running `build_runner`, all errors will disappear and you'll have:

1. **Working Models**: All 5 model files will compile without errors
2. **Sample Data**: Ready-to-use data for testing UI
3. **Type Safety**: Full autocomplete and type checking

---

## 🚀 Next Steps

1. **Create a simple product list screen** using sample data
2. **Test different card layouts** with the 3 presets
3. **Build product detail screen** showing all product info
4. **Implement search** and filtering
5. **Add product form** for creating/editing products

---

## 💡 Quick Test Widget

Create `lib/screens/test_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../data/sample_data.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = SampleData.products;

    return Scaffold(
      appBar: AppBar(
        title: Text(SampleData.shop.name),
        backgroundColor: Color(int.parse(
          SampleData.shop.brandColors.primary.replaceFirst('#', '0xFF')
        )),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        product.primaryImageUrl,
                        fit: BoxFit.cover,
                      ),
                      // Sale Badge
                      if (product.isOnSale)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${product.discountPercentage?.toStringAsFixed(0)}% OFF',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      // Featured Badge
                      if (product.featured)
                        const Positioned(
                          top: 8,
                          left: 8,
                          child: Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                        ),
                    ],
                  ),
                ),
                // Product Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '₹${product.price}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            if (product.compareAtPrice != null) ...[
                              const SizedBox(width: 4),
                              Text(
                                '₹${product.compareAtPrice}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const Spacer(),
                        if (!product.inStock)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Out of Stock',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

Then use it in `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'screens/test_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const TestScreen(),
    );
  }
}
```

Run the app and you'll see a beautiful product grid with 5 sample products! 🎉
