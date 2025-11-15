import '../../domain/entities/template.dart';
import '../../domain/entities/field.dart';
import 'field_model.dart';

class TemplateModel extends Template {
  TemplateModel({
    required super.id,
    required super.shopId,
    required super.name,
    required super.description,
    super.icon,
    required super.category,
    required super.fields,
    super.defaultCardPresetId,
    super.isActive,
    super.isPublic,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TemplateModel.fromEntity(Template template) {
    return TemplateModel(
      id: template.id,
      shopId: template.shopId,
      name: template.name,
      description: template.description,
      icon: template.icon,
      category: template.category,
      fields: template.fields,
      defaultCardPresetId: template.defaultCardPresetId,
      isActive: template.isActive,
      isPublic: template.isPublic,
      createdAt: template.createdAt,
      updatedAt: template.updatedAt,
    );
  }

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
      category: json['category'] as String,
      fields: (json['fields'] as List<dynamic>)
          .map((e) => FieldModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultCardPresetId: json['defaultCardPresetId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isPublic: json['isPublic'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'name': name,
      'description': description,
      'icon': icon,
      'category': category,
      'fields': fields.map((e) => FieldModel.fromEntity(e).toJson()).toList(),
      'defaultCardPresetId': defaultCardPresetId,
      'isActive': isActive,
      'isPublic': isPublic,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Preset templates
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
          id: 'price',
          label: 'Price',
          type: FieldType.number,
          isRequired: true,
          order: 3,
          group: 'Pricing',
        ),
        FieldModel(
          id: 'sizes',
          label: 'Available Sizes',
          type: FieldType.multiselect,
          isRequired: true,
          order: 5,
          group: 'Variants',
          options: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
        ),
        FieldModel(
          id: 'description',
          label: 'Description',
          type: FieldType.textarea,
          isRequired: true,
          order: 9,
          group: 'Details',
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
          options: ['Appetizers', 'Main Course', 'Desserts', 'Beverages'],
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
          id: 'price',
          label: 'Price',
          type: FieldType.number,
          isRequired: true,
          order: 4,
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
