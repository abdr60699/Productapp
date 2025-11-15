import 'package:freezed_annotation/freezed_annotation.dart';

part 'field_model.freezed.dart';
part 'field_model.g.dart';

@freezed
class FieldModel with _$FieldModel {
  const factory FieldModel({
    required String id,
    required String label,
    required FieldType type,
    @Default(false) bool isRequired,
    @Default(0) int order,
    String? group,
    String? placeholder,
    String? defaultValue,
    String? helpText,
    List<String>? options,
    FieldValidation? validation,
    ConditionalLogic? conditionalLogic,
  }) = _FieldModel;

  factory FieldModel.fromJson(Map<String, dynamic> json) => _$FieldModelFromJson(json);
}

@freezed
class FieldValidation with _$FieldValidation {
  const factory FieldValidation({
    int? minLength,
    int? maxLength,
    double? min,
    double? max,
    String? pattern,
    String? errorMessage,
  }) = _FieldValidation;

  factory FieldValidation.fromJson(Map<String, dynamic> json) => _$FieldValidationFromJson(json);
}

@freezed
class ConditionalLogic with _$ConditionalLogic {
  const factory ConditionalLogic({
    required String dependsOnFieldId,
    required String condition, // equals, notEquals, contains, greaterThan, lessThan
    required dynamic value,
    @Default(true) bool showWhen, // true = show when condition met, false = hide
  }) = _ConditionalLogic;

  factory ConditionalLogic.fromJson(Map<String, dynamic> json) => _$ConditionalLogicFromJson(json);
}

enum FieldType {
  @JsonValue('text')
  text,

  @JsonValue('number')
  number,

  @JsonValue('email')
  email,

  @JsonValue('phone')
  phone,

  @JsonValue('url')
  url,

  @JsonValue('textarea')
  textarea,

  @JsonValue('dropdown')
  dropdown,

  @JsonValue('multiselect')
  multiselect,

  @JsonValue('radio')
  radio,

  @JsonValue('checkbox')
  checkbox,

  @JsonValue('date')
  date,

  @JsonValue('time')
  time,

  @JsonValue('datetime')
  datetime,

  @JsonValue('image')
  image,

  @JsonValue('images')
  images, // Multiple images

  @JsonValue('multivalue')
  multivalue, // Add multiple text values dynamically

  @JsonValue('youtube')
  youtube,

  @JsonValue('color')
  color,

  @JsonValue('rating')
  rating,

  @JsonValue('title')
  title, // Section title, not an input

  @JsonValue('divider')
  divider; // Visual separator

  String get displayName {
    switch (this) {
      case FieldType.text:
        return 'Text';
      case FieldType.number:
        return 'Number';
      case FieldType.email:
        return 'Email';
      case FieldType.phone:
        return 'Phone';
      case FieldType.url:
        return 'URL';
      case FieldType.textarea:
        return 'Text Area';
      case FieldType.dropdown:
        return 'Dropdown';
      case FieldType.multiselect:
        return 'Multi-Select';
      case FieldType.radio:
        return 'Radio Buttons';
      case FieldType.checkbox:
        return 'Checkbox';
      case FieldType.date:
        return 'Date';
      case FieldType.time:
        return 'Time';
      case FieldType.datetime:
        return 'Date & Time';
      case FieldType.image:
        return 'Single Image';
      case FieldType.images:
        return 'Multiple Images';
      case FieldType.multivalue:
        return 'Multiple Values';
      case FieldType.youtube:
        return 'YouTube Video';
      case FieldType.color:
        return 'Color Picker';
      case FieldType.rating:
        return 'Rating';
      case FieldType.title:
        return 'Section Title';
      case FieldType.divider:
        return 'Divider';
    }
  }

  String get icon {
    switch (this) {
      case FieldType.text:
        return '📝';
      case FieldType.number:
        return '🔢';
      case FieldType.email:
        return '📧';
      case FieldType.phone:
        return '📞';
      case FieldType.url:
        return '🔗';
      case FieldType.textarea:
        return '📄';
      case FieldType.dropdown:
        return '📋';
      case FieldType.multiselect:
        return '☑️';
      case FieldType.radio:
        return '🔘';
      case FieldType.checkbox:
        return '✅';
      case FieldType.date:
        return '📅';
      case FieldType.time:
        return '⏰';
      case FieldType.datetime:
        return '🗓️';
      case FieldType.image:
        return '🖼️';
      case FieldType.images:
        return '🎨';
      case FieldType.multivalue:
        return '📝';
      case FieldType.youtube:
        return '📺';
      case FieldType.color:
        return '🎨';
      case FieldType.rating:
        return '⭐';
      case FieldType.title:
        return '📌';
      case FieldType.divider:
        return '➖';
    }
  }

  bool get requiresOptions {
    return [FieldType.dropdown, FieldType.multiselect, FieldType.radio].contains(this);
  }

  bool get isInput {
    return ![FieldType.title, FieldType.divider].contains(this);
  }
}

// Field type categories for better organization in UI
class FieldTypeCategory {
  final String name;
  final String icon;
  final List<FieldType> types;

  const FieldTypeCategory({
    required this.name,
    required this.icon,
    required this.types,
  });

  static const List<FieldTypeCategory> categories = [
    FieldTypeCategory(
      name: 'Basic Input',
      icon: '✏️',
      types: [
        FieldType.text,
        FieldType.number,
        FieldType.email,
        FieldType.phone,
        FieldType.url,
        FieldType.textarea,
      ],
    ),
    FieldTypeCategory(
      name: 'Selection',
      icon: '☑️',
      types: [
        FieldType.dropdown,
        FieldType.multiselect,
        FieldType.radio,
        FieldType.checkbox,
      ],
    ),
    FieldTypeCategory(
      name: 'Date & Time',
      icon: '📅',
      types: [
        FieldType.date,
        FieldType.time,
        FieldType.datetime,
      ],
    ),
    FieldTypeCategory(
      name: 'Media',
      icon: '🎨',
      types: [
        FieldType.image,
        FieldType.images,
        FieldType.youtube,
        FieldType.color,
      ],
    ),
    FieldTypeCategory(
      name: 'Advanced',
      icon: '⚙️',
      types: [
        FieldType.multivalue,
        FieldType.rating,
      ],
    ),
    FieldTypeCategory(
      name: 'Layout',
      icon: '📐',
      types: [
        FieldType.title,
        FieldType.divider,
      ],
    ),
  ];
}
