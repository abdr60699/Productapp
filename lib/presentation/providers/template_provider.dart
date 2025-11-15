import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/template.dart';
import '../../domain/entities/field.dart';
import '../../domain/usecases/get_templates.dart';
import '../../domain/usecases/get_template.dart';
import '../../domain/usecases/save_template.dart';
import '../../domain/usecases/delete_template.dart';
import '../../data/models/template_model.dart';

class TemplateProvider with ChangeNotifier {
  final GetTemplates getTemplatesUseCase;
  final GetTemplate getTemplateUseCase;
  final SaveTemplate saveTemplateUseCase;
  final DeleteTemplate deleteTemplateUseCase;

  final Uuid _uuid = const Uuid();

  List<Template> _templates = [];
  bool _isLoading = false;

  TemplateProvider({
    required this.getTemplatesUseCase,
    required this.getTemplateUseCase,
    required this.saveTemplateUseCase,
    required this.deleteTemplateUseCase,
  });

  List<Template> get templates => _templates;
  bool get isLoading => _isLoading;

  List<Template> get activeTemplates =>
      _templates.where((template) => template.isActive).toList();

  Future<void> loadTemplates() async {
    _isLoading = true;
    notifyListeners();

    try {
      _templates = await getTemplatesUseCase();
      _templates.sort((a, b) => a.name.compareTo(b.name));

      // If no templates exist, create sample templates
      if (_templates.isEmpty) {
        await createSampleTemplates();
      }
    } catch (e) {
      _templates = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTemplate({
    required String name,
    required String description,
    required List<Field> fields,
    String? icon,
    String category = 'custom',
  }) async {
    final template = Template(
      id: _uuid.v4(),
      shopId: 'default-shop',
      name: name,
      description: description,
      icon: icon,
      category: category,
      fields: fields,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );

    await saveTemplateUseCase(template);
    await loadTemplates();
  }

  Future<void> updateTemplate(Template template) async {
    final updatedTemplate = template.copyWith(
      updatedAt: DateTime.now(),
    );

    await saveTemplateUseCase(updatedTemplate);
    await loadTemplates();
  }

  Future<void> deleteTemplate(String templateId) async {
    await deleteTemplateUseCase(templateId);
    await loadTemplates();
  }

  Future<void> deactivateTemplate(String templateId) async {
    final template = await getTemplateUseCase(templateId);
    if (template != null) {
      final deactivatedTemplate = template.copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );
      await saveTemplateUseCase(deactivatedTemplate);
      await loadTemplates();
    }
  }

  Template? getTemplate(String templateId) {
    try {
      return _templates.firstWhere((template) => template.id == templateId);
    } catch (e) {
      return null;
    }
  }

  // Helper methods for creating fields
  Field createField({
    required String label,
    required FieldType type,
    bool isRequired = false,
    int order = 0,
    String? group,
    String? placeholder,
    String? defaultValue,
    String? helpText,
    List<String>? options,
  }) {
    return Field(
      id: _uuid.v4(),
      label: label,
      type: type,
      isRequired: isRequired,
      order: order,
      group: group,
      placeholder: placeholder,
      defaultValue: defaultValue,
      helpText: helpText,
      options: options,
    );
  }

  List<Field> reorderFields(List<Field> fields, int oldIndex, int newIndex) {
    final List<Field> reorderedFields = List.from(fields);
    final Field field = reorderedFields.removeAt(oldIndex);
    reorderedFields.insert(newIndex, field);

    // Update order values
    for (int i = 0; i < reorderedFields.length; i++) {
      reorderedFields[i] = reorderedFields[i].copyWith(order: i);
    }

    return reorderedFields;
  }

  Future<void> createSampleTemplates() async {
    const String shopId = 'default-shop';

    // Create preset templates
    final presetTemplates = TemplateModel.getAllPresets(shopId);

    for (final template in presetTemplates) {
      await saveTemplateUseCase(template);
    }

    await loadTemplates();
  }
}
