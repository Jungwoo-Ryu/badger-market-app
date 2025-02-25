import 'package:badger_market/DTO/product.dart';
import 'package:badger_market/cart/product_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({required this.product, Key? key}) : super(key: key);

  final Product product;

  Future<String> _fetchUsername(String uid) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    if (userSnapshot.exists) {
      return userSnapshot['username'];
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemSound.play(SystemSoundType.click);
        _pushScreen(
          context: context,
          screen: ProductScreen(product: product),
        );
      },
      child: FutureBuilder<String>(
        future: _fetchUsername(product.createdBy),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String username = snapshot.data ?? 'Unknown';
            return Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.network(
                    product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/error_image.png', width: 80, height: 80, fit: BoxFit.cover);
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${product.price.toString()}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Theme.of(context).colorScheme.secondary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$username',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _pushScreen({required BuildContext context, required Widget screen}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}