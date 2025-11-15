import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../models/template_model.dart';

class LocalDataSource {
  static const String _templatesKey = 'templates';
  static const String _productsKey = 'products';

  // Template operations
  Future<List<TemplateModel>> getTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final String? templatesJson = prefs.getString(_templatesKey);

    if (templatesJson == null) {
      return [];
    }

    final List<dynamic> jsonList = json.decode(templatesJson);
    return jsonList
        .map((json) => TemplateModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTemplates(List<TemplateModel> templates) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(
      templates.map((template) => template.toJson()).toList(),
    );
    await prefs.setString(_templatesKey, jsonString);
  }

  Future<void> saveTemplate(TemplateModel template) async {
    final templates = await getTemplates();
    final index = templates.indexWhere((t) => t.id == template.id);

    if (index != -1) {
      templates[index] = template;
    } else {
      templates.add(template);
    }

    await saveTemplates(templates);
  }

  Future<void> deleteTemplate(String templateId) async {
    final templates = await getTemplates();
    templates.removeWhere((template) => template.id == templateId);
    await saveTemplates(templates);
  }

  Future<void> clearAllTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_templatesKey);
  }

  // Product operations
  Future<List<ProductModel>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productsJson = prefs.getString(_productsKey);

    if (productsJson == null) {
      return [];
    }

    final List<dynamic> jsonList = json.decode(productsJson);
    return jsonList
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveProducts(List<ProductModel> products) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(
      products.map((product) => product.toJson()).toList(),
    );
    await prefs.setString(_productsKey, jsonString);
  }

  Future<void> saveProduct(ProductModel product) async {
    final products = await getProducts();
    final index = products.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      products[index] = product;
    } else {
      products.add(product);
    }

    await saveProducts(products);
  }

  Future<void> deleteProduct(String productId) async {
    final products = await getProducts();
    products.removeWhere((product) => product.id == productId);
    await saveProducts(products);
  }

  Future<void> clearAllProducts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_productsKey);
  }
}
