import 'package:badger_market/components/chat_bubble.dart';
import 'package:badger_market/services/auth/auth_service.dart';
import 'package:badger_market/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverID;
  final int productID;

  ChatPage({
    super.key,
    required this.receiverID,
    required this.productID,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  String? username;
  bool showTimestamps = false;
  String? previousDate;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(widget.receiverID).get();
    setState(() {
      username = userDoc['username'];
    });
  }

  // send message
  void sendMessage() {
    // if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      // send the message
      _chatService.sendMessage(
        widget.receiverID,
        _messageController.text,
        widget.productID,
        Timestamp.now(), // Add the current timestamp
      );
    }

    // clear text controller
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username ?? 'Loading...', style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(161, 32, 43, 1), // Badger red color
      ),
      body: GestureDetector(
        child: Column(
          children: [
            // display all messages
            Expanded(child: _buildMessageList()),

            _buildUserInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID, widget.productID),
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
    DateTime messageDate = data['timestamp'].toDate();
    String formattedDate = '${messageDate.year}-${messageDate.month.toString().padLeft(2, '0')}-${messageDate.day.toString().padLeft(2, '0')}';

    Widget dateDivider = Container();
    if (previousDate == null || previousDate != formattedDate) {
      previousDate = formattedDate;
      dateDivider = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Divider(thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                formattedDate,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              child: Divider(thickness: 1),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        dateDivider,
        ChatBubble(
          message: data["message"],
          isCurrentUser: isCurrentUser,
          timestamp: data["timestamp"],
        ),
      ],
    );
  }

  Widget _buildUserInput(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        children: [
          // textfield should take up most of the space
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
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