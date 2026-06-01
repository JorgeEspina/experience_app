import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:experience_app/system_design/widgets/app_filled_button.dart';
import '../state/shop_providers.dart';
import '../widgets/payment_card_tile.dart';

class PaymentView extends ConsumerStatefulWidget {
  const PaymentView({super.key});

  @override
  ConsumerState<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends ConsumerState<PaymentView> {
  bool _useApplePay = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(shopControllerProvider.notifier).loadCards();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StepIndicator(label: 'Your bag', step: 1, isCompleted: true),
                _StepIndicator(label: 'Shipping', step: 2, isCompleted: true),
                _StepIndicator(label: 'Payment', step: 3, isActive: true),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 24),
                  // Credit Card section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Credit Card radio
                        GestureDetector(
                          onTap: () => setState(() => _useApplePay = false),
                          child: Row(
                            children: [
                              Icon(
                                _useApplePay
                                    ? Icons.radio_button_off
                                    : Icons.radio_button_checked,
                                color: _useApplePay
                                    ? const Color(0xFFD1D5DB)
                                    : const Color(0xFF1E6EF2),
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
                        ),
                        const SizedBox(height: 16),
                        // Cards list
                        if (state.isLoadingCards)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF1E6EF2),
                              ),
                            ),
                          )
                        else if (state.cardsError != null)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Text(
                                    'Could not load cards',
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () => controller.loadCards(),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...List.generate(state.cards.length, (index) {
                            final card = state.cards[index];
                            final isSelected =
                                index == state.selectedCardIndex &&
                                    !_useApplePay;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: PaymentCardTile(
                                card: card,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() => _useApplePay = false);
                                  controller.selectCard(index);
                                },
                              ),
                            );
                          }),
                        // Add new card
                        Center(
                          child: TextButton.icon(
                            onPressed: () => _showAddCardSheet(context),
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Billing checkbox
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.toggleBillingEqualsShipping(),
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
                  const SizedBox(height: 20),
                  // Apple Pay option
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => _useApplePay = true),
                      child: Row(
                        children: [
                          Icon(
                            _useApplePay
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: _useApplePay
                                ? const Color(0xFF1E6EF2)
                                : const Color(0xFFD1D5DB),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Apple Pay',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E2229),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Process Payment button
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppFilledButton(
              text: 'Process Payment',
              onPressed: () {
                if (_useApplePay) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing with Apple Pay...')),
                  );
                  return;
                }
                final card = state.selectedCard;
                if (card != null && card.isDeclined) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Card declined: ${card.declineReason}'),
                      backgroundColor: Colors.red[600],
                    ),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment processed successfully!')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCardSheet(BuildContext context) {
    final cardNumberController = TextEditingController();
    final holderController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Add new card',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E2229),
                ),
              ),
              const SizedBox(height: 20),
              _CardTextField(
                controller: holderController,
                label: 'Card holder name',
                hint: 'John Doe',
              ),
              const SizedBox(height: 14),
              _CardTextField(
                controller: cardNumberController,
                label: 'Card number',
                hint: '0000 0000 0000 0000',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _CardTextField(
                      controller: expiryController,
                      label: 'Expiry date',
                      hint: 'MM/YY',
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CardTextField(
                      controller: cvvController,
                      label: 'CVV',
                      hint: '123',
                      keyboardType: TextInputType.number,
                      obscure: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AppFilledButton(
                text: 'Add card',
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Card added!')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardTextField extends StatelessWidget {
  const _CardTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.obscure = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1E6EF2)),
            ),
          ),
        ),
      ],
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
