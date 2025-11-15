import '../entities/shop.dart';

abstract class ShopRepository {
  Future<Shop?> getShop(String shopId);
  Future<void> saveShop(Shop shop);
  Future<void> deleteShop(String shopId);
}
