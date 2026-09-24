import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';

/// Remote data source for orders, backed by Cloud Firestore.
///
/// Orders live in the `orders` collection, one document per purchase.
class OrderRemoteDataSource {
  OrderRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'orders';

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection(_collection);

  /// Creates an order and returns its generated id.
  Future<String> createOrder(OrderModel order) async {
    final docRef = await _orders.add(order.toCreateJson());
    return docRef.id;
  }

  /// Fetches a single order by its document id.
  Future<OrderModel> getOrderById(String orderId) async {
    final doc = await _orders.doc(orderId).get();
    final data = doc.data();
    if (!doc.exists || data == null) {
      throw Exception('Order not found: $orderId');
    }
    return OrderModel.fromJson({...data, 'id': doc.id});
  }

  /// Returns the orders that belong to [userId], newest first.
  ///
  /// Only filters by `userId` in Firestore (no `orderBy`) so it doesn't need a
  /// composite index; sorting by date is done in memory.
  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    final snapshot =
        await _orders.where('userId', isEqualTo: userId).get();

    final orders = snapshot.docs
        .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();

    // Newest first. Orders without a resolved timestamp go last.
    orders.sort((a, b) {
      final da = a.createdAt;
      final db = b.createdAt;
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return db.compareTo(da);
    });

    return orders;
  }
}
