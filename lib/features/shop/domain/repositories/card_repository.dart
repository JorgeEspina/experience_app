import '../entities/payment_card.dart';

abstract class CardRepository {
  Future<List<PaymentCard>> getCards();
}
