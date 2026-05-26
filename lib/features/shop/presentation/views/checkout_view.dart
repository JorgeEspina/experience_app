import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/payment_method.dart';
import '../state/shop_controller.dart';

class CheckoutView extends ConsumerWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shopControllerProvider);
    final controller = ref.read(shopControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF1E6EF2), fontSize: 14),
          ),
        ),
        leadingWidth: 80,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E2229),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Stepper
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StepIndicator(label: 'Your bag', step: 1, isCompleted: true),
                _StepIndicator(label: 'Shipping', step: 2, isCompleted: true),
                _StepIndicator(label: 'Payment', step: 3, isActive: true),
                _StepIndicator(label: 'Review', step: 4),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose a payment method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E2229),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "You won't be charged until you review the order on the next page",
                    style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(height: 20),
                  // Credit Card option
                  Row(
                    children: [
                      Icon(
                        Icons.radio_button_checked,
                        color: const Color(0xFF1E6EF2),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Credit Card',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E2229),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Card list
                  ...List.generate(
                    state.paymentMethods
                        .where((m) => m.type == PaymentType.creditCard)
                        .length,
                    (index) {
                      final cards = state.paymentMethods
                          .where((m) => m.type == PaymentType.creditCard)
                          .toList();
                      final card = cards[index];
                      final globalIndex =
                          state.paymentMethods.indexOf(card);
                      final isSelected =
                          globalIndex == state.selectedPaymentIndex;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () =>
                              controller.selectPaymentMethod(globalIndex),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1E6EF2)
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        card.label,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1E2229),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        card.cardNumber,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    color: Color(0xFF1E6EF2),
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Add new card
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      size: 18,
                      color: Color(0xFF1E6EF2),
                    ),
                    label: const Text(
                      'Add new card',
                      style: TextStyle(
                        color: Color(0xFF1E6EF2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Billing checkbox
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            controller.toggleBillingEqualsShipping(),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: state.billingEqualsShipping
                                ? const Color(0xFF1E6EF2)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: state.billingEqualsShipping
                                  ? const Color(0xFF1E6EF2)
                                  : const Color(0xFFD1D5DB),
                            ),
                          ),
                          child: state.billingEqualsShipping
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'My billing address is the same as my shipping address',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Apple Pay option
                  Row(
                    children: [
                      Icon(
                        Icons.radio_button_off,
                        color: const Color(0xFFD1D5DB),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Apple Pay',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Continue button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proceeding to review...')),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1E6EF2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.label,
    required this.step,
    this.isActive = false,
    this.isCompleted = false,
  });

  final String label;
  final int step;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: (isActive || isCompleted)
                ? const Color(0xFF1E6EF2)
                : const Color(0xFFE5E7EB),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text(
                  '$step',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: (isActive || isCompleted)
                ? const Color(0xFF1E2229)
                : const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}
