import 'field.dart';

class Template {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final String? icon;
  final String category;
  final List<Field> fields;
  final String? defaultCardPresetId;
  final bool isActive;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  Template({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    this.icon,
    required this.category,
    required this.fields,
    this.defaultCardPresetId,
    this.isActive = true,
    this.isPublic = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Template copyWith({
    String? id,
    String? shopId,
    String? name,
    String? description,
    String? icon,
    String? category,
    List<Field>? fields,
    String? defaultCardPresetId,
    bool? isActive,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Template(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      fields: fields ?? this.fields,
      defaultCardPresetId: defaultCardPresetId ?? this.defaultCardPresetId,
      isActive: isActive ?? this.isActive,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  List<Field> get sortedFields {
    final fieldsCopy = List<Field>.from(fields);
    fieldsCopy.sort((a, b) => a.order.compareTo(b.order));
    return fieldsCopy;
  }

  List<Field> getFieldsByGroup(String? group) {
    return fields.where((field) => field.group == group).toList();
  }

  Map<String?, List<Field>> get fieldGroups {
    final groups = <String?, List<Field>>{};
    for (final field in fields) {
      if (!groups.containsKey(field.group)) {
        groups[field.group] = [];
      }
      groups[field.group]!.add(field);
    }
    return groups;
  }
}

enum TemplateCategory {
  retail,
  food,
  services,
  realestate,
  automotive,
  fashion,
  electronics,
  furniture,
  custom;

  String get displayName {
    switch (this) {
      case TemplateCategory.retail:
        return 'Retail';
      case TemplateCategory.food:
        return 'Food & Beverage';
      case TemplateCategory.services:
        return 'Services';
      case TemplateCategory.realestate:
        return 'Real Estate';
      case TemplateCategory.automotive:
        return 'Automotive';
      case TemplateCategory.fashion:
        return 'Fashion';
      case TemplateCategory.electronics:
        return 'Electronics';
      case TemplateCategory.furniture:
        return 'Furniture';
      case TemplateCategory.custom:
        return 'Custom';
    }
  }
}
