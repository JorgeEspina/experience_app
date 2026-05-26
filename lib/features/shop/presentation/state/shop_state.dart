import '../../domain/entities/cart_item.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/product.dart';

class ShopState {
  const ShopState({
    this.products = const [],
    this.cartItems = const [],
    this.paymentMethods = const [],
    this.selectedPaymentIndex = 0,
    this.billingEqualsShipping = true,
  });

  final List<Product> products;
  final List<CartItem> cartItems;
  final List<PaymentMethod> paymentMethods;
  final int selectedPaymentIndex;
  final bool billingEqualsShipping;

  double get cartTotal =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  int get cartItemCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  ShopState copyWith({
    List<Product>? products,
    List<CartItem>? cartItems,
    List<PaymentMethod>? paymentMethods,
    int? selectedPaymentIndex,
    bool? billingEqualsShipping,
  }) {
    return ShopState(
      products: products ?? this.products,
      cartItems: cartItems ?? this.cartItems,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentIndex: selectedPaymentIndex ?? this.selectedPaymentIndex,
      billingEqualsShipping:
          billingEqualsShipping ?? this.billingEqualsShipping,
    );
  }
}
