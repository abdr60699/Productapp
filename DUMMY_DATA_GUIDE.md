# Dummy Data Guide

## Overview

This guide details all the dummy data that has been added to the Product Management App. The app now comes pre-loaded with 29 sample products across 3 different templates (categories).

## How to Run the App

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code with Flutter extensions
- An Android/iOS device or emulator

### Steps to Run
```bash
# Navigate to project directory
cd /path/to/Productapp

# Get dependencies
flutter pub get

# Run the app
flutter run
```

On first launch, the app will automatically:
1. Create 3 sample templates (Clothing Store, Electronics Store, Restaurant Menu)
2. Load 29 dummy products into these templates
3. Display them on the home screen

---

## Template Structures

### 1. Clothing Store Template
**Fields:**
- Product Name (text, required)
- Size (dropdown: XS, S, M, L, XL, XXL, required)
- Color (text, required)
- Price (number, required)
- Brand (text, optional)
- Description (textarea, optional)

### 2. Electronics Store Template
**Fields:**
- Product Name (text, required)
- Brand (text, required)
- Model (text, required)
- Price (number, required)
- Warranty Period (dropdown: 6 months, 1 year, 2 years, 3 years, optional)
- Specifications (textarea, optional)

### 3. Restaurant Menu Template
**Fields:**
- Dish Name (text, required)
- Category (dropdown: Appetizer, Main Course, Dessert, Beverage, required)
- Price (number, required)
- Ingredients (textarea, optional)
- Spice Level (radio: Mild, Medium, Hot, Extra Hot, optional)
- Vegetarian (checkbox, optional)

---

## Sample Products Added

### Clothing Store (8 Products)

#### 1. Classic Blue Denim Jacket
```json
{
  "name": "Classic Blue Denim Jacket",
  "size": "M",
  "color": "Navy Blue",
  "price": 89.99,
  "brand": "Levi's",
  "description": "Premium quality denim jacket with classic western styling. Features authentic arcuate stitching and iconic red tab. Made from 100% cotton denim with a comfortable regular fit."
}
```

#### 2. Cotton Crew Neck T-Shirt
```json
{
  "name": "Cotton Crew Neck T-Shirt",
  "size": "L",
  "color": "White",
  "price": 24.99,
  "brand": "H&M",
  "description": "Essential crew neck t-shirt in soft cotton jersey. Classic fit with short sleeves. Perfect for everyday wear and layering."
}
```

#### 3. Slim Fit Chino Pants
```json
{
  "name": "Slim Fit Chino Pants",
  "size": "M",
  "color": "Khaki",
  "price": 59.99,
  "brand": "Dockers",
  "description": "Modern slim fit chino pants with stretch fabric for comfort. Features side pockets and welt back pockets. Versatile style for casual or smart-casual occasions."
}
```

#### 4. Hooded Sweatshirt
```json
{
  "name": "Hooded Sweatshirt",
  "size": "XL",
  "color": "Grey",
  "price": 49.99,
  "brand": "Champion",
  "description": "Comfortable hooded sweatshirt in soft fleece. Features kangaroo pocket and drawstring hood. Perfect for casual everyday wear."
}
```

#### 5. Summer Floral Dress
```json
{
  "name": "Summer Floral Dress",
  "size": "S",
  "color": "Floral Print",
  "price": 69.99,
  "brand": "Zara",
  "description": "Lightweight summer dress with beautiful floral print. Features short sleeves and knee length. Perfect for warm weather occasions."
}
```

#### 6. Leather Bomber Jacket
```json
{
  "name": "Leather Bomber Jacket",
  "size": "L",
  "color": "Black",
  "price": 249.99,
  "brand": "All Saints",
  "description": "Premium leather bomber jacket with quilted lining. Features ribbed cuffs and hem with zip closure. Classic style that never goes out of fashion."
}
```

#### 7. Athletic Running Shorts
```json
{
  "name": "Athletic Running Shorts",
  "size": "M",
  "color": "Black",
  "price": 34.99,
  "brand": "Nike",
  "description": "Lightweight running shorts with Dri-FIT technology. Features mesh panels for breathability and built-in brief for support."
}
```

#### 8. Wool Blend Cardigan
```json
{
  "name": "Wool Blend Cardigan",
  "size": "M",
  "color": "Burgundy",
  "price": 79.99,
  "brand": "Uniqlo",
  "description": "Soft wool blend cardigan with button closure. Features ribbed trim and side pockets. Comfortable layer for cooler days."
}
```

---

### Electronics Store (9 Products)

#### 1. Wireless Bluetooth Headphones Pro
```json
{
  "name": "Wireless Bluetooth Headphones Pro",
  "brand": "Sony",
  "model": "WH-1000XM5",
  "price": 399.99,
  "warranty": "2 years",
  "specs": "Driver: 40mm | Frequency: 4Hz-40kHz | Battery: 30 hours | Weight: 250g | Features: Active Noise Cancellation, Touch Controls, Fast Charging, Multipoint Connection"
}
```

#### 2. Smart Watch Series 8
```json
{
  "name": "Smart Watch Series 8",
  "brand": "Apple",
  "model": "Watch Series 8",
  "price": 429.00,
  "warranty": "1 year",
  "specs": "Display: 1.9\" OLED | Battery: 18 hours | Features: Heart Rate Monitor, ECG, Blood Oxygen, Sleep Tracking, GPS, Water Resistant 50m"
}
```

#### 3. 4K Ultra HD Smart TV
```json
{
  "name": "4K Ultra HD Smart TV",
  "brand": "Samsung",
  "model": "QN55Q80B",
  "price": 1299.99,
  "warranty": "2 years",
  "specs": "Size: 55\" | Resolution: 4K (3840x2160) | HDR: HDR10+ | Refresh Rate: 120Hz | Smart TV: Tizen OS | Features: Quantum Dot, Object Tracking Sound"
}
```

#### 4. Gaming Laptop
```json
{
  "name": "Gaming Laptop",
  "brand": "ASUS",
  "model": "ROG Strix G15",
  "price": 1599.99,
  "warranty": "2 years",
  "specs": "CPU: AMD Ryzen 9 5900HX | GPU: NVIDIA RTX 3070 | RAM: 16GB DDR4 | Storage: 1TB SSD | Display: 15.6\" FHD 300Hz | Features: RGB Keyboard, Wi-Fi 6"
}
```

#### 5. Wireless Charging Pad
```json
{
  "name": "Wireless Charging Pad",
  "brand": "Anker",
  "model": "PowerWave 15",
  "price": 39.99,
  "warranty": "1 year",
  "specs": "Power Output: 15W | Compatible: Qi-enabled devices | Features: LED indicator, Case-friendly, Foreign object detection, Multi-protect safety system"
}
```

#### 6. Digital Camera
```json
{
  "name": "Digital Camera",
  "brand": "Canon",
  "model": "EOS R6 Mark II",
  "price": 2499.00,
  "warranty": "2 years",
  "specs": "Sensor: 24.2MP Full-Frame CMOS | ISO: 100-102400 | Video: 4K 60fps | Autofocus: Dual Pixel AF II | Features: In-body Image Stabilization, Weather Sealed"
}
```

#### 7. Portable Bluetooth Speaker
```json
{
  "name": "Portable Bluetooth Speaker",
  "brand": "JBL",
  "model": "Flip 6",
  "price": 129.99,
  "warranty": "1 year",
  "specs": "Power: 30W | Battery: 12 hours | Features: IP67 Waterproof, PartyBoost, USB-C charging | Connectivity: Bluetooth 5.1"
}
```

#### 8. Wireless Gaming Mouse
```json
{
  "name": "Wireless Gaming Mouse",
  "brand": "Logitech",
  "model": "G502 Lightspeed",
  "price": 149.99,
  "warranty": "2 years",
  "specs": "Sensor: HERO 25K | DPI: 100-25600 | Battery: 60 hours | Weight: 114g | Features: 11 programmable buttons, PowerPlay compatible, RGB lighting"
}
```

#### 9. Tablet Computer
```json
{
  "name": "Tablet Computer",
  "brand": "Samsung",
  "model": "Galaxy Tab S8",
  "price": 699.99,
  "warranty": "1 year",
  "specs": "Display: 11\" LTPS TFT 2560x1600 | Processor: Snapdragon 8 Gen 1 | RAM: 8GB | Storage: 128GB | Features: S Pen included, 120Hz refresh, 8000mAh battery"
}
```

---

### Restaurant Menu (12 Products)

#### 1. Spicy Thai Green Curry
```json
{
  "name": "Spicy Thai Green Curry",
  "category": "Main Course",
  "price": 14.99,
  "ingredients": "Aromatic green curry paste with coconut milk, Thai basil, bamboo shoots, bell peppers, and your choice of protein.",
  "spice": "Hot",
  "vegetarian": false
}
```

#### 2. Margherita Pizza
```json
{
  "name": "Margherita Pizza",
  "category": "Main Course",
  "price": 16.99,
  "ingredients": "Fresh mozzarella, San Marzano tomatoes, fresh basil, extra virgin olive oil on hand-tossed dough.",
  "spice": "Mild",
  "vegetarian": true
}
```

#### 3. Caesar Salad
```json
{
  "name": "Caesar Salad",
  "category": "Appetizer",
  "price": 9.99,
  "ingredients": "Crisp romaine lettuce, parmesan cheese, croutons, classic Caesar dressing.",
  "spice": "Mild",
  "vegetarian": true
}
```

#### 4. New York Cheesecake
```json
{
  "name": "New York Cheesecake",
  "category": "Dessert",
  "price": 8.99,
  "ingredients": "Rich and creamy cheesecake on graham cracker crust, topped with fresh strawberry sauce.",
  "spice": "Mild",
  "vegetarian": true
}
```

#### 5. Grilled Salmon
```json
{
  "name": "Grilled Salmon",
  "category": "Main Course",
  "price": 24.99,
  "ingredients": "Fresh Atlantic salmon fillet grilled to perfection, served with lemon butter sauce, seasonal vegetables, and wild rice.",
  "spice": "Mild",
  "vegetarian": false
}
```

#### 6. Buffalo Chicken Wings
```json
{
  "name": "Buffalo Chicken Wings",
  "category": "Appetizer",
  "price": 12.99,
  "ingredients": "Crispy chicken wings tossed in spicy buffalo sauce, served with celery sticks and blue cheese dressing.",
  "spice": "Extra Hot",
  "vegetarian": false
}
```

#### 7. Chocolate Lava Cake
```json
{
  "name": "Chocolate Lava Cake",
  "category": "Dessert",
  "price": 9.99,
  "ingredients": "Warm chocolate cake with molten chocolate center, served with vanilla ice cream and fresh berries.",
  "spice": "Mild",
  "vegetarian": true
}
```

#### 8. Mango Lassi
```json
{
  "name": "Mango Lassi",
  "category": "Beverage",
  "price": 5.99,
  "ingredients": "Refreshing yogurt-based drink blended with sweet alphonso mangoes, cardamom, and a touch of honey.",
  "spice": "Mild",
  "vegetarian": true
}
```

#### 9. Beef Tacos
```json
{
  "name": "Beef Tacos",
  "category": "Main Course",
  "price": 13.99,
  "ingredients": "Seasoned ground beef in soft corn tortillas with lettuce, cheese, pico de gallo, sour cream, and guacamole.",
  "spice": "Medium",
  "vegetarian": false
}
```

#### 10. Spring Rolls
```json
{
  "name": "Spring Rolls",
  "category": "Appetizer",
  "price": 7.99,
  "ingredients": "Crispy vegetable spring rolls with shredded cabbage, carrots, glass noodles, served with sweet chili sauce.",
  "spice": "Mild",
  "vegetarian": true
}
```

#### 11. Tiramisu
```json
{
  "name": "Tiramisu",
  "category": "Dessert",
  "price": 8.99,
  "ingredients": "Classic Italian dessert with layers of espresso-soaked ladyfingers and mascarpone cream, dusted with cocoa.",
  "spice": "Mild",
  "vegetarian": true
}
```

