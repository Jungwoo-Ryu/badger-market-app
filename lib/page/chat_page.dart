import 'package:badger_market/components/chat_bubble.dart';
import 'package:badger_market/components/my_textfield.dart';
import 'package:badger_market/services/auth/auth_service.dart';
import 'package:badger_market/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    });

  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // send message
  void sendMessage() async {
    // if there is something inside the textfield
    if(_messageController.text.isNotEmpty){
      // send the message
      await _chatService.sendMesssage(receiverID, _messageController.text);
    }

    // clear text controller
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmail)),
      body: Column(children: [
        //display all messages
        Expanded(child: _buildMessageList()),

        _buildUserInput(),


      ],)
    );
  }


  Widget _buildMessageList(){
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError){
          return const Text("Error");
        }

        // loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading...");
        }

        //return list view
        return ListView(
          children: 
          snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );



    });
    }

    // build message item
    Widget _buildMessageItem(DocumentSnapshot doc){
      Map<String,dynamic> data = doc.data() as Map<String, dynamic>;
      bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

      var alignment =
      isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
      
      return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
            ,
          ],
        ),
      );
    }
    Widget _buildUserInput() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Row(children: [
          // textfield should take up most of the space
          Expanded(
            child: myTextField(
              controller: _messageController,
              hintText: "Type a message",
              obsecureText: false,
            ),
          ),
      
          // send button
          Container(
            decoration: const 
              BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage, 
              icon: const Icon(Icons.arrow_upward,
                color: Colors.white),
              ),
          )
        ],
        ),
      );
    }

}