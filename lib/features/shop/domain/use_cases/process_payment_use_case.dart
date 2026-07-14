import '../entities/payment_result.dart';
import '../repositories/payment_repository.dart';

class ProcessPaymentUseCase {
  const ProcessPaymentUseCase({required this.repository});

  final PaymentRepository repository;

  Future<PaymentResult> call({
    required double amount,
    required String cardNumber,
    String currency = 'USD',
  }) async {
    return repository.processPayment(
      amount: amount,
      cardNumber: cardNumber,
      currency: currency,
    );
  }
}
