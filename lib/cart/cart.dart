import '../DTO/product.dart';

class OrderItem {
  final Product product;
  final String? selectedSize;

  OrderItem({
    required this.product,
    this.selectedSize,
  });
}

class Cart {
  final List<OrderItem> _items = [];

  void add(OrderItem item) {
    _items.add(item);
    // You can add additional logic here, such as notifying listeners or updating the UI
  }

  List<OrderItem> get items => _items;
}

final cart = Cart();