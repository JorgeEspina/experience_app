enum PaymentType { creditCard, applePay }

class PaymentMethod {
  const PaymentMethod({
    required this.type,
    required this.label,
    required this.cardNumber,
    this.isSelected = false,
  });

  final PaymentType type;
  final String label;
  final String cardNumber;
  final bool isSelected;

  PaymentMethod copyWith({bool? isSelected}) {
    return PaymentMethod(
      type: type,
      label: label,
      cardNumber: cardNumber,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
