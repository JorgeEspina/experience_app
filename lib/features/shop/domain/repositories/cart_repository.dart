import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> addItem(CartItem item);
  Future<void> updateItemQuantity(int index, int quantity);
  Future<void> removeItem(int index);
  Future<void> clearCart();
}
