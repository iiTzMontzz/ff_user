import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_user/messeging/data_functions.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_global/glob_var.dart';
import 'package:ff_user/shared_folder/_global/tripVariables.dart';
import 'package:flutter/material.dart';

class ChatRoomList extends StatefulWidget {
  // const ChatRoomList({Key? key}) : super(key: key);
  final String tripID;

  const ChatRoomList({this.tripID});

  @override
  _ChatRoomListState createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  TextEditingController messageBox = new TextEditingController();
  String msg = "";
  DataFunction _df = new DataFunction();
  List chatLists = [];

  Widget chatList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("userChatRooms")
          .document(widget.tripID)
          .collection("chats")
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Center(
            child: Text("No message found!"),
          );
        } else {
          return ListView(
            children: snap.data.documents.map<Widget>((doc) {
              return _chatBubble(context, doc['message'], doc["sendBy"]);
            }).toList(),
          );
        }
      },
    );
  }

  sendMessage(uid) {
    print("messageBox.text value--------------------------------------");
    print(msg);
    if (msg != null) {
      Map<String, dynamic> messageMap = {
        "message": msg,
        "sendBy": uid,
        "timestamp": DateTime.now(),
      };
      _df.addConversation(widget.tripID, messageMap);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchChatList();
  }

  fetchChatList() async {
    dynamic result = await _df.getChatList(widget.tripID);
    if (result == null) {
      print("unable to retrieve");
    } else {
      setState(() {
        chatLists = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 15, right: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width / 0.1,
          height: MediaQuery.of(context).size.height / 1.1,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title --------------------------------------
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 15),
                    child: Row(
                      children: [
                        //  Image -------------------------------
                        CircleAvatar(
                          backgroundColor: Colors.blue[300],
                          child: Text(
                            driverName.substring(0, 1),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          radius: 30,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name --------------------------
                            Text(
                              driverName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: Colors.black87),
                            ),
                            // Email --------------------------
                            Text(
                              'Driver',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Muli',
                                fontWeight: FontWeight.w300,
                                fontSize: getProportionateScreenHeight(18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Close --------------------------------------
                  Container(
                    margin: EdgeInsets.only(right: 15, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.close_rounded,
                          size: 27,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Message List -------------------------------------
              Container(
                margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                height: MediaQuery.of(context).size.width / 0.8,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: <Widget>[
                    SizedBox(height: 5),
                    // CHAT LIST -------------------------------------------
                    chatList(),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                child: Row(
                  children: [
                    Expanded(
                      // Message text input -------------------------
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        child: TextFormField(
                          controller: messageBox,
                          onChanged: (val) {
                            setState(() {
                              msg = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Message",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    // Send Message -----------------------------------
                    GestureDetector(
                      onTap: () {
                        sendMessage(currentUserinfo.uid);
                        setState(() {
                          messageBox.text = "";
                          msg = "";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xff2A75BC),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatBubble(context, String messages, String sendBy) {
    bool isSendByMe;
    if (sendBy == currentUserinfo.uid) {
      isSendByMe = true;
    } else {
      isSendByMe = false;
    }
    return Container(
      padding: EdgeInsets.only(
        top: 5,
        left: isSendByMe ? 55 : 0,
        right: isSendByMe ? 0 : 55,
      ),
      margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          color: isSendByMe ? Colors.blue[400] : Colors.grey[400],
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
        ),
        child: Text(messages,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 17,
            )),
      ),
    );
  }

// TEMPO
}
