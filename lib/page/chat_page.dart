import 'package:badger_market/components/chat_bubble.dart';
import 'package:badger_market/services/auth/auth_service.dart';
import 'package:badger_market/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  final int productID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    required this.productID,
  });

  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // send message
  void sendMessage() async {
    // if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(receiverID, _messageController.text, productID);
    }

    // clear text controller
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
        backgroundColor: const Color.fromRGBO(161, 32, 43, 1), // Badger red color
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(child: _buildMessageList()),

          _buildUserInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID, productID),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // return list view
        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    return ChatBubble(
      message: data["message"],
      isCurrentUser: isCurrentUser,
    );
  }

  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        children: [
          // textfield should take up most of the space
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Type a message",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // send button
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(161, 32, 43, 1), // Badger red color
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}