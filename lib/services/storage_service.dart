import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/form_template_model.dart';
import '../models/product_model.dart';

class StorageService {
  static const String _templatesKey = 'form_templates';
  static const String _productsKey = 'products';

  // Template Storage
  Future<List<FormTemplateModel>> getTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final templatesJson = prefs.getString(_templatesKey);

    if (templatesJson == null) return [];

    final List<dynamic> templatesList = json.decode(templatesJson);
    return templatesList
        .map((json) => FormTemplateModel.fromJson(json))
        .toList();
  }

  Future<void> saveTemplates(List<FormTemplateModel> templates) async {
    final prefs = await SharedPreferences.getInstance();
    final templatesJson = json.encode(
      templates.map((template) => template.toJson()).toList(),
    );
    await prefs.setString(_templatesKey, templatesJson);
  }

  Future<void> saveTemplate(FormTemplateModel template) async {
    final templates = await getTemplates();
    final existingIndex = templates.indexWhere((t) => t.id == template.id);

    if (existingIndex >= 0) {
      templates[existingIndex] = template;
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

  Future<FormTemplateModel?> getTemplate(String templateId) async {
    final templates = await getTemplates();
    try {
      return templates.firstWhere((template) => template.id == templateId);
    } catch (e) {
      return null;
    }
  }

  // Product Storage
  Future<List<ProductModel>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getString(_productsKey);

    if (productsJson == null) return [];

    final List<dynamic> productsList = json.decode(productsJson);
    return productsList
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  Future<void> saveProducts(List<ProductModel> products) async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = json.encode(
      products.map((product) => product.toJson()).toList(),
    );
    await prefs.setString(_productsKey, productsJson);
  }

  Future<void> saveProduct(ProductModel product) async {
    final products = await getProducts();
    final existingIndex = products.indexWhere((p) => p.id == product.id);

    if (existingIndex >= 0) {
      products[existingIndex] = product;
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

  Future<ProductModel?> getProduct(String productId) async {
    final products = await getProducts();
    try {
      return products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  Future<List<ProductModel>> getProductsByTemplate(String templateId) async {
    final products = await getProducts();
    return products
        .where((product) => product.templateId == templateId && product.isActive)
        .toList();
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_templatesKey);
    await prefs.remove(_productsKey);
  }
}