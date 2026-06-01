import 'package:dio/dio.dart';
import '../models/card_model.dart';

class CardRemoteDataSource {
  CardRemoteDataSource({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const String _baseUrl = 'https://testcards-sfdkfoab2q-uc.a.run.app';

  Future<List<CardModel>> getCards() async {
    final response = await _dio.get(_baseUrl);
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> cardsJson = data['testCards'] as List<dynamic>;
    return cardsJson
        .map((json) => CardModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
