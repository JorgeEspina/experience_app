import '../../domain/entities/payment_result.dart';

class PaymentResultModel {
  const PaymentResultModel({
    required this.success,
    required this.message,
    this.status,
    this.transactionId,
    this.amount,
    this.currency,
    this.cardLast4,
    this.timestamp,
  });

  final bool success;
  final String message;
  final String? status;
  final String? transactionId;
  final double? amount;
  final String? currency;
  final String? cardLast4;
  final String? timestamp;

  factory PaymentResultModel.fromJson(Map<String, dynamic> json) {
    // The backend returns `success` (bool) and `status` ("approved"/"declined").
    final status = json['status'] as String?;
    final success = json['success'] as bool? ?? (status == 'approved');

    return PaymentResultModel(
      success: success,
      message: json['message'] as String? ?? '',
      status: status,
      transactionId: json['transactionId'] as String?,
      amount: json['amount'] != null ? (json['amount'] as num).toDouble() : null,
      currency: json['currency'] as String?,
      cardLast4: json['cardLast4'] as String?,
      timestamp: json['timestamp'] as String?,
    );
  }

  PaymentResult toEntity() {
    return PaymentResult(
      approved: success,
      message: message,
      status: status,
      transactionId: transactionId,
      amount: amount,
      currency: currency,
      cardLast4: cardLast4,
      timestamp: timestamp,
    );
  }
}
