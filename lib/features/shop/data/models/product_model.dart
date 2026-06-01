import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.sizes,
    required this.colorHexValues,
    this.imageUrl,
  });

  final String id;
  final String name;
  final double price;
  final String description;
  final List<String> sizes;
  final List<int> colorHexValues;
  final String? imageUrl;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      sizes: List<String>.from(json['sizes'] as List),
      colorHexValues: List<int>.from(json['colors'] as List),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'sizes': sizes,
      'colors': colorHexValues,
      'imageUrl': imageUrl,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      price: price,
      description: description,
      sizes: sizes,
      colors: colorHexValues.map((hex) => Color(hex)).toList(),
      imageUrl: imageUrl,
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      description: product.description,
      sizes: product.sizes,
      colorHexValues: product.colors.map((c) => c.value).toList(),
      imageUrl: product.imageUrl,
    );
  }
}
