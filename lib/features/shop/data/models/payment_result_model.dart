import '../../domain/entities/payment_result.dart';

class PaymentResultModel {
  const PaymentResultModel({
    required this.approved,
    required this.message,
    this.transactionId,
    this.remainingBalance,
  });

  final bool approved;
  final String message;
  final String? transactionId;
  final double? remainingBalance;

  factory PaymentResultModel.fromJson(Map<String, dynamic> json) {
    return PaymentResultModel(
      approved: json['approved'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      transactionId: json['transactionId'] as String?,
      remainingBalance: json['remainingBalance'] != null
          ? (json['remainingBalance'] as num).toDouble()
          : null,
    );
  }

  PaymentResult toEntity() {
    return PaymentResult(
      approved: approved,
      message: message,
      transactionId: transactionId,
      remainingBalance: remainingBalance,
    );
  }
}
