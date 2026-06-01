import '../repositories/cart_repository.dart';

class UpdateCartQuantityUseCase {
  const UpdateCartQuantityUseCase({required this.repository});

  final CartRepository repository;

  Future<void> increment(int index) async {
    final items = await repository.getCartItems();
    if (index < items.length) {
      await repository.updateItemQuantity(index, items[index].quantity + 1);
    }
  }

  Future<void> decrement(int index) async {
    final items = await repository.getCartItems();
    if (index < items.length) {
      if (items[index].quantity > 1) {
        await repository.updateItemQuantity(index, items[index].quantity - 1);
      } else {
        await repository.removeItem(index);
      }
    }
  }
}
