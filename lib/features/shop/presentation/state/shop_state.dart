import '../../domain/entities/cart_item.dart';
import '../../domain/entities/payment_card.dart';
import '../../domain/entities/product.dart';

class ShopState {
  const ShopState({
    this.products = const [],
    this.cartItems = const [],
    this.cards = const [],
    this.selectedCardIndex = 0,
    this.billingEqualsShipping = true,
    this.isLoadingCards = false,
    this.cardsError,
  });

  final List<Product> products;
  final List<CartItem> cartItems;
  final List<PaymentCard> cards;
  final int selectedCardIndex;
  final bool billingEqualsShipping;
  final bool isLoadingCards;
  final String? cardsError;

  double get cartTotal =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  int get cartItemCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  PaymentCard? get selectedCard =>
      cards.isNotEmpty && selectedCardIndex < cards.length
          ? cards[selectedCardIndex]
          : null;

  ShopState copyWith({
    List<Product>? products,
    List<CartItem>? cartItems,
    List<PaymentCard>? cards,
    int? selectedCardIndex,
    bool? billingEqualsShipping,
    bool? isLoadingCards,
    String? cardsError,
  }) {
    return ShopState(
      products: products ?? this.products,
      cartItems: cartItems ?? this.cartItems,
      cards: cards ?? this.cards,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      billingEqualsShipping:
          billingEqualsShipping ?? this.billingEqualsShipping,
      isLoadingCards: isLoadingCards ?? this.isLoadingCards,
      cardsError: cardsError,
    );
  }
}