#### 12. Pad Thai Noodles
```json
{
  "name": "Pad Thai Noodles",
  "category": "Main Course",
  "price": 15.99,
  "ingredients": "Stir-fried rice noodles with tamarind sauce, eggs, bean sprouts, peanuts, lime, and your choice of protein.",
  "spice": "Medium",
  "vegetarian": false
}
```

---

## App UI Structure

### Home Screen
When you launch the app, you'll see:
- **App Bar**: "Product Manager" title with settings menu
- **Product Display Area**: Shows all 29 products in a scrollable view
- **Display Options**: Can switch between:
  - Grid view (default)
  - List view
  - Card view
- **Floating Action Button**: Orange "+" button to add new products

### Product List Features
- Products are grouped by category (Clothing Store, Electronics Store, Restaurant Menu)
- Each product card shows:
  - Product name
  - Key details (price, brand/category)
  - Template name
  - Last updated timestamp
- Search functionality to find products
- Category filters

### Product Detail Screen
Tap any product to see:
- Full product information
- All field values
- Creation and update timestamps
- Edit button
- Delete button

### Add New Product
Tap the "+" button to:
1. Select a template (Clothing, Electronics, or Restaurant)
2. Fill out dynamic form based on template fields
3. Form validates required fields
4. Save to create new product

### Settings Screen
Access via menu button:
- Template management
- View/create/edit/delete templates
- Display preferences
- Statistics (total products, products by category)
- Clear all data option

---

## Technical Details

### Data Storage
- All data stored locally using SharedPreferences
- JSON serialization for products and templates
- Persistent across app restarts

### Data Initialization
Location: `lib/services/dummy_data_service.dart`

The DummyDataService:
- Automatically runs on first app launch
- Checks if products already exist (won't duplicate)
- Maps product data to template field IDs dynamically
- Creates products with realistic timestamps (staggered by days)

### Integration Point
Location: `lib/screens/home_screen.dart:31-52`

```dart
Future<void> _loadData() async {
  final templateNotifier = ref.read(templateProvider.notifier);
  final productNotifier = ref.read(productProvider.notifier);
  final dummyDataService = DummyDataService();

  await Future.wait([
    templateNotifier.loadTemplates(),
    productNotifier.loadProducts(),
  ]);

  // Create sample templates if none exist
  if (ref.read(templateProvider).templates.isEmpty) {
    await templateNotifier.createSampleTemplates();
  }

  // Create sample products if none exist
  final templates = ref.read(templateProvider).templates;
  if (ref.read(productProvider).products.isEmpty && templates.isNotEmpty) {
    await dummyDataService.createSampleProducts(templates);
    await productNotifier.loadProducts();
  }
}
```

---

## Customization

### Adding More Dummy Data
Edit `/lib/services/dummy_data_service.dart`:

1. Add new products to existing categories:
```dart
final clothingProducts = [
  // Add your product here
  {
    'name': 'Your Product',
    'size': 'M',
    'color': 'Blue',
    'price': 99.99,
    'brand': 'Brand Name',
    'description': 'Product description',
  },
  // ... existing products
];
```

2. Create new category templates in `template_provider.dart`
3. Add corresponding dummy data method in `dummy_data_service.dart`

### Clearing Dummy Data
From Settings screen:
1. Tap settings icon in app bar
2. Scroll to "Clear All Data"
3. Confirm deletion
4. Restart app to regenerate dummy data

---

## Summary

✅ **29 sample products** across 3 categories
✅ **3 pre-configured templates** with different field types
✅ **Automatic initialization** on first launch
✅ **Realistic product data** with detailed descriptions
✅ **Full CRUD operations** available for all products
✅ **Dynamic forms** based on templates
✅ **Search and filter** capabilities
✅ **Multiple view options** (grid, list, card)
✅ **Local persistence** with SharedPreferences

The app is now ready to demonstrate with rich, realistic data!
