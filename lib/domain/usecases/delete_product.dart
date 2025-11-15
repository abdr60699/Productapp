import '../repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<void> call(String productId) async {
    return await repository.deleteProduct(productId);
  }
}
