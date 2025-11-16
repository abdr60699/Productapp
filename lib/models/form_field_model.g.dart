// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_field_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormFieldModel _$FormFieldModelFromJson(Map<String, dynamic> json) =>
    FormFieldModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$FormFieldTypeEnumMap, json['type']),
      isRequired: json['isRequired'] as bool? ?? false,
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      placeholder: json['placeholder'] as String?,
      defaultValue: json['defaultValue'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FormFieldModelToJson(FormFieldModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$FormFieldTypeEnumMap[instance.type]!,
      'isRequired': instance.isRequired,
      'options': instance.options,
      'placeholder': instance.placeholder,
      'defaultValue': instance.defaultValue,
      'order': instance.order,
    };

const _$FormFieldTypeEnumMap = {
  FormFieldType.text: 'text',
  FormFieldType.number: 'number',
  FormFieldType.email: 'email',
  FormFieldType.phone: 'phone',
  FormFieldType.dropdown: 'dropdown',
  FormFieldType.multiselect: 'multiselect',
  FormFieldType.textarea: 'textarea',
  FormFieldType.date: 'date',
  FormFieldType.checkbox: 'checkbox',
  FormFieldType.radio: 'radio',
  FormFieldType.image: 'image',
  FormFieldType.multivalue: 'multivalue',
  FormFieldType.youtube: 'youtube',
  FormFieldType.title: 'title',
};
