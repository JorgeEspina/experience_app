import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.sizes,
    required this.colors,
    this.imageUrl,
  });

  final String id;
  final String name;
  final double price;
  final String description;
  final List<String> sizes;
  final List<Color> colors;
  final String? imageUrl;
}
