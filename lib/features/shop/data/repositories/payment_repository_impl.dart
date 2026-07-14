import '../../domain/entities/payment_result.dart';
import '../../domain/repositories/payment_repository.dart';
import '../data_sources/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl({required this.remoteDataSource});

  final PaymentRemoteDataSource remoteDataSource;

  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String cardNumber,
    String currency = 'USD',
  }) async {
    final model = await remoteDataSource.processPayment(
      amount: amount,
      cardNumber: cardNumber,
      currency: currency,
    );
    return model.toEntity();
  }
}
