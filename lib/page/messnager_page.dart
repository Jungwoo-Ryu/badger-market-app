import 'package:badger_market/services/auth/auth_service.dart';
import 'package:badger_market/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import '../components/UserTile.dart';
import 'chat_page.dart';

class MessengerPage extends StatelessWidget {
  MessengerPage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messenger"),
        
      ),
      // drawer: const MyDrawer(),
      body : _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot){
        // error
        if(snapshot.hasError){
          return const Text("Error");
        }
        // Loading..
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading..");
        }
        // return list view
        return ListView(
          children: snapshot.data!
          .map<Widget>((userData) => _buildUserListItem(userData,context)).toList(),
        );
        }
      );
  }

  Widget _buildUserListItem(
    Map<String, dynamic> userData, BuildContext context){
    // display all users except current user
    if(userData["email"] != _authService.getCurrentUser()!.email){
    return UserTile(
      text: userData["email"],
      onTap: () {
        // tapped on a user -> go to chat page
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ChatPage(
          receiverEmail: userData["email"],
          receiverID: userData["uid"],
        ),
        ),
        );
      }
    );
    } else return Container();
  }

}