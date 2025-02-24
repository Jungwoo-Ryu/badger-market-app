import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String title;
  final int price;
  final String description;
  final List<String> imageUrls;

  Product({
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrls,
  });
  
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      title: data['title'],
      price: data['price'],
      description: data['description'],
      imageUrls: List<String>.from(data['imageUrls']),
      // Initialize your fields here using data
    );
  }
}