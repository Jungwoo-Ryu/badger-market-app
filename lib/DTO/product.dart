
import 'package:flutter/material.dart';

class Product {
  final String name;
  final List<String> imageUrls;
  final double cost;
  final String? description;

  /// Which overall category this product belongs in. e.g - Men, Women, Pets, etc.

  /// Represents type of product such as shirt, jeans, pet treats, etc.

  Product(
      {required this.name,
      required this.imageUrls,
      required this.cost,
      this.description,
      });
}
