class Field {
  final String id;
  final String label;
  final FieldType type;
  final bool isRequired;
  final int order;
  final String? group;
  final String? placeholder;
  final String? defaultValue;
  final String? helpText;
  final List<String>? options;
  final FieldValidation? validation;
  final ConditionalLogic? conditionalLogic;

  Field({
    required this.id,
    required this.label,
    required this.type,
    this.isRequired = false,
    this.order = 0,
    this.group,
    this.placeholder,
    this.defaultValue,
    this.helpText,
    this.options,
    this.validation,
    this.conditionalLogic,
  });

  Field copyWith({
    String? id,
    String? label,
    FieldType? type,
    bool? isRequired,
    int? order,
    String? group,
    String? placeholder,
    String? defaultValue,
    String? helpText,
    List<String>? options,
    FieldValidation? validation,
    ConditionalLogic? conditionalLogic,
  }) {
    return Field(
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
      isRequired: isRequired ?? this.isRequired,
      order: order ?? this.order,
      group: group ?? this.group,
      placeholder: placeholder ?? this.placeholder,
      defaultValue: defaultValue ?? this.defaultValue,
      helpText: helpText ?? this.helpText,
      options: options ?? this.options,
      validation: validation ?? this.validation,
      conditionalLogic: conditionalLogic ?? this.conditionalLogic,
    );
  }
}

class FieldValidation {
  final int? minLength;
  final int? maxLength;
  final double? min;
  final double? max;
  final String? pattern;
  final String? errorMessage;

  FieldValidation({
    this.minLength,
    this.maxLength,
    this.min,
    this.max,
    this.pattern,
    this.errorMessage,
  });

  FieldValidation copyWith({
    int? minLength,
    int? maxLength,
    double? min,
    double? max,
    String? pattern,
    String? errorMessage,
  }) {
    return FieldValidation(
      minLength: minLength ?? this.minLength,
      maxLength: maxLength ?? this.maxLength,
      min: min ?? this.min,
      max: max ?? this.max,
      pattern: pattern ?? this.pattern,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ConditionalLogic {
  final String dependsOnFieldId;
  final String condition;
  final dynamic value;
  final bool showWhen;

  ConditionalLogic({
    required this.dependsOnFieldId,
    required this.condition,
    required this.value,
    this.showWhen = true,
  });

  ConditionalLogic copyWith({
    String? dependsOnFieldId,
    String? condition,
    dynamic value,
    bool? showWhen,
  }) {
    return ConditionalLogic(
      dependsOnFieldId: dependsOnFieldId ?? this.dependsOnFieldId,
      condition: condition ?? this.condition,
      value: value ?? this.value,
      showWhen: showWhen ?? this.showWhen,
    );
  }
}

enum FieldType {
  text,
  number,
  email,
  phone,
  url,
  textarea,
  dropdown,
  multiselect,
  radio,
  checkbox,
  date,
  time,
  datetime,
  image,
  images,
  multivalue,
  youtube,
  color,
  rating,
  title,
  divider;

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
        return 'Multi Select';
      case FieldType.radio:
        return 'Radio';
      case FieldType.checkbox:
        return 'Checkbox';
      case FieldType.date:
        return 'Date';
      case FieldType.time:
        return 'Time';
      case FieldType.datetime:
        return 'Date & Time';
      case FieldType.image:
        return 'Image';
      case FieldType.images:
        return 'Images';
      case FieldType.multivalue:
        return 'Multi Value';
      case FieldType.youtube:
        return 'YouTube';
      case FieldType.color:
        return 'Color';
      case FieldType.rating:
        return 'Rating';
      case FieldType.title:
        return 'Title';
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
        return '▼';
      case FieldType.multiselect:
        return '☑️';
      case FieldType.radio:
        return '◉';
      case FieldType.checkbox:
        return '☑';
      case FieldType.date:
        return '📅';
      case FieldType.time:
        return '🕐';
      case FieldType.datetime:
        return '📅🕐';
      case FieldType.image:
        return '🖼️';
      case FieldType.images:
        return '🖼️';
      case FieldType.multivalue:
        return '📋';
      case FieldType.youtube:
        return '📹';
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
    return this == FieldType.dropdown ||
        this == FieldType.multiselect ||
        this == FieldType.radio;
  }

  bool get isInput {
    return this != FieldType.title && this != FieldType.divider;
  }
}
