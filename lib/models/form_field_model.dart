import 'package:json_annotation/json_annotation.dart';

part 'form_field_model.g.dart';

@JsonSerializable()
class FormFieldModel {
  final String id;
  final String title;
  final FormFieldType type;
  final bool isRequired;
  final List<String>? options;
  final String? placeholder;
  final String? defaultValue;
  final int order;

  const FormFieldModel({
    required this.id,
    required this.title,
    required this.type,
    this.isRequired = false,
    this.options,
    this.placeholder,
    this.defaultValue,
    this.order = 0,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) =>
      _$FormFieldModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormFieldModelToJson(this);

  FormFieldModel copyWith({
    String? id,
    String? title,
    FormFieldType? type,
    bool? isRequired,
    List<String>? options,
    String? placeholder,
    String? defaultValue,
    int? order,
  }) {
    return FormFieldModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      isRequired: isRequired ?? this.isRequired,
      options: options ?? this.options,
      placeholder: placeholder ?? this.placeholder,
      defaultValue: defaultValue ?? this.defaultValue,
      order: order ?? this.order,
    );
  }
}

enum FormFieldType {
  @JsonValue('text')
  text,
  @JsonValue('number')
  number,
  @JsonValue('email')
  email,
  @JsonValue('phone')
  phone,
  @JsonValue('dropdown')
  dropdown,
  @JsonValue('multiselect')
  multiselect,
  @JsonValue('textarea')
  textarea,
  @JsonValue('date')
  date,
  @JsonValue('checkbox')
  checkbox,
  @JsonValue('radio')
  radio,
  @JsonValue('image')
  image,
  @JsonValue('multivalue')
  multivalue,
  @JsonValue('youtube')
  youtube,
  @JsonValue('title')
  title,
}