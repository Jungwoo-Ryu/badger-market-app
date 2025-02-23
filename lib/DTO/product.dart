import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final double cost;
  final String description;
  final List<String> imageUrls;

  Product({
    required this.name,
    required this.cost,
    required this.description,
    required this.imageUrls,
  });
  
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      name: data['name'],
      cost: data['price'],
      description: data['description'],
      imageUrls: List<String>.from(data['imageUrls']),
      // Initialize your fields here using data
    );
  }
}