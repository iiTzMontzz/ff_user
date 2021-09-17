import 'package:cloud_firestore/cloud_firestore.dart';

final String userId = "8NI5nlcr8YTy3EXN7pUUVfxyU7T2";

class DataFunction {
  getConversation(String historyID) async {
    await null;
    return Firestore.instance
        .collection("userChatRooms")
        .document(historyID)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  addConversation(String historyID, messageMap) async {
    Firestore.instance
        .collection("userChatRooms")
        .document(historyID)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future getChatList(String tripID) async {
    List chatList = [];
    try {
      await Firestore.instance
          .collection('userChatRooms')
          .document(tripID)
          .collection("chats")
          .getDocuments()
          .then((snap) {
        snap.documents.forEach((element) {
          print(element.data);
          chatList.add(element.data);
        });
      });
      chatList.sort((a, b) => a["timestamp"].compareTo(b["timestamp"]));
      return chatList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
