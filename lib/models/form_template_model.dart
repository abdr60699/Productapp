import 'package:json_annotation/json_annotation.dart';
import 'form_field_model.dart';

part 'form_template_model.g.dart';

@JsonSerializable()
class FormTemplateModel {
  final String id;
  final String name;
  final String description;
  final List<FormFieldModel> fields;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const FormTemplateModel({
    required this.id,
    required this.name,
    required this.description,
    required this.fields,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  factory FormTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$FormTemplateModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormTemplateModelToJson(this);

  FormTemplateModel copyWith({
    String? id,
    String? name,
    String? description,
    List<FormFieldModel>? fields,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return FormTemplateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      fields: fields ?? this.fields,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  List<FormFieldModel> get sortedFields {
    final sorted = List<FormFieldModel>.from(fields);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }
}