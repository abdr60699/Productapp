// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormTemplateModel _$FormTemplateModelFromJson(Map<String, dynamic> json) =>
    FormTemplateModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      fields: (json['fields'] as List<dynamic>)
          .map((e) => FormFieldModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$FormTemplateModelToJson(FormTemplateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'fields': instance.fields,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isActive': instance.isActive,
    };
