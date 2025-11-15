import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'field_model.dart';

part 'template_model.freezed.dart';
part 'template_model.g.dart';

@freezed
class TemplateModel with _$TemplateModel {
  const factory TemplateModel({
    required String id,
    required String shopId,
    required String name,
    required String description,
    String? icon,
    required String category,
    required List<FieldModel> fields,
    String? defaultCardPresetId,
    @Default(true) bool isActive,
    @Default(false) bool isPublic,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime updatedAt,
  }) = _TemplateModel;

  factory TemplateModel.fromJson(Map<String, dynamic> json) => _$TemplateModelFromJson(json);

  static DateTime _timestampFromJson(dynamic timestamp) {
    if (timestamp is Timestamp) return timestamp.toDate();
    return DateTime.parse(timestamp as String);
  }

  static dynamic _timestampToJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}

const TemplateModel._();

  List<FieldModel> get sortedFields {
    final sorted = List<FieldModel>.from(fields);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  List<FieldModel> getFieldsByGroup(String? group) {
    return sortedFields.where((field) => field.group == group).toList();
  }

  Map<String?, List<FieldModel>> get fieldGroups {
    final Map<String?, List<FieldModel>> groups = {};
    for (final field in sortedFields) {
      if (!groups.containsKey(field.group)) {
        groups[field.group] = [];
      }
      groups[field.group]!.add(field);
    }
    return groups;
  }
}

// Preset template categories
enum TemplateCategory {
  retail('Retail & E-commerce'),
  food('Food & Restaurant'),
  services('Services'),
  realestate('Real Estate'),
  automotive('Automotive'),
  fashion('Fashion & Clothing'),
  electronics('Electronics'),
  furniture('Furniture & Home'),
  custom('Custom');

  final String label;
  const TemplateCategory(this.label);
}

// Preset template definitions
class PresetTemplates {
  static TemplateModel clothing({required String shopId}) {
    return TemplateModel(
      id: 'preset_clothing',
      shopId: shopId,
      name: 'Clothing',
      description: 'Perfect for fashion stores and boutiques',
      icon: '👔',
      category: 'fashion',
      fields: [
        FieldModel(
          id: 'title',
          label: 'Product Name',
          type: FieldType.text,
          isRequired: true,
          order: 0,
          group: 'Basic Info',
        ),
        FieldModel(
          id: 'category',
          label: 'Category',
          type: FieldType.dropdown,
          isRequired: true,
          order: 1,
          group: 'Basic Info',
          options: ['Men', 'Women', 'Kids', 'Unisex'],
        ),
        FieldModel(
          id: 'subcategory',
          label: 'Subcategory',
          type: FieldType.dropdown,
          isRequired: false,
          order: 2,
          group: 'Basic Info',
          options: ['Shirts', 'T-Shirts', 'Jeans', 'Trousers', 'Dresses', 'Tops'],
        ),
        FieldModel(
          id: 'price',
          label: 'Price',
          type: FieldType.number,
          isRequired: true,
          order: 3,
          group: 'Pricing',
        ),
        FieldModel(
          id: 'compareAtPrice',
          label: 'Compare at Price (MRP)',
          type: FieldType.number,
          isRequired: false,
          order: 4,
          group: 'Pricing',
          placeholder: 'Original price for showing discount',
        ),
        FieldModel(
          id: 'sizes',
          label: 'Available Sizes',
          type: FieldType.multiselect,
          isRequired: true,
          order: 5,
          group: 'Variants',
          options: ['XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL'],
        ),
        FieldModel(
          id: 'colors',
          label: 'Available Colors',
          type: FieldType.multiselect,
          isRequired: true,
          order: 6,
          group: 'Variants',
          options: ['Black', 'White', 'Red', 'Blue', 'Green', 'Yellow', 'Pink', 'Grey'],
        ),
        FieldModel(
          id: 'material',
          label: 'Material',
          type: FieldType.text,
          isRequired: false,
          order: 7,
          group: 'Details',
          placeholder: 'e.g., 100% Cotton',
        ),
        FieldModel(
          id: 'brand',
          label: 'Brand',
          type: FieldType.text,
          isRequired: false,
          order: 8,
          group: 'Details',
        ),
        FieldModel(
          id: 'description',
          label: 'Description',
          type: FieldType.textarea,
          isRequired: true,
          order: 9,
          group: 'Details',
        ),
        FieldModel(
          id: 'careInstructions',
          label: 'Care Instructions',
          type: FieldType.textarea,
          isRequired: false,
          order: 10,
          group: 'Details',
          placeholder: 'Washing and care instructions',
        ),
        FieldModel(
          id: 'inStock',
          label: 'In Stock',
          type: FieldType.checkbox,
          isRequired: false,
          order: 11,
          group: 'Inventory',
          defaultValue: 'true',
        ),
        FieldModel(
          id: 'stockQuantity',
          label: 'Stock Quantity',
          type: FieldType.number,
          isRequired: false,
          order: 12,
          group: 'Inventory',
        ),
      ],
      isActive: true,
      isPublic: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static TemplateModel restaurant({required String shopId}) {
    return TemplateModel(
      id: 'preset_restaurant',
      shopId: shopId,
      name: 'Restaurant Menu',
      description: 'For restaurants, cafes, and food businesses',
      icon: '🍽️',
      category: 'food',
      fields: [
        FieldModel(
          id: 'dishName',
          label: 'Dish Name',
          type: FieldType.text,
          isRequired: true,
          order: 0,
          group: 'Basic Info',
        ),
        FieldModel(
          id: 'category',
          label: 'Category',
          type: FieldType.dropdown,
          isRequired: true,
          order: 1,
          group: 'Basic Info',
          options: ['Appetizers', 'Main Course', 'Desserts', 'Beverages', 'Snacks'],
        ),
        FieldModel(
          id: 'cuisine',
          label: 'Cuisine Type',
          type: FieldType.dropdown,
          isRequired: false,
          order: 2,
          group: 'Basic Info',
          options: ['Indian', 'Chinese', 'Italian', 'Mexican', 'Thai', 'Continental'],
        ),
        FieldModel(
          id: 'price',
          label: 'Price',
          type: FieldType.number,
          isRequired: true,
          order: 3,
          group: 'Pricing',
        ),
        FieldModel(
          id: 'description',
          label: 'Description',
          type: FieldType.textarea,
          isRequired: true,
          order: 4,
          group: 'Details',
        ),
        FieldModel(
          id: 'ingredients',
          label: 'Main Ingredients',
          type: FieldType.multivalue,
          isRequired: false,
          order: 5,
          group: 'Details',
        ),
        FieldModel(
          id: 'allergens',
          label: 'Allergens',
          type: FieldType.multiselect,
          isRequired: false,
          order: 6,
          group: 'Details',
          options: ['Nuts', 'Dairy', 'Gluten', 'Soy', 'Eggs', 'Shellfish'],
        ),
        FieldModel(
          id: 'spiceLevel',
          label: 'Spice Level',
          type: FieldType.radio,
          isRequired: false,
          order: 7,
          group: 'Details',
          options: ['Mild', 'Medium', 'Hot', 'Extra Hot'],
        ),
        FieldModel(
          id: 'dietaryInfo',
          label: 'Dietary Information',
          type: FieldType.multiselect,
          isRequired: false,
          order: 8,
          group: 'Details',
          options: ['Vegetarian', 'Vegan', 'Gluten-Free', 'Keto', 'Halal', 'Jain'],
        ),
        FieldModel(
          id: 'servingSize',
          label: 'Serving Size',
          type: FieldType.text,
          isRequired: false,
          order: 9,
          group: 'Details',
          placeholder: 'e.g., Serves 2',
        ),
        FieldModel(
          id: 'available',
          label: 'Currently Available',
          type: FieldType.checkbox,
          isRequired: false,
          order: 10,
          group: 'Availability',
          defaultValue: 'true',
        ),
        FieldModel(
          id: 'chefSpecial',
          label: "Chef's Special",
          type: FieldType.checkbox,
          isRequired: false,
          order: 11,
          group: 'Highlights',
        ),
        FieldModel(
          id: 'bestSeller',
          label: 'Best Seller',
          type: FieldType.checkbox,
          isRequired: false,
          order: 12,
          group: 'Highlights',
        ),
      ],
      isActive: true,
      isPublic: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static TemplateModel electronics({required String shopId}) {
    return TemplateModel(
      id: 'preset_electronics',
      shopId: shopId,
      name: 'Electronics',
      description: 'For electronics and gadgets stores',
      icon: '📱',
      category: 'electronics',
      fields: [
        FieldModel(
          id: 'productName',
          label: 'Product Name',
          type: FieldType.text,
          isRequired: true,
          order: 0,
          group: 'Basic Info',
        ),
        FieldModel(
          id: 'brand',
          label: 'Brand',
          type: FieldType.text,
          isRequired: true,
          order: 1,
          group: 'Basic Info',
        ),
        FieldModel(
          id: 'model',
          label: 'Model Number',
          type: FieldType.text,
          isRequired: false,
          order: 2,
          group: 'Basic Info',
        ),
        FieldModel(
          id: 'category',
          label: 'Category',
          type: FieldType.dropdown,
          isRequired: true,
          order: 3,
          group: 'Basic Info',
          options: ['Mobile Phones', 'Laptops', 'Tablets', 'Accessories', 'Audio', 'Cameras'],
        ),
        FieldModel(
          id: 'price',
          label: 'Price',
          type: FieldType.number,
          isRequired: true,
          order: 4,
          group: 'Pricing',
        ),
        FieldModel(
          id: 'mrp',
          label: 'MRP',
          type: FieldType.number,
          isRequired: false,
          order: 5,
          group: 'Pricing',
        ),
        FieldModel(
          id: 'description',
          label: 'Description',
          type: FieldType.textarea,
          isRequired: true,
          order: 6,
          group: 'Details',
        ),
        FieldModel(
          id: 'specifications',
          label: 'Key Specifications',
          type: FieldType.multivalue,
          isRequired: false,
          order: 7,
          group: 'Details',
        ),
        FieldModel(
          id: 'warranty',
          label: 'Warranty',
          type: FieldType.text,
          isRequired: false,
          order: 8,
          group: 'Details',
          placeholder: 'e.g., 1 Year Manufacturer Warranty',
        ),
        FieldModel(
          id: 'inStock',
          label: 'In Stock',
          type: FieldType.checkbox,
          isRequired: false,
          order: 9,
          group: 'Inventory',
          defaultValue: 'true',
        ),
        FieldModel(
          id: 'sku',
          label: 'SKU',
          type: FieldType.text,
          isRequired: false,
          order: 10,
          group: 'Inventory',
        ),
      ],
      isActive: true,
      isPublic: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static List<TemplateModel> getAllPresets(String shopId) {
    return [
      clothing(shopId: shopId),
      restaurant(shopId: shopId),
      electronics(shopId: shopId),
    ];
  }
}
