import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/template.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_product.dart';
import '../../domain/usecases/save_product.dart';
import '../../domain/usecases/delete_product.dart';

class ProductProvider with ChangeNotifier {
  final GetProducts getProductsUseCase;
  final GetProduct getProductUseCase;
  final SaveProduct saveProductUseCase;
  final DeleteProduct deleteProductUseCase;
  final ProductRepository productRepository;

  final Uuid _uuid = const Uuid();

  List<Product> _products = [];
  bool _isLoading = false;

  ProductProvider({
    required this.getProductsUseCase,
    required this.getProductUseCase,
    required this.saveProductUseCase,
    required this.deleteProductUseCase,
    required this.productRepository,
  });

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  List<Product> get activeProducts =>
      _products.where((product) => product.isActive).toList();

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await getProductsUseCase();
      _products.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createProduct({
    required Template template,
    required Map<String, dynamic> data,
  }) async {
    final product = Product(
      id: _uuid.v4(),
      shopId: template.shopId,
      templateId: template.id,
      templateName: template.name,
      slug: _generateSlug(data['title'] ?? 'product'),
      title: data['title'] ?? 'Untitled Product',
      data: data,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );

    await saveProductUseCase(product);
    await loadProducts();
  }

  Future<void> updateProduct(Product product, Map<String, dynamic> data) async {
    final updatedProduct = product.copyWith(
      data: data,
      title: data['title'] ?? product.title,
      updatedAt: DateTime.now(),
    );

    await saveProductUseCase(updatedProduct);
    await loadProducts();
  }

  Future<void> deleteProduct(String productId) async {
    await deleteProductUseCase(productId);
    await loadProducts();
  }

  Future<void> deactivateProduct(String productId) async {
    final product = await getProductUseCase(productId);
    if (product != null) {
      final deactivatedProduct = product.copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );
      await saveProductUseCase(deactivatedProduct);
      await loadProducts();
    }
  }

  Product? getProduct(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  List<Product> getProductsByTemplate(String templateId) {
    return _products
        .where((product) =>
            product.templateId == templateId && product.isActive)
        .toList();
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return activeProducts;

    final lowercaseQuery = query.toLowerCase();
    return activeProducts.where((product) {
      return product.title.toLowerCase().contains(lowercaseQuery) ||
          product.data.values.any((value) =>
              value.toString().toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Map<String, List<Product>> getProductsByCategory() {
    final Map<String, List<Product>> categorizedProducts = {};

    for (final product in activeProducts) {
      final category = product.category ?? 'Uncategorized';
      if (!categorizedProducts.containsKey(category)) {
        categorizedProducts[category] = [];
      }
      categorizedProducts[category]!.add(product);
    }

    return categorizedProducts;
  }

  int getTotalProductCount() => activeProducts.length;

  int getProductCountByTemplate(String templateId) {
    return getProductsByTemplate(templateId).length;
  }

  List<Product> getRecentProducts({int limit = 5}) {
    final sorted = List<Product>.from(activeProducts);
    sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted.take(limit).toList();
  }

  // Validation
  bool validateProductData(Template template, Map<String, dynamic> data) {
    for (final field in template.fields) {
      if (field.isRequired && field.isInput) {
        final value = data[field.id];
        if (value == null || value.toString().trim().isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  String? getValidationError(Template template, Map<String, dynamic> data) {
    for (final field in template.fields) {
      if (field.isRequired && field.isInput) {
        final value = data[field.id];
        if (value == null || value.toString().trim().isEmpty) {
          return '${field.label} is required';
        }
      }
    }
    return null;
  }

  String _generateSlug(String title) {
    return title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }
}
