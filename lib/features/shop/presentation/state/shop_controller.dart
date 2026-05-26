import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/cart_item.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/product.dart';
import 'shop_state.dart';

class ShopController extends Notifier<ShopState> {
  @override
  ShopState build() => ShopState(
        products: _mockProducts,
        paymentMethods: _mockPaymentMethods,
      );

  void addToCart(Product product, String size, String colorName) {
    final existingIndex = state.cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColorName == colorName,
    );

    if (existingIndex >= 0) {
      final updated = List<CartItem>.from(state.cartItems);
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + 1,
      );
      state = state.copyWith(cartItems: updated);
    } else {
      state = state.copyWith(
        cartItems: [
          ...state.cartItems,
          CartItem(
            product: product,
            quantity: 1,
            selectedSize: size,
            selectedColorName: colorName,
          ),
        ],
      );
    }
  }

  void incrementQuantity(int index) {
    final updated = List<CartItem>.from(state.cartItems);
    updated[index] = updated[index].copyWith(
      quantity: updated[index].quantity + 1,
    );
    state = state.copyWith(cartItems: updated);
  }

  void decrementQuantity(int index) {
    final updated = List<CartItem>.from(state.cartItems);
    if (updated[index].quantity > 1) {
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity - 1,
      );
    } else {
      updated.removeAt(index);
    }
    state = state.copyWith(cartItems: updated);
  }

  void selectPaymentMethod(int index) {
    state = state.copyWith(selectedPaymentIndex: index);
  }

  void toggleBillingEqualsShipping() {
    state = state.copyWith(
      billingEqualsShipping: !state.billingEqualsShipping,
    );
  }
}

final shopControllerProvider =
    NotifierProvider<ShopController, ShopState>(ShopController.new);

// Mock data
final _mockProducts = [
  const Product(
    id: '1',
    name: 'Amazing T-Shirt',
    price: 12.00,
    description:
        'The perfect T-shirt for when you want to feel comfortable but still stylish. Amazing for all occasions. Made of 100% cotton fabric in four colours. Its modern style gives a lighter look to the outfit. Perfect for the warmest days.',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    colors: [Colors.black, Color(0xFF3D3D3D), Color(0xFF7EB6D9), Color(0xFFD9D9D9)],
  ),
  const Product(
    id: '2',
    name: 'Faboulous Pants',
    price: 15.00,
    description: 'Comfortable pants for everyday wear.',
    sizes: ['S', 'M', 'L', 'XL'],
    colors: [Colors.black, Color(0xFF3D3D3D), Color(0xFF7EB6D9)],
  ),
  const Product(
    id: '3',
    name: 'Spectacular Dress',
    price: 20.00,
    description: 'A spectacular dress for special occasions.',
    sizes: ['XS', 'S', 'M', 'L'],
    colors: [Color(0xFFD4AF37), Colors.black, Color(0xFF7EB6D9)],
  ),
  const Product(
    id: '4',
    name: 'Stunning Jacket',
    price: 18.00,
    description: 'A stunning jacket for cold days.',
    sizes: ['S', 'M', 'L', 'XL'],
    colors: [Color(0xFF1E6EF2), Colors.black, Color(0xFF3D3D3D)],
  ),
  const Product(
    id: '5',
    name: 'Wonderful Shoes',
    price: 18.00,
    description: 'Wonderful shoes for any occasion.',
    sizes: ['38', '39', '40', '41', '42'],
    colors: [Color(0xFF2E7D32), Colors.black, Color(0xFF3D3D3D)],
  ),
];

final _mockPaymentMethods = [
  const PaymentMethod(
    type: PaymentType.creditCard,
    label: 'Mastercard',
    cardNumber: 'xxxx xxxx xxxx 1234',
    isSelected: true,
  ),
  const PaymentMethod(
    type: PaymentType.creditCard,
    label: 'Visa',
    cardNumber: 'xxxx xxxx xxxx 9876',
  ),
  const PaymentMethod(
    type: PaymentType.applePay,
    label: 'Apple Pay',
    cardNumber: '',
  ),
];
