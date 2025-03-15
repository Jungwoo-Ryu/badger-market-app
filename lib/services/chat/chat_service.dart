import 'package:badger_market/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();
        // return user
        return user;
      }).toList();
    });
  }

  Future<void> getOrCreateChatRoom(String currentUserID, String receiverID, int productID) async {
    // construct chat room ID for the two users and product ID (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort the ids (this ensures the chatRoomID is the same for any 2 people)
    String chatRoomID = '${ids.join('_')}_$productID';

    // check if chat room exists
    DocumentSnapshot chatRoomSnapshot = await _firestore.collection("chat_rooms").doc(chatRoomID).get();

    if (!chatRoomSnapshot.exists) {
      // create chat room if it doesn't exist
      await _firestore.collection("chat_rooms").doc(chatRoomID).set({
        'users': ids,
        'product_id': productID,
        'last_message': '',
        'last_message_time': FieldValue.serverTimestamp(),
        'delt_yn': 'N',
      });
    }
  }

  Future<DocumentSnapshot> getUserData(String userID) async {
    return await FirebaseFirestore.instance.collection('Users').doc(userID).get();
  }

  // send message
  Future<void> sendMessage(String receiverID, String message, int productID, Timestamp timestamp) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;

    // create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room ID for the two users and product ID (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort the ids (this ensures the chatRoomID is the same for any 2 people)
    String chatRoomID = '${ids.join('_')}_$productID';

    // add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

    // update chat room metadata
    await _firestore.collection("chat_rooms").doc(chatRoomID).set({
      'users': ids,
      'product_id': productID,
      'last_message': message,
      'last_message_time': timestamp,
      'delt_yn': 'N',
    }, SetOptions(merge: true));
  }

  // get chat rooms for the current user
  Stream<List<Map<String, dynamic>>> getChatRoomsStream() {
    final String currentUserID = _auth.currentUser!.uid;
    return _firestore
        .collection("chat_rooms")
        .where('users', arrayContains: currentUserID)
        .where('delt_yn', isEqualTo: 'N')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID, int productID) {
    // construct a chat room ID for the two users and product ID
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = '${ids.join('_')}_$productID';

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}