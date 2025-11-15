import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product?> getProduct(String productId);
  Future<List<Product>> getProductsByTemplate(String templateId);
  Future<void> saveProduct(Product product);
  Future<void> deleteProduct(String productId);
  Future<void> clearAllProducts();
}
