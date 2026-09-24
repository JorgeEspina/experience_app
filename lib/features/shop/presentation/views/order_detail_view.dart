import 'package:flutter/material.dart';

import 'package:experience_app/system_design/widgets/app_filled_button.dart';
import 'package:experience_app/system_design/widgets/app_network_image.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/payment_result.dart';
import 'payment_receipt_view.dart';

/// Breakdown of a single order, with a button to view its receipt.
class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E2229),
        title: const Text(
          'Detalle del pedido',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E2229),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    _formatDate(order.createdAt),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...order.items.map(_itemTile),
                  const SizedBox(height: 8),
                  const Divider(color: Color(0xFFE5E7EB)),
                  _summaryRow('Artículos', '${order.itemCount}'),
                  _summaryRow(
                    'Total',
                    '${order.currency} \$${order.total.toStringAsFixed(2)}',
                    emphasize: true,
                  ),
                  if (order.transactionId != null)
                    _summaryRow('Transacción', order.transactionId!),
                  if (order.cardLast4 != null)
                    _summaryRow('Tarjeta', '•••• ${order.cardLast4}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppFilledButton(
                text: 'Ver comprobante',
                icon: Icons.receipt_long,
                onPressed: () => _openReceipt(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemTile(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          AppNetworkImage(
            imageUrl: item.imageUrl,
            height: 56,
            width: 56,
            borderRadius: 10,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E2229),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Talla ${item.size} · ${item.colorName} · x${item.quantity}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.lineTotal.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2229),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: emphasize ? 17 : 13,
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
              color: const Color(0xFF1E2229),
            ),
          ),
        ],
      ),
    );
  }

  void _openReceipt(BuildContext context) {
    // Rebuild a PaymentResult from the stored order to reuse the receipt.
    final result = PaymentResult(
      approved: true,
      message: 'Pago aprobado por ${order.currency} '
          '\$${order.total.toStringAsFixed(2)}.',
      status: order.status,
      transactionId: order.transactionId,
      amount: order.total,
      currency: order.currency,
      cardLast4: order.cardLast4,
      timestamp: order.createdAt.toIso8601String(),
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaymentReceiptView(
          result: result,
          exit: ReceiptExit.back,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} '
        '${two(local.hour)}:${two(local.minute)}';
  }
}
