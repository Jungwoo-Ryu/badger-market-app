
import 'package:badger_market/DTO/product.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .95,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          // color: kGreyBackground,
        ),
        clipBehavior: Clip.hardEdge,
        child: Image.network(
          product.imageUrls.first,
          loadingBuilder: (_, child, loadingProgress) => loadingProgress == null
              ? child
              : const Center(child: CircularProgressIndicator()),
          // color: kGreyBackground,
          colorBlendMode: BlendMode.multiply,
        ),
      ),
    );
  }
}