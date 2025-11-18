import 'package:uuid/uuid.dart';
import '../models/product_model.dart';
import '../models/form_template_model.dart';
import 'storage_service.dart';

class DummyDataService {
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  /// Creates sample products for all available templates
  Future<void> createSampleProducts(List<FormTemplateModel> templates) async {
    if (templates.isEmpty) return;

    // Check if products already exist
    final existingProducts = await _storageService.getProducts();
    if (existingProducts.isNotEmpty) return;

    for (final template in templates) {
      switch (template.name) {
        case 'Clothing Store':
          await _createClothingSamples(template);
          break;
        case 'Electronics Store':
          await _createElectronicsSamples(template);
          break;
        case 'Restaurant Menu':
          await _createRestaurantSamples(template);
          break;
      }
    }
  }

  Future<void> _createClothingSamples(FormTemplateModel template) async {
    final clothingProducts = [
      {
        'name': 'Classic Blue Denim Jacket',
        'size': 'M',
        'color': 'Navy Blue',
        'price': 89.99,
        'brand': 'Levi\'s',
        'description': 'Premium quality denim jacket with classic western styling. Features authentic arcuate stitching and iconic red tab. Made from 100% cotton denim with a comfortable regular fit.',
      },
      {
        'name': 'Cotton Crew Neck T-Shirt',
        'size': 'L',
        'color': 'White',
        'price': 24.99,
        'brand': 'H&M',
        'description': 'Essential crew neck t-shirt in soft cotton jersey. Classic fit with short sleeves. Perfect for everyday wear and layering.',
      },
      {
        'name': 'Slim Fit Chino Pants',
        'size': 'M',
        'color': 'Khaki',
        'price': 59.99,
        'brand': 'Dockers',
        'description': 'Modern slim fit chino pants with stretch fabric for comfort. Features side pockets and welt back pockets. Versatile style for casual or smart-casual occasions.',
      },
      {
        'name': 'Hooded Sweatshirt',
        'size': 'XL',
        'color': 'Grey',
        'price': 49.99,
        'brand': 'Champion',
        'description': 'Comfortable hooded sweatshirt in soft fleece. Features kangaroo pocket and drawstring hood. Perfect for casual everyday wear.',
      },
      {
        'name': 'Summer Floral Dress',
        'size': 'S',
        'color': 'Floral Print',
        'price': 69.99,
        'brand': 'Zara',
        'description': 'Lightweight summer dress with beautiful floral print. Features short sleeves and knee length. Perfect for warm weather occasions.',
      },
      {
        'name': 'Leather Bomber Jacket',
        'size': 'L',
        'color': 'Black',
        'price': 249.99,
        'brand': 'All Saints',
        'description': 'Premium leather bomber jacket with quilted lining. Features ribbed cuffs and hem with zip closure. Classic style that never goes out of fashion.',
      },
      {
        'name': 'Athletic Running Shorts',
        'size': 'M',
        'color': 'Black',
        'price': 34.99,
        'brand': 'Nike',
        'description': 'Lightweight running shorts with Dri-FIT technology. Features mesh panels for breathability and built-in brief for support.',
      },
      {
        'name': 'Wool Blend Cardigan',
        'size': 'M',
        'color': 'Burgundy',
        'price': 79.99,
        'brand': 'Uniqlo',
        'description': 'Soft wool blend cardigan with button closure. Features ribbed trim and side pockets. Comfortable layer for cooler days.',
      },
    ];

    for (final productData in clothingProducts) {
      final data = _mapFieldsToIds(template, productData);
      final product = ProductModel(
        id: _uuid.v4(),
        templateId: template.id,
        templateName: template.name,
        data: data,
        createdAt: DateTime.now().subtract(Duration(days: clothingProducts.indexOf(productData))),
        updatedAt: DateTime.now().subtract(Duration(days: clothingProducts.indexOf(productData))),
        isActive: true,
      );
      await _storageService.saveProduct(product);
    }
  }

  Future<void> _createElectronicsSamples(FormTemplateModel template) async {
    final electronicsProducts = [
      {
        'name': 'Wireless Bluetooth Headphones Pro',
        'brand': 'Sony',
        'model': 'WH-1000XM5',
        'price': 399.99,
        'warranty': '2 years',
        'specs': 'Driver: 40mm | Frequency: 4Hz-40kHz | Battery: 30 hours | Weight: 250g | Features: Active Noise Cancellation, Touch Controls, Fast Charging, Multipoint Connection',
      },
      {
        'name': 'Smart Watch Series 8',
        'brand': 'Apple',
        'model': 'Watch Series 8',
        'price': 429.00,
        'warranty': '1 year',
        'specs': 'Display: 1.9" OLED | Battery: 18 hours | Features: Heart Rate Monitor, ECG, Blood Oxygen, Sleep Tracking, GPS, Water Resistant 50m',
      },
      {
        'name': '4K Ultra HD Smart TV',
        'brand': 'Samsung',
        'model': 'QN55Q80B',
        'price': 1299.99,
        'warranty': '2 years',
        'specs': 'Size: 55" | Resolution: 4K (3840x2160) | HDR: HDR10+ | Refresh Rate: 120Hz | Smart TV: Tizen OS | Features: Quantum Dot, Object Tracking Sound',
      },
      {
        'name': 'Gaming Laptop',
        'brand': 'ASUS',
        'model': 'ROG Strix G15',
        'price': 1599.99,
        'warranty': '2 years',
        'specs': 'CPU: AMD Ryzen 9 5900HX | GPU: NVIDIA RTX 3070 | RAM: 16GB DDR4 | Storage: 1TB SSD | Display: 15.6" FHD 300Hz | Features: RGB Keyboard, Wi-Fi 6',
      },
      {
        'name': 'Wireless Charging Pad',
        'brand': 'Anker',
        'model': 'PowerWave 15',
        'price': 39.99,
        'warranty': '1 year',
        'specs': 'Power Output: 15W | Compatible: Qi-enabled devices | Features: LED indicator, Case-friendly, Foreign object detection, Multi-protect safety system',
      },
      {
        'name': 'Digital Camera',
        'brand': 'Canon',
        'model': 'EOS R6 Mark II',
        'price': 2499.00,
        'warranty': '2 years',
        'specs': 'Sensor: 24.2MP Full-Frame CMOS | ISO: 100-102400 | Video: 4K 60fps | Autofocus: Dual Pixel AF II | Features: In-body Image Stabilization, Weather Sealed',
      },
      {
        'name': 'Portable Bluetooth Speaker',
        'brand': 'JBL',
        'model': 'Flip 6',
        'price': 129.99,
        'warranty': '1 year',
        'specs': 'Power: 30W | Battery: 12 hours | Features: IP67 Waterproof, PartyBoost, USB-C charging | Connectivity: Bluetooth 5.1',
      },
      {
        'name': 'Wireless Gaming Mouse',
        'brand': 'Logitech',
        'model': 'G502 Lightspeed',
        'price': 149.99,
        'warranty': '2 years',
        'specs': 'Sensor: HERO 25K | DPI: 100-25600 | Battery: 60 hours | Weight: 114g | Features: 11 programmable buttons, PowerPlay compatible, RGB lighting',
      },
      {
        'name': 'Tablet Computer',
        'brand': 'Samsung',
        'model': 'Galaxy Tab S8',
        'price': 699.99,
        'warranty': '1 year',
        'specs': 'Display: 11" LTPS TFT 2560x1600 | Processor: Snapdragon 8 Gen 1 | RAM: 8GB | Storage: 128GB | Features: S Pen included, 120Hz refresh, 8000mAh battery',
      },
    ];

    for (final productData in electronicsProducts) {
      final data = _mapFieldsToIds(template, productData);
      final product = ProductModel(
        id: _uuid.v4(),
        templateId: template.id,
        templateName: template.name,
        data: data,
        createdAt: DateTime.now().subtract(Duration(days: electronicsProducts.indexOf(productData))),
        updatedAt: DateTime.now().subtract(Duration(days: electronicsProducts.indexOf(productData))),
        isActive: true,
      );
      await _storageService.saveProduct(product);
    }
  }

