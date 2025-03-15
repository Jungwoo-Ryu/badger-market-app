import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final Timestamp timestamp;

  ChatBubble({
    required this.message,
    required this.isCurrentUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCurrentUser) ...[
                Text(
                  formattedTime,
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
                SizedBox(width: 5),
              ],
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (!isCurrentUser) ...[
                SizedBox(width: 5),
                Text(
                  formattedTime,
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}