class PaymentResult {
  const PaymentResult({
    required this.approved,
    required this.message,
    this.transactionId,
    this.remainingBalance,
  });

  final bool approved;
  final String message;
  final String? transactionId;
  final double? remainingBalance;
}
