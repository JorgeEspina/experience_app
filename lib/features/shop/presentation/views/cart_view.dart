import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:experience_app/system_design/widgets/app_filled_button.dart';
import 'package:experience_app/system_design/widgets/app_network_image.dart';
import 'package:experience_app/system_design/widgets/quantity_button.dart';

import '../state/shop_providers.dart';
import 'payment_view.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shopControllerProvider);
    final controller = ref.read(shopControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E6EF2)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Your bag',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E2229),
          ),
        ),
        centerTitle: true,
      ),
      body: state.cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your bag is empty',
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.cartItems.length,
                    separatorBuilder: (_, __) => const Divider(height: 32),
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      return Row(
                        children: [
                          // Product image
                          AppNetworkImage(
                            imageUrl: item.product.imageUrl,
                            width: 64,
                            height: 64,
                            borderRadius: 10,
                            placeholderIconSize: 28,
                          ),
                          const SizedBox(width: 12),
                          // Product info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E2229),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item.selectedColorName} / ${item.selectedSize}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Quantity controls
                                Row(
                                  children: [
                                    QuantityButton(
                                      icon: Icons.remove,
                                      onTap: () =>
                                          controller.decrementQuantity(index),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    QuantityButton(
                                      icon: Icons.add,
                                      onTap: () =>
                                          controller.incrementQuantity(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Price
                          Text(
                            '€ ${item.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E2229),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Total and checkout
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          Text(
                            '€ ${state.cartTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E2229),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AppFilledButton(
                        text: 'Checkout',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const PaymentView(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}