  Future<void> _createRestaurantSamples(FormTemplateModel template) async {
    final restaurantProducts = [
      {
        'name': 'Spicy Thai Green Curry',
        'category': 'Main Course',
        'price': 14.99,
        'ingredients': 'Aromatic green curry paste with coconut milk, Thai basil, bamboo shoots, bell peppers, and your choice of protein.',
        'spice': 'Hot',
        'vegetarian': false,
      },
      {
        'name': 'Margherita Pizza',
        'category': 'Main Course',
        'price': 16.99,
        'ingredients': 'Fresh mozzarella, San Marzano tomatoes, fresh basil, extra virgin olive oil on hand-tossed dough.',
        'spice': 'Mild',
        'vegetarian': true,
      },
      {
        'name': 'Caesar Salad',
        'category': 'Appetizer',
        'price': 9.99,
        'ingredients': 'Crisp romaine lettuce, parmesan cheese, croutons, classic Caesar dressing.',
        'spice': 'Mild',
        'vegetarian': true,
      },
      {
        'name': 'New York Cheesecake',
        'category': 'Dessert',
        'price': 8.99,
        'ingredients': 'Rich and creamy cheesecake on graham cracker crust, topped with fresh strawberry sauce.',
        'spice': 'Mild',
        'vegetarian': true,
      },
      {
        'name': 'Grilled Salmon',
        'category': 'Main Course',
        'price': 24.99,
        'ingredients': 'Fresh Atlantic salmon fillet grilled to perfection, served with lemon butter sauce, seasonal vegetables, and wild rice.',
        'spice': 'Mild',
        'vegetarian': false,
      },
      {
        'name': 'Buffalo Chicken Wings',
        'category': 'Appetizer',
        'price': 12.99,
        'ingredients': 'Crispy chicken wings tossed in spicy buffalo sauce, served with celery sticks and blue cheese dressing.',
        'spice': 'Extra Hot',
        'vegetarian': false,
      },
      {
        'name': 'Chocolate Lava Cake',
        'category': 'Dessert',
        'price': 9.99,
        'ingredients': 'Warm chocolate cake with molten chocolate center, served with vanilla ice cream and fresh berries.',
        'spice': 'Mild',
        'vegetarian': true,
      },
      {
        'name': 'Mango Lassi',
        'category': 'Beverage',
        'price': 5.99,
        'ingredients': 'Refreshing yogurt-based drink blended with sweet alphonso mangoes, cardamom, and a touch of honey.',
        'spice': 'Mild',
        'vegetarian': true,
      },
      {
        'name': 'Beef Tacos',
        'category': 'Main Course',
        'price': 13.99,
        'ingredients': 'Seasoned ground beef in soft corn tortillas with lettuce, cheese, pico de gallo, sour cream, and guacamole.',
        'spice': 'Medium',
        'vegetarian': false,
      },
      {
        'name': 'Spring Rolls',
        'category': 'Appetizer',
        'price': 7.99,
        'ingredients': 'Crispy vegetable spring rolls with shredded cabbage, carrots, glass noodles, served with sweet chili sauce.',
        'spice': 'Mild',
        'vegetarian': true,
      },
      {
        'name': 'Tiramisu',
        'category': 'Dessert',
        'price': 8.99,
        'ingredients': 'Classic Italian dessert with layers of espresso-soaked ladyfingers and mascarpone cream, dusted with cocoa.',
        'spice': 'Mild',
        'vegetarian': true,
      },
      {
        'name': 'Pad Thai Noodles',
        'category': 'Main Course',
        'price': 15.99,
        'ingredients': 'Stir-fried rice noodles with tamarind sauce, eggs, bean sprouts, peanuts, lime, and your choice of protein.',
        'spice': 'Medium',
        'vegetarian': false,
      },
    ];

    for (final productData in restaurantProducts) {
      final data = _mapFieldsToIds(template, productData);
      final product = ProductModel(
        id: _uuid.v4(),
        templateId: template.id,
        templateName: template.name,
        data: data,
        createdAt: DateTime.now().subtract(Duration(days: restaurantProducts.indexOf(productData))),
        updatedAt: DateTime.now().subtract(Duration(days: restaurantProducts.indexOf(productData))),
        isActive: true,
      );
      await _storageService.saveProduct(product);
    }
  }

  /// Maps product data field names to field IDs from the template
  Map<String, dynamic> _mapFieldsToIds(
    FormTemplateModel template,
    Map<String, dynamic> productData,
  ) {
    final Map<String, dynamic> mappedData = {};

    for (final field in template.fields) {
      final fieldTitle = field.title.toLowerCase();

      // Try to match field title with product data keys
      for (final entry in productData.entries) {
        final key = entry.key.toLowerCase();

        if (fieldTitle.contains(key) ||
            key.contains(fieldTitle) ||
            _isFieldMatch(fieldTitle, key)) {
          mappedData[field.id] = entry.value;
          break;
        }
      }
    }

    return mappedData;
  }

  /// Helper method to match field titles with data keys
  bool _isFieldMatch(String fieldTitle, String dataKey) {
    // Handle common variations
    final matches = {
      'product name': ['name', 'product'],
      'dish name': ['name', 'dish'],
      'specifications': ['specs', 'specification'],
      'warranty period': ['warranty', 'warranty period'],
      'spice level': ['spice', 'spicy'],
      'vegetarian': ['vegetarian', 'veg'],
    };

    for (final entry in matches.entries) {
      if (entry.key == fieldTitle && entry.value.contains(dataKey)) {
        return true;
      }
      if (entry.value.contains(fieldTitle) && entry.key.contains(dataKey)) {
        return true;
      }
    }

    return false;
  }
}
