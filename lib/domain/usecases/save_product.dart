import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SaveProduct {
  final ProductRepository repository;

  SaveProduct(this.repository);

  Future<void> call(Product product) async {
    return await repository.saveProduct(product);
  }
}
