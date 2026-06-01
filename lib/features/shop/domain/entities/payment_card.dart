class PaymentCard {
  const PaymentCard({
    required this.number,
    required this.holder,
    required this.behavior,
    required this.maskedNumber,
    this.availableFunds,
    this.declineReason,
  });

  final String number;
  final String holder;
  final String behavior;
  final String maskedNumber;
  final double? availableFunds;
  final String? declineReason;

  bool get isDeclined => behavior == 'always_declined';
  bool get checksFunds => behavior == 'check_funds';
}
