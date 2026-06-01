import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import 'shop_providers.dart';
import 'shop_state.dart';

class ShopController extends Notifier<ShopState> {
  @override
  ShopState build() {
    _loadInitialData();
    return const ShopState();
  }

  Future<void> _loadInitialData() async {
    final getProducts = ref.read(getProductsUseCaseProvider);
    final cartRepo = ref.read(cartRepositoryProvider);

    final products = await getProducts();
    final cartItems = await cartRepo.getCartItems();

    state = state.copyWith(
      products: products,
      cartItems: List<CartItem>.from(cartItems),
    );
  }

  Future<void> loadCards() async {
    state = state.copyWith(isLoadingCards: true, cardsError: null);
    try {
      final getCards = ref.read(getCardsUseCaseProvider);
      final cards = await getCards();
      state = state.copyWith(cards: cards, isLoadingCards: false);
    } catch (e) {
      state = state.copyWith(
        isLoadingCards: false,
        cardsError: 'Error loading cards: $e',
      );
    }
  }

  Future<void> addToCart(Product product, String size, String colorName) async {
    final addToCartUseCase = ref.read(addToCartUseCaseProvider);
    await addToCartUseCase(product: product, size: size, colorName: colorName);
    await _refreshCart();
  }

  Future<void> incrementQuantity(int index) async {
    final updateQuantity = ref.read(updateCartQuantityUseCaseProvider);
    await updateQuantity.increment(index);
    await _refreshCart();
  }

  Future<void> decrementQuantity(int index) async {
    final updateQuantity = ref.read(updateCartQuantityUseCaseProvider);
    await updateQuantity.decrement(index);
    await _refreshCart();
  }

  void selectCard(int index) {
    state = state.copyWith(selectedCardIndex: index);
  }

  void toggleBillingEqualsShipping() {
    state = state.copyWith(
      billingEqualsShipping: !state.billingEqualsShipping,
    );
  }

  Future<void> _refreshCart() async {
    final cartRepo = ref.read(cartRepositoryProvider);
    final items = await cartRepo.getCartItems();
    state = state.copyWith(cartItems: List<CartItem>.from(items));
  }
}
