import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

import '../../domain/entities/order.dart';

class OrderItemModel {
  const OrderItemModel({
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

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      size: json['size'] as String? ?? '',
      colorName: json['colorName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'size': size,
      'colorName': colorName,
      'imageUrl': imageUrl,
    };
  }

  OrderItem toEntity() => OrderItem(
        productId: productId,
        name: name,
        unitPrice: unitPrice,
        quantity: quantity,
        size: size,
        colorName: colorName,
        imageUrl: imageUrl,
      );

  factory OrderItemModel.fromEntity(OrderItem e) => OrderItemModel(
        productId: e.productId,
        name: e.name,
        unitPrice: e.unitPrice,
        quantity: e.quantity,
        size: e.size,
        colorName: e.colorName,
        imageUrl: e.imageUrl,
      );
}

class OrderModel {
  const OrderModel({
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
  final List<OrderItemModel> items;
  final double total;
  final String status;
  final DateTime? createdAt;
  final String? transactionId;
  final String? cardLast4;
  final String currency;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? [])
        .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final ts = json['createdAt'];
    return OrderModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      items: rawItems,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'approved',
      createdAt: ts is Timestamp ? ts.toDate() : null,
      transactionId: json['transactionId'] as String?,
      cardLast4: json['cardLast4'] as String?,
      currency: json['currency'] as String? ?? 'USD',
    );
  }

  /// Payload for writing to Firestore. Uses a server timestamp for createdAt.
  Map<String, dynamic> toCreateJson() {
    return {
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'status': status,
      'transactionId': transactionId,
      'cardLast4': cardLast4,
      'currency': currency,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Order toEntity() => Order(
        id: id,
        userId: userId,
        items: items.map((e) => e.toEntity()).toList(),
        total: total,
        status: status,
        createdAt: createdAt ?? DateTime.now(),
        transactionId: transactionId,
        cardLast4: cardLast4,
        currency: currency,
      );
}
