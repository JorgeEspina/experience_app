import '../entities/payment_result.dart';

abstract class PaymentRepository {
  Future<PaymentResult> processPayment({
    required double amount,
    required String cardNumber,
    String currency,
  });
}
