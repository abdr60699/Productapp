import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String id;
  final String templateId;
  final String templateName;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const ProductModel({
    required this.id,
    required this.templateId,
    required this.templateName,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductModel copyWith({
    String? id,
    String? templateId,
    String? templateName,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return ProductModel(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      templateName: templateName ?? this.templateName,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  String? getFieldValue(String fieldId) {
    return data[fieldId]?.toString();
  }

  String get displayName {
    final nameField = data['name'] ?? data['title'] ?? data['product_name'];
    return nameField?.toString() ?? 'Unnamed Product';
  }
}