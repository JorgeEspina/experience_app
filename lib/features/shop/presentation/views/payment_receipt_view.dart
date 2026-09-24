import 'package:flutter/material.dart';

import 'package:experience_app/system_design/widgets/app_filled_button.dart';

import '../../domain/entities/payment_result.dart';
import 'explore_view.dart';

/// Receipt shown after an approved payment, and also reused from the orders
/// history. The bottom button adapts to where it was opened from:
/// - [ReceiptExit.keepShopping]: "Seguir comprando" -> back to the shop (Explore).
/// - [ReceiptExit.back]: "Volver" -> just pops back (e.g. to order detail).
enum ReceiptExit { keepShopping, back }

class PaymentReceiptView extends StatelessWidget {
  const PaymentReceiptView({
    super.key,
    required this.result,
    this.exit = ReceiptExit.keepShopping,
  });

  final PaymentResult result;
  final ReceiptExit exit;

  @override
  Widget build(BuildContext context) {
    final currency = result.currency ?? 'USD';
    final amount = result.amount?.toStringAsFixed(2) ?? '0.00';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Success check
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5EC),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF16A34A),
                  size: 56,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pago aprobado',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E2229),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                result.message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 28),
              // Receipt card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    _ReceiptRow(
                      label: 'Monto',
                      value: '$currency \$$amount',
                      emphasize: true,
                    ),
                    const _ReceiptDivider(),
                    if (result.transactionId != null) ...[
                      _ReceiptRow(
                        label: 'ID de transacción',
                        value: result.transactionId!,
                      ),
                      const _ReceiptDivider(),
                    ],
                    if (result.cardLast4 != null) ...[
                      _ReceiptRow(
                        label: 'Tarjeta',
                        value: '•••• ${result.cardLast4}',
                      ),
                      const _ReceiptDivider(),
                    ],
                    _ReceiptRow(
                      label: 'Estado',
                      value: (result.status ?? 'approved').toUpperCase(),
                      valueColor: const Color(0xFF16A34A),
                    ),
                    if (result.timestamp != null) ...[
                      const _ReceiptDivider(),
                      _ReceiptRow(
                        label: 'Fecha',
                        value: _formatTimestamp(result.timestamp!),
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              AppFilledButton(
                text: exit == ReceiptExit.keepShopping
                    ? 'Seguir comprando'
                    : 'Volver a mis pedidos',
                icon: exit == ReceiptExit.keepShopping
                    ? Icons.storefront_outlined
                    : Icons.arrow_back,
                onPressed: () {
                  if (exit == ReceiptExit.keepShopping) {
                    _goHome(context);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _goHome(BuildContext context) {
    // Clear the whole navigation stack and land back on the shop (Explore)
    // so the user can keep shopping with a clean state.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const ExploreView()),
      (route) => false,
    );
  }

  String _formatTimestamp(String iso) {
    final date = DateTime.tryParse(iso);
    if (date == null) return iso;
    final local = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} '
        '${two(local.hour)}:${two(local.minute)}';
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.label,
    required this.value,
    this.emphasize = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool emphasize;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: emphasize ? 18 : 13,
                fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
                color: valueColor ?? const Color(0xFF1E2229),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptDivider extends StatelessWidget {
  const _ReceiptDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: Color(0xFFE5E7EB));
  }
}
