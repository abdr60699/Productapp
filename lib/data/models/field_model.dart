import '../../domain/entities/field.dart';

class FieldModel extends Field {
  FieldModel({
    required super.id,
    required super.label,
    required super.type,
    super.isRequired,
    super.order,
    super.group,
    super.placeholder,
    super.defaultValue,
    super.helpText,
    super.options,
    super.validation,
    super.conditionalLogic,
  });

  factory FieldModel.fromEntity(Field field) {
    return FieldModel(
      id: field.id,
      label: field.label,
      type: field.type,
      isRequired: field.isRequired,
      order: field.order,
      group: field.group,
      placeholder: field.placeholder,
      defaultValue: field.defaultValue,
      helpText: field.helpText,
      options: field.options,
      validation: field.validation,
      conditionalLogic: field.conditionalLogic,
    );
  }

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    return FieldModel(
      id: json['id'] as String,
      label: json['label'] as String,
      type: FieldType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FieldType.text,
      ),
      isRequired: json['isRequired'] as bool? ?? false,
      order: json['order'] as int? ?? 0,
      group: json['group'] as String?,
      placeholder: json['placeholder'] as String?,
      defaultValue: json['defaultValue'] as String?,
      helpText: json['helpText'] as String?,
      options: (json['options'] as List<dynamic>?)?.cast<String>(),
      validation: json['validation'] != null
          ? FieldValidationModel.fromJson(json['validation'] as Map<String, dynamic>)
          : null,
      conditionalLogic: json['conditionalLogic'] != null
          ? ConditionalLogicModel.fromJson(json['conditionalLogic'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'type': type.name,
      'isRequired': isRequired,
      'order': order,
      'group': group,
      'placeholder': placeholder,
      'defaultValue': defaultValue,
      'helpText': helpText,
      'options': options,
      'validation': validation != null
          ? FieldValidationModel.fromEntity(validation!).toJson()
          : null,
      'conditionalLogic': conditionalLogic != null
          ? ConditionalLogicModel.fromEntity(conditionalLogic!).toJson()
          : null,
    };
  }
}

class FieldValidationModel extends FieldValidation {
  FieldValidationModel({
    super.minLength,
    super.maxLength,
    super.min,
    super.max,
    super.pattern,
    super.errorMessage,
  });

  factory FieldValidationModel.fromEntity(FieldValidation validation) {
    return FieldValidationModel(
      minLength: validation.minLength,
      maxLength: validation.maxLength,
      min: validation.min,
      max: validation.max,
      pattern: validation.pattern,
      errorMessage: validation.errorMessage,
    );
  }

  factory FieldValidationModel.fromJson(Map<String, dynamic> json) {
    return FieldValidationModel(
      minLength: json['minLength'] as int?,
      maxLength: json['maxLength'] as int?,
      min: json['min'] as double?,
      max: json['max'] as double?,
      pattern: json['pattern'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minLength': minLength,
      'maxLength': maxLength,
      'min': min,
      'max': max,
      'pattern': pattern,
      'errorMessage': errorMessage,
    };
  }
}

class ConditionalLogicModel extends ConditionalLogic {
  ConditionalLogicModel({
    required super.dependsOnFieldId,
    required super.condition,
    required super.value,
    super.showWhen,
  });

  factory ConditionalLogicModel.fromEntity(ConditionalLogic logic) {
    return ConditionalLogicModel(
      dependsOnFieldId: logic.dependsOnFieldId,
      condition: logic.condition,
      value: logic.value,
      showWhen: logic.showWhen,
    );
  }

  factory ConditionalLogicModel.fromJson(Map<String, dynamic> json) {
    return ConditionalLogicModel(
      dependsOnFieldId: json['dependsOnFieldId'] as String,
      condition: json['condition'] as String,
      value: json['value'],
      showWhen: json['showWhen'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dependsOnFieldId': dependsOnFieldId,
      'condition': condition,
      'value': value,
      'showWhen': showWhen,
    };
  }
}
