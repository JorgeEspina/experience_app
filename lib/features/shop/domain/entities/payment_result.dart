class PaymentResult {
  const PaymentResult({
    required this.approved,
    required this.message,
    this.status,
    this.transactionId,
    this.amount,
    this.currency,
    this.cardLast4,
    this.timestamp,
  });

  final bool approved;
  final String message;
  final String? status;
  final String? transactionId;
  final double? amount;
  final String? currency;
  final String? cardLast4;
  final String? timestamp;
}
