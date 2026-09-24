class OrderItem {
  const OrderItem({
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.size,
    required this.colorName,
    this.imageUrl,
  });

  final String productId;
  final String name;
  final double unitPrice;
  final int quantity;
  final String size;
  final String colorName;
  final String? imageUrl;

  double get lineTotal => unitPrice * quantity;
}

/// An approved purchase stored in Firestore under `orders/{id}`.
class Order {
  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    this.transactionId,
    this.cardLast4,
    this.currency = 'USD',
  });

  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime createdAt;
  final String? transactionId;
  final String? cardLast4;
  final String currency;

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);
}
