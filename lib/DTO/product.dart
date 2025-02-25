import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String title;
  final int price;
  final String description;
  final String createdBy;
  final Timestamp createdAt;
  final List<String> imageUrls;

  Product({
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrls,
    required this.createdBy,
    required this.createdAt
  });
  
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      title: data['title'],
      price: data['price'],
      createdBy: data['created_by'],
      createdAt: data['created_at'], 
      description: data['description'],
      imageUrls: List<String>.from(data['imageUrls']),
      // Initialize your fields here using data
    );
  }
}