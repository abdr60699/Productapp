import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/form_template_model.dart';
import '../models/form_field_model.dart';
import '../services/storage_service.dart';

class TemplateProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  List<FormTemplateModel> _templates = [];
  bool _isLoading = false;

  List<FormTemplateModel> get templates => _templates;
  bool get isLoading => _isLoading;

  List<FormTemplateModel> get activeTemplates =>
      _templates.where((template) => template.isActive).toList();

  Future<void> loadTemplates() async {
    _isLoading = true;
    notifyListeners();

    try {
      _templates = await _storageService.getTemplates();
    } catch (e) {
      _templates = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTemplate({
    required String name,
    required String description,
    required List<FormFieldModel> fields,
  }) async {
    final template = FormTemplateModel(
      id: _uuid.v4(),
      name: name,
      description: description,
      fields: fields,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );

    await _storageService.saveTemplate(template);
    await loadTemplates();
  }

  Future<void> updateTemplate(FormTemplateModel template) async {
    final updatedTemplate = template.copyWith(
      updatedAt: DateTime.now(),
    );

    await _storageService.saveTemplate(updatedTemplate);
    await loadTemplates();
  }

  Future<void> deleteTemplate(String templateId) async {
    await _storageService.deleteTemplate(templateId);
    await loadTemplates();
  }

  Future<void> deactivateTemplate(String templateId) async {
    final template = await _storageService.getTemplate(templateId);
    if (template != null) {
      final deactivatedTemplate = template.copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );
      await _storageService.saveTemplate(deactivatedTemplate);
      await loadTemplates();
    }
  }

  FormTemplateModel? getTemplate(String templateId) {
    try {
      return _templates.firstWhere((template) => template.id == templateId);
    } catch (e) {
      return null;
    }
  }

  FormFieldModel createField({
    required String title,
    required FormFieldType type,
    bool isRequired = false,
    List<String>? options,
    String? placeholder,
    String? defaultValue,
    int order = 0,
  }) {
    return FormFieldModel(
      id: _uuid.v4(),
      title: title,
      type: type,
      isRequired: isRequired,
      options: options,
      placeholder: placeholder,
      defaultValue: defaultValue,
      order: order,
    );
  }

  List<FormFieldModel> reorderFields(
    List<FormFieldModel> fields,
    int oldIndex,
    int newIndex,
  ) {
    final reorderedFields = List<FormFieldModel>.from(fields);
    final field = reorderedFields.removeAt(oldIndex);
    reorderedFields.insert(newIndex, field);

    // Update order values
    for (int i = 0; i < reorderedFields.length; i++) {
      reorderedFields[i] = reorderedFields[i].copyWith(order: i);
    }

    return reorderedFields;
  }

  // Predefined template examples
  Future<void> createSampleTemplates() async {
    if (_templates.isNotEmpty) return;

    // Clothing Store Template
    final clothingFields = [
      createField(
        title: 'Product Name',
        type: FormFieldType.text,
        isRequired: true,
        placeholder: 'Enter product name',
        order: 0,
      ),
      createField(
        title: 'Size',
        type: FormFieldType.dropdown,
        isRequired: true,
        options: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
        order: 1,
      ),
      createField(
        title: 'Color',
        type: FormFieldType.text,
        isRequired: true,
        placeholder: 'Enter color',
        order: 2,
      ),
      createField(
        title: 'Price',
        type: FormFieldType.number,
        isRequired: true,
        placeholder: 'Enter price',
        order: 3,
      ),
      createField(
        title: 'Brand',
        type: FormFieldType.text,
        isRequired: false,
        placeholder: 'Enter brand name',
        order: 4,
      ),
      createField(
        title: 'Description',
        type: FormFieldType.textarea,
        isRequired: false,
        placeholder: 'Enter product description',
        order: 5,
      ),
    ];

    await createTemplate(
      name: 'Clothing Store',
      description: 'Template for clothing and apparel products',
      fields: clothingFields,
    );

    // Electronics Store Template
    final electronicsFields = [
      createField(
        title: 'Product Name',
        type: FormFieldType.text,
        isRequired: true,
        placeholder: 'Enter product name',
        order: 0,
      ),
      createField(
        title: 'Brand',
        type: FormFieldType.text,
        isRequired: true,
        placeholder: 'Enter brand name',
        order: 1,
      ),
      createField(
        title: 'Model',
        type: FormFieldType.text,
        isRequired: true,
        placeholder: 'Enter model number',
        order: 2,
      ),
      createField(
        title: 'Price',
        type: FormFieldType.number,
        isRequired: true,
        placeholder: 'Enter price',
        order: 3,
      ),
      createField(
        title: 'Warranty Period',
        type: FormFieldType.dropdown,
        isRequired: false,
        options: ['6 months', '1 year', '2 years', '3 years'],
        order: 4,
      ),
      createField(
        title: 'Specifications',
        type: FormFieldType.textarea,
        isRequired: false,
        placeholder: 'Enter technical specifications',
        order: 5,
      ),
    ];

    await createTemplate(
      name: 'Electronics Store',
      description: 'Template for electronic products and gadgets',
      fields: electronicsFields,
    );

    // Restaurant Menu Template
    final menuFields = [
      createField(
        title: 'Dish Name',
        type: FormFieldType.text,
        isRequired: true,
        placeholder: 'Enter dish name',
        order: 0,
      ),
      createField(
        title: 'Category',
        type: FormFieldType.dropdown,
        isRequired: true,
        options: ['Appetizer', 'Main Course', 'Dessert', 'Beverage'],
        order: 1,
      ),
      createField(
        title: 'Price',
        type: FormFieldType.number,
        isRequired: true,
        placeholder: 'Enter price',
        order: 2,
      ),
      createField(
        title: 'Ingredients',
        type: FormFieldType.textarea,
        isRequired: false,
        placeholder: 'List main ingredients',
        order: 3,
      ),
      createField(
        title: 'Spice Level',
        type: FormFieldType.radio,
        isRequired: false,
        options: ['Mild', 'Medium', 'Hot', 'Extra Hot'],
        order: 4,
      ),
      createField(
        title: 'Vegetarian',
        type: FormFieldType.checkbox,
        isRequired: false,
        order: 5,
      ),
    ];

    await createTemplate(
      name: 'Restaurant Menu',
      description: 'Template for restaurant menu items',
      fields: menuFields,
    );
  }
}