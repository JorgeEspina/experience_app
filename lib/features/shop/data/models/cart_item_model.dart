import 'package:flutter/material.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';

class CartItemModel {
  const CartItemModel({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.productSizes,
    required this.productColorHexValues,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColorName,
    this.productImageUrl,
  });

  final String productId;
  final String productName;
  final double productPrice;
  final String productDescription;
  final List<String> productSizes;
  final List<int> productColorHexValues;
  final int quantity;
  final String selectedSize;
  final String selectedColorName;
  final String? productImageUrl;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productPrice: (json['productPrice'] as num).toDouble(),
      productDescription: json['productDescription'] as String,
      productSizes: List<String>.from(json['productSizes'] as List),
      productColorHexValues:
          List<int>.from(json['productColorHexValues'] as List),
      quantity: json['quantity'] as int,
      selectedSize: json['selectedSize'] as String,
      selectedColorName: json['selectedColorName'] as String,
      productImageUrl: json['productImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productDescription': productDescription,
      'productSizes': productSizes,
      'productColorHexValues': productColorHexValues,
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColorName': selectedColorName,
      'productImageUrl': productImageUrl,
    };
  }

  CartItem toEntity() {
    return CartItem(
      product: Product(
        id: productId,
        name: productName,
        price: productPrice,
        description: productDescription,
        sizes: productSizes,
        colors: productColorHexValues.map((hex) => Color(hex)).toList(),
        imageUrl: productImageUrl,
      ),
      quantity: quantity,
      selectedSize: selectedSize,
      selectedColorName: selectedColorName,
    );
  }

  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(
      productId: entity.product.id,
      productName: entity.product.name,
      productPrice: entity.product.price,
      productDescription: entity.product.description,
      productSizes: entity.product.sizes,
      productColorHexValues: entity.product.colors.map((c) => c.value).toList(),
      quantity: entity.quantity,
      selectedSize: entity.selectedSize,
      selectedColorName: entity.selectedColorName,
      productImageUrl: entity.product.imageUrl,
    );
  }
}
