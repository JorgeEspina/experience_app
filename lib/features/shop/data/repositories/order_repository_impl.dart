import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../data_sources/order_remote_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl({required this.remoteDataSource});

  final OrderRemoteDataSource remoteDataSource;

  @override
  Future<String> createOrder(Order order) {
    final model = OrderModel(
      id: order.id,
      userId: order.userId,
      items: order.items.map(OrderItemModel.fromEntity).toList(),
      total: order.total,
      status: order.status,
      createdAt: order.createdAt,
      transactionId: order.transactionId,
      cardLast4: order.cardLast4,
      currency: order.currency,
    );
    return remoteDataSource.createOrder(model);
  }

  @override
  Future<List<Order>> getOrdersByUser(String userId) async {
    final models = await remoteDataSource.getOrdersByUser(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Order> getOrderById(String orderId) async {
    final model = await remoteDataSource.getOrderById(orderId);
    return model.toEntity();
  }
}
