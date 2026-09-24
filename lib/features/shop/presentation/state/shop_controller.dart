import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:experience_app/features/auth/presentation/state/auth_providers.dart';
import 'package:experience_app/core/notifications/push_notification_provider.dart';

import '../../domain/entities/cart_item.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/payment_result.dart';
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
    // Load products and cart independently so a failure in one doesn't
    // prevent the other from loading.
    await reloadProducts();

    try {
      final cartRepo = ref.read(cartRepositoryProvider);
      final cartItems = await cartRepo.getCartItems();
      state = state.copyWith(cartItems: List<CartItem>.from(cartItems));
    } catch (_) {
      // Cart failed to load; leave it empty.
    }
  }

  /// Reloads the product catalog from Firestore.
  Future<void> reloadProducts() async {
    try {
      final getProducts = ref.read(getProductsUseCaseProvider);
      final products = await getProducts();
      state = state.copyWith(products: products);
    } catch (_) {
      // Loading products failed (e.g. not signed in yet / transient error).
      // Keep whatever we had; callers can retry (ExploreView reloads on open).
    }
  }

  /// Creates a new product in Firestore and refreshes the catalog.
  Future<void> createProduct(Product product) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.createProduct(product);
    await reloadProducts();
  }

  /// Updates an existing product in Firestore and refreshes the catalog.
  Future<void> updateProduct(Product product) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.updateProduct(product);
    await reloadProducts();
  }

  /// Deletes a product from Firestore and refreshes the catalog.
  Future<void> deleteProduct(String id) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.deleteProduct(id);
    await reloadProducts();
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

  Future<void> processPayment() async {
    final card = state.selectedCard;
    if (card == null) return;

    state = state.copyWith(isProcessingPayment: true, paymentResult: null);
    try {
      final processPayment = ref.read(processPaymentUseCaseProvider);
      final result = await processPayment(
        amount: state.cartTotal,
        cardNumber: card.number,
      );

      // On approval, try to persist the order and clear the cart. Persisting
      // the order must NOT block showing the receipt: if saving fails
      // (rules, index, network...) we still surface the approved result.
      if (result.approved) {
        final total = state.cartTotal;
        final currency = result.currency ?? 'USD';
        try {
          final orderId = await _saveApprovedOrder(result);
          await ref.read(cartRepositoryProvider).clearCart();
          state = state.copyWith(cartItems: const []);

          // On-device notification of the successful purchase. Tapping it
          // opens the order detail.
          if (orderId != null) {
            await ref
                .read(pushNotificationServiceProvider)
                .showLocalOrderNotification(
                  orderId: orderId,
                  title: 'Compra exitosa',
                  body: 'Tu compra por $currency \$${total.toStringAsFixed(2)} '
                      'fue procesada. Toca para ver el detalle.',
                );
          }
        } catch (e) {
          // Order persistence/notification failed; keep the approved result.
        }
      }

      state = state.copyWith(
        isProcessingPayment: false,
        paymentResult: result,
      );
    } catch (e) {
      state = state.copyWith(isProcessingPayment: false);
    }
  }

  /// Builds an [Order] snapshot from the current cart and saves it in Firestore.
  /// Returns the created order id, or null if it couldn't be saved.
  Future<String?> _saveApprovedOrder(PaymentResult result) async {
    final userId = ref.read(authControllerProvider).user?.id;
    if (userId == null) return null; // Not signed in: skip persistence.

    final items = state.cartItems
        .map((item) => OrderItem(
              productId: item.product.id,
              name: item.product.name,
              unitPrice: item.product.price,
              quantity: item.quantity,
              size: item.selectedSize,
              colorName: item.selectedColorName,
              imageUrl: item.product.imageUrl,
            ))
        .toList();

    if (items.isEmpty) return null;

    final order = Order(
      id: '',
      userId: userId,
      items: items,
      total: state.cartTotal,
      status: result.status ?? 'approved',
      createdAt: DateTime.now(),
      transactionId: result.transactionId,
      cardLast4: result.cardLast4,
      currency: result.currency ?? 'USD',
    );

    return ref.read(orderRepositoryProvider).createOrder(order);
  }

  /// Loads the current user's orders from Firestore (newest first).
  Future<List<Order>> loadMyOrders() async {
    final userId = ref.read(authControllerProvider).user?.id;
    if (userId == null) return [];
    return ref.read(orderRepositoryProvider).getOrdersByUser(userId);
  }

  Future<void> _refreshCart() async {
    final cartRepo = ref.read(cartRepositoryProvider);
    final items = await cartRepo.getCartItems();
    state = state.copyWith(cartItems: List<CartItem>.from(items));
  }
}
