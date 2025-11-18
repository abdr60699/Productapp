import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_display_template.dart';

class DisplayTemplateNotifier extends Notifier<ProductDisplayType> {
  static const String _storageKey = 'selected_display_template';

  @override
  ProductDisplayType build() {
    _loadSelectedTemplate();
    return ProductDisplayType.grid;
  }

  Future<void> _loadSelectedTemplate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTemplate = prefs.getString(_storageKey);

      if (savedTemplate != null) {
        final template = ProductDisplayType.values.firstWhere(
          (type) => type.name == savedTemplate,
          orElse: () => ProductDisplayType.grid,
        );
        state = template;
      }
    } catch (e) {
      debugPrint('Error loading display template: $e');
    }
  }

  Future<void> setSelectedTemplate(ProductDisplayType template) async {
    if (state != template) {
      state = template;

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_storageKey, template.name);
      } catch (e) {
        debugPrint('Error saving display template: $e');
      }
    }
  }

  ProductDisplayTemplate get currentTemplate =>
      ProductDisplayTemplate.getByType(state);
}

final displayTemplateProvider = NotifierProvider<DisplayTemplateNotifier, ProductDisplayType>(() {
  return DisplayTemplateNotifier();
});
