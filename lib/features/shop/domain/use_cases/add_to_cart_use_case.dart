import '../entities/cart_item.dart';
import '../entities/product.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  const AddToCartUseCase({required this.repository});

  final CartRepository repository;

  Future<void> call({
    required Product product,
    required String size,
    required String colorName,
  }) async {
    final currentItems = await repository.getCartItems();
    final existingIndex = currentItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColorName == colorName,
    );

    if (existingIndex >= 0) {
      final existing = currentItems[existingIndex];
      await repository.updateItemQuantity(existingIndex, existing.quantity + 1);
    } else {
      await repository.addItem(
        CartItem(
          product: product,
          quantity: 1,
          selectedSize: size,
          selectedColorName: colorName,
        ),
      );
    }
  }
}
