import '../entities/payment_card.dart';
import '../repositories/card_repository.dart';

class GetCardsUseCase {
  const GetCardsUseCase({required this.repository});

  final CardRepository repository;

  Future<List<PaymentCard>> call() async {
    return repository.getCards();
  }
}
