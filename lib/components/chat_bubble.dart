import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({required this.message, required this.isCurrentUser, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5, left: 60, right: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isCurrentUser ? const Color.fromARGB(255, 204, 65, 77) : const Color.fromRGBO(255, 204, 204, 1), // Different shades of red
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isCurrentUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}