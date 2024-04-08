import 'package:flutter/material.dart';

import '../DTO/product.dart';

class Cart with ChangeNotifier {
  List<OrderItem> itemsInCart = [];

  double get totalCost {
    double total = 0;
    for (var item in itemsInCart) {
      total += item.product.cost;
    }
    return total;
  }

  void add(OrderItem orderItem) {
    itemsInCart.add(orderItem);
    notifyListeners();
  }

  void remove(OrderItem orderItem) {
    // print(orderItem.product.name);
    itemsInCart.remove(orderItem);
    // print(t);
    notifyListeners();
  }
}

class OrderItem {
  Product product;

  /// Selected size of product; This can be null
  String? selectedSize;

  /// Selected color of product; This can be null
  String? selectedColor;

  OrderItem({required this.product, this.selectedSize, this.selectedColor});
}