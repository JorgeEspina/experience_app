import '../../domain/entities/payment_card.dart';

class CardModel {
  const CardModel({
    required this.number,
    required this.holder,
    required this.behavior,
    this.availableFunds,
    this.declineReason,
  });

  final String number;
  final String holder;
  final String behavior;
  final double? availableFunds;
  final String? declineReason;

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      number: json['number'] as String,
      holder: json['holder'] as String,
      behavior: json['behavior'] as String,
      availableFunds: json['availableFunds'] != null
          ? (json['availableFunds'] as num).toDouble()
          : null,
      declineReason: json['declineReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'holder': holder,
      'behavior': behavior,
      'availableFunds': availableFunds,
      'declineReason': declineReason,
    };
  }

  PaymentCard toEntity() {
    return PaymentCard(
      number: number,
      holder: holder,
      behavior: behavior,
      availableFunds: availableFunds,
      declineReason: declineReason,
      maskedNumber: 'xxxx xxxx xxxx ${number.substring(number.length - 4)}',
    );
  }
}
