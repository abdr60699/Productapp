import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final LocalDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<List<Product>> getProducts() async {
    return await dataSource.getProducts();
  }

  @override
  Future<Product?> getProduct(String productId) async {
    final products = await dataSource.getProducts();
    try {
      return products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Product>> getProductsByTemplate(String templateId) async {
    final products = await dataSource.getProducts();
    return products.where((product) => product.templateId == templateId).toList();
  }

  @override
  Future<void> saveProduct(Product product) async {
    final productModel = ProductModel.fromEntity(product);
    await dataSource.saveProduct(productModel);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await dataSource.deleteProduct(productId);
  }

  @override
  Future<void> clearAllProducts() async {
    await dataSource.clearAllProducts();
  }
}
