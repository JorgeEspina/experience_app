import '../entities/order.dart';

abstract class OrderRepository {
  /// Persists an approved order and returns its id.
  Future<String> createOrder(Order order);

  /// Returns the orders belonging to a user, newest first.
  Future<List<Order>> getOrdersByUser(String userId);

  /// Fetches a single order by id.
  Future<Order> getOrderById(String orderId);
}
