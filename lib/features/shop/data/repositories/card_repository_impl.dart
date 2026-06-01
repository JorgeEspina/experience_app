import '../../domain/entities/payment_card.dart';
import '../../domain/repositories/card_repository.dart';
import '../data_sources/card_remote_data_source.dart';

class CardRepositoryImpl implements CardRepository {
  const CardRepositoryImpl({required this.remoteDataSource});

  final CardRemoteDataSource remoteDataSource;

  @override
  Future<List<PaymentCard>> getCards() async {
    final models = await remoteDataSource.getCards();
    return models.map((m) => m.toEntity()).toList();
  }
}
