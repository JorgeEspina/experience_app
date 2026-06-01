import 'package:flutter/material.dart';
import '../../domain/entities/payment_card.dart';

class PaymentCardTile extends StatelessWidget {
  const PaymentCardTile({
    super.key,
    required this.card,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentCard card;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isInvalid = card.isDeclined;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? const Color(0xFFF0F4FF)
              : isInvalid
                  ? const Color(0xFFFEF2F2)
                  : Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1E6EF2)
                : isInvalid
                    ? const Color(0xFFFCA5A5)
                    : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            // Card icon
            Container(
              width: 40,
              height: 28,
              decoration: BoxDecoration(
                color: _cardIconColor,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.credit_card,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            // Card info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          card.holder,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isInvalid
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF1E2229),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isInvalid) ...[
                        const SizedBox(width: 6),
                        _StatusBadge(
                          text: _badgeText,
                          color: Colors.red,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card.maskedNumber,
                    style: TextStyle(
                      fontSize: 12,
                      color: isInvalid
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                  if (card.checksFunds && card.availableFunds != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 12,
                            color: _fundsColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '€ ${card.availableFunds!.toStringAsFixed(2)} available',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: _fundsColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isInvalid && card.declineReason != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        card.declineReason!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Check or warning icon
            if (isSelected && !isInvalid)
              const Icon(Icons.check, color: Color(0xFF1E6EF2), size: 20)
            else if (isInvalid)
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFDC2626), size: 20),
          ],
        ),
      ),
    );
  }

  Color get _cardIconColor {
    if (card.isDeclined) return const Color(0xFFEF4444);
    if (card.availableFunds != null && card.availableFunds! >= 300) {
      return const Color(0xFF1E6EF2);
    }
    if (card.availableFunds != null && card.availableFunds! >= 100) {
      return const Color(0xFF2563EB);
    }
    return const Color(0xFF6B7280);
  }

  Color get _fundsColor {
    if (card.availableFunds! >= 300) return const Color(0xFF16A34A);
    if (card.availableFunds! >= 100) return const Color(0xFFCA8A04);
    return const Color(0xFFDC2626);
  }

  String get _badgeText {
    if (card.declineReason != null &&
        card.declineReason!.toLowerCase().contains('expir')) {
      return 'EXPIRED';
    }
    return 'DECLINED';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
