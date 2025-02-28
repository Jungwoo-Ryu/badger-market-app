import 'package:badger_market/page/chat_page.dart';
import 'package:badger_market/services/auth/auth_service.dart';
import 'package:badger_market/services/chat/chat_service.dart';
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
        title: const Text("Messenger"),
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
          return const Text("Error");
        }
        // Loading..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
        // return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((chatRoomData) => _buildChatRoomListItem(chatRoomData, context))
              .toList(),
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
          return const Text("Error");
        }
        if (!userSnapshot.hasData || userSnapshot.data!.data() == null) {
          return const Text("No data");
        }

        var userData = userSnapshot.data!.data() as Map<String, dynamic>;
        String username = userData['username'];

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('products').doc(productID).get(),
          builder: (context, productSnapshot) {
            if (productSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (productSnapshot.hasError) {
              return const Text("Error");
            }
            if (!productSnapshot.hasData || productSnapshot.data!.data() == null) {
              return const Text("No data");
            }

            var productData = productSnapshot.data!.data() as Map<String, dynamic>;
            String productImageUrl = productData['imageUrls'][0];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(productImageUrl),
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
                      receiverEmail: userData['email'],
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