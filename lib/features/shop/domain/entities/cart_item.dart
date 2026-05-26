import 'product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColorName,
  });

  final Product product;
  final int quantity;
  final String selectedSize;
  final String selectedColorName;

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedSize,
    String? selectedColorName,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColorName: selectedColorName ?? this.selectedColorName,
    );
  }
}
