import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/product_model.dart';
import '../models/form_template_model.dart';
import '../models/form_field_model.dart';
import '../services/storage_service.dart';

class ProductState {
  final List<ProductModel> products;
  final bool isLoading;

  ProductState({
    required this.products,
    required this.isLoading,
  });

  ProductState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<ProductModel> get activeProducts =>
      products.where((product) => product.isActive).toList();
}

class ProductNotifier extends Notifier<ProductState> {
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  @override
  ProductState build() {
    return ProductState(products: [], isLoading: false);
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true);

    try {
      final products = await _storageService.getProducts();
      products.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      state = ProductState(products: products, isLoading: false);
    } catch (e) {
      state = ProductState(products: [], isLoading: false);
    }
  }

  Future<void> createProduct({
    required FormTemplateModel template,
    required Map<String, dynamic> data,
  }) async {
    final product = ProductModel(
      id: _uuid.v4(),
      templateId: template.id,
      templateName: template.name,
      data: data,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );

    await _storageService.saveProduct(product);
    await loadProducts();
  }

  Future<void> updateProduct(ProductModel product, Map<String, dynamic> data) async {
    final updatedProduct = product.copyWith(
      data: data,
      updatedAt: DateTime.now(),
    );

    await _storageService.saveProduct(updatedProduct);
    await loadProducts();
  }

  Future<void> deleteProduct(String productId) async {
    await _storageService.deleteProduct(productId);
    await loadProducts();
  }

  Future<void> deactivateProduct(String productId) async {
    final product = await _storageService.getProduct(productId);
    if (product != null) {
      final deactivatedProduct = product.copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );
      await _storageService.saveProduct(deactivatedProduct);
      await loadProducts();
    }
  }

  ProductModel? getProduct(String productId) {
    try {
      return state.products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  List<ProductModel> getProductsByTemplate(String templateId) {
    return state.products
        .where((product) =>
            product.templateId == templateId && product.isActive)
        .toList();
  }

  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return state.activeProducts;

    final lowercaseQuery = query.toLowerCase();
    return state.activeProducts.where((product) {
      // Search in product display name
      if (product.displayName.toLowerCase().contains(lowercaseQuery)) {
        return true;
      }

      // Search in template name
      if (product.templateName.toLowerCase().contains(lowercaseQuery)) {
        return true;
      }

      // Search in product data values
      for (final value in product.data.values) {
        if (value.toString().toLowerCase().contains(lowercaseQuery)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  Map<String, List<ProductModel>> getProductsByCategory() {
    final Map<String, List<ProductModel>> categories = {};

    for (final product in state.activeProducts) {
      final category = product.templateName;
      if (categories.containsKey(category)) {
        categories[category]!.add(product);
      } else {
        categories[category] = [product];
      }
    }

    return categories;
  }

  int getTotalProductCount() => state.activeProducts.length;

  int getProductCountByTemplate(String templateId) =>
      getProductsByTemplate(templateId).length;

  List<ProductModel> getRecentProducts({int limit = 10}) {
    final sorted = List<ProductModel>.from(state.activeProducts);
    sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted.take(limit).toList();
  }

  bool validateProductData(
    FormTemplateModel template,
    Map<String, dynamic> data,
  ) {
    for (final field in template.fields) {
      if (field.isRequired) {
        final value = data[field.id];
        if (value == null || value.toString().trim().isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  String? getValidationError(
    FormTemplateModel template,
    Map<String, dynamic> data,
  ) {
    for (final field in template.fields) {
      if (field.isRequired) {
        final value = data[field.id];
        if (value == null || value.toString().trim().isEmpty) {
          return '${field.title} is required';
        }
      }

      final value = data[field.id];
      if (value != null && value.toString().isNotEmpty) {
        // Validate number fields
        if (field.type == FormFieldType.number) {
          if (double.tryParse(value.toString()) == null) {
            return '${field.title} must be a valid number';
          }
        }

        // Validate email fields
        if (field.type == FormFieldType.email) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value.toString())) {
            return '${field.title} must be a valid email address';
          }
        }

        // Validate dropdown options
        if (field.type == FormFieldType.dropdown && field.options != null) {
          if (!field.options!.contains(value.toString())) {
            return '${field.title} must be one of the available options';
          }
        }
      }
    }
    return null;
  }
}

final productProvider = NotifierProvider<ProductNotifier, ProductState>(() {
  return ProductNotifier();
});
