import 'package:dio/dio.dart';
import '../models/payment_result_model.dart';

class PaymentRemoteDataSource {
  PaymentRemoteDataSource({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const String _baseUrl =
      'https://processpayment-sfdkfoab2q-uc.a.run.app';

  Future<PaymentResultModel> processPayment({
    required double amount,
    required String cardNumber,
    String currency = 'USD',
  }) async {
    final response = await _dio.post(
      _baseUrl,
      data: {
        'amount': amount,
        'cardNumber': cardNumber,
        'currency': currency,
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    final data = response.data as Map<String, dynamic>;
    return PaymentResultModel.fromJson(data);
  }
}
