import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_display_template.dart';

class DisplayTemplateProvider extends ChangeNotifier {
  ProductDisplayType _selectedTemplate = ProductDisplayType.grid;
  static const String _storageKey = 'selected_display_template';

  ProductDisplayType get selectedTemplate => _selectedTemplate;

  DisplayTemplateProvider() {
    _loadSelectedTemplate();
  }

  Future<void> _loadSelectedTemplate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTemplate = prefs.getString(_storageKey);

      if (savedTemplate != null) {
        _selectedTemplate = ProductDisplayType.values.firstWhere(
          (type) => type.name == savedTemplate,
          orElse: () => ProductDisplayType.grid,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading display template: $e');
    }
  }

  Future<void> setSelectedTemplate(ProductDisplayType template) async {
    if (_selectedTemplate != template) {
      _selectedTemplate = template;
      notifyListeners();

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_storageKey, template.name);
      } catch (e) {
        debugPrint('Error saving display template: $e');
      }
    }
  }

  ProductDisplayTemplate get currentTemplate =>
      ProductDisplayTemplate.getByType(_selectedTemplate);
}