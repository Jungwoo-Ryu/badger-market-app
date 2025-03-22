import 'package:badger_market/page/chat_page.dart';
import 'package:badger_market/services/chat/chat_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../DTO/product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({required this.product, Key? key}) : super(key: key);
  final Product product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Product get product => widget.product;
  int _currentImageIndex = 0;
  bool isOwner = false;
  final PageController _pageController = PageController();
  late Future<DocumentSnapshot> _userFuture;
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    checkIfOwner();
    _userFuture = FirebaseFirestore.instance.collection('Users').doc(product.createdBy).get();
  }

  void checkIfOwner() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.uid == product.createdBy) {
      setState(() {
        isOwner = true;
      });
    }
  }

  void navigateToChat() async {
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    await _chatService.getOrCreateChatRoom(currentUserID, product.createdBy, product.productId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverID: product.createdBy,
          productID: product.productId,
        ),
      ),
    );
  }

  Widget buildProductImage(String imageUrl) {
    return InstaImageViewer(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => Center(child: CircularProgressIndicator()), // 로딩 중 표시
        errorWidget: (context, url, error) => Icon(Icons.error), // 오류 시 대체 이미지
        fit: BoxFit.contain,
        width: double.infinity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .4,
              child: PageView.builder(
                controller: _pageController,
                itemCount: product.imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return buildProductImage(product.imageUrls[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: product.imageUrls.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _pageController.animateToPage(entry.key, duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == entry.key
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<DocumentSnapshot>(
                    future: _userFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        String username = snapshot.data?['username'] ?? 'Unknown';
                        return Text(
                          'Seller: $username',
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Posted: ${_timeAgo(product.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${formatPrice(product.price)}',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: isOwner ? null : navigateToChat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOwner ? const Color.fromARGB(92, 161, 32, 43) : const Color.fromRGBO(161, 32, 43, 1),
                      ),
                      child: const Text(
                        'Chat With Seller',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp.toDate());

    if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30} month${difference.inDays ~/ 30 > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String formatPrice(int price) {
    return price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}