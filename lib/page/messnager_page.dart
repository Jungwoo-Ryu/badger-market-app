import 'package:badger_market/page/chat_page.dart';
import 'package:badger_market/services/auth/auth_service.dart';
import 'package:badger_market/services/chat/chat_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessengerPage extends StatelessWidget {
  MessengerPage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messenger", style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromRGBO(161, 32, 43, 1), // Badger red color
      ),
      body: _buildChatRoomList(),
    );
  }

  Widget _buildChatRoomList() {
    return StreamBuilder(
      stream: _chatService.getChatRoomsStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return const Text("Error");
        }
        // Loading..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
        // return list view
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print("No chat rooms found");
          return const Text("No chat rooms found");
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final chatRoomData = snapshot.data![index];
            return Column(
              children: [
                _buildChatRoomListItem(chatRoomData, context),
                const Divider(height: 1),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildChatRoomListItem(Map<String, dynamic> chatRoomData, BuildContext context) {
    String otherUserID = chatRoomData['users'].firstWhere((id) => id != _authService.getCurrentUser()!.uid);
    String productID = chatRoomData['product_id'].toString();
    String lastMessage = chatRoomData['last_message'];
    Timestamp lastMessageTime = chatRoomData['last_message_time'];

    return FutureBuilder<DocumentSnapshot>(
      future: _chatService.getUserData(otherUserID),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (userSnapshot.hasError) {
          print("User data error: ${userSnapshot.error}");
          return const Text("Error");
        }
        if (!userSnapshot.hasData || userSnapshot.data!.data() == null) {
          print("No user data found for userID: $otherUserID");
          return const Text("No data");
        }

        var userData = userSnapshot.data!.data() as Map<String, dynamic>;
        String username = userData['username'];

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('products').where('product_id', isEqualTo: int.parse(productID)).get(),
          builder: (context, productSnapshot) {
            if (productSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (productSnapshot.hasError) {
              print("Product data error: ${productSnapshot.error}");
              return const Text("Error");
            }
            if (!productSnapshot.hasData || productSnapshot.data!.docs.isEmpty) {
              print("No product data found for productID: $productID");
              return const Text("No data");
            }

            var productData = productSnapshot.data!.docs.first.data() as Map<String, dynamic>;
            String productImageUrl = productData['imageUrls'][0];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(productImageUrl),
              ),
              title: Text(username),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_timeAgo(lastMessageTime)),
                  Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverID: otherUserID,
                      productID: int.parse(productID),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
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
}