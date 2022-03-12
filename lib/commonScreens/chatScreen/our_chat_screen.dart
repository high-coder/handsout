import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:random_string/random_string.dart';

import '../../models/chatModel.dart';
import '../../provider/currentState.dart';
import '../../utils/our_colours.dart';

class ChatScreen extends StatefulWidget {
  bool ?allowChat = true;
  ChatScreen({this.allowChat});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 late String chatRoomId, messageId = "";
  Stream<QuerySnapshot> ?messageStream;
  late String myName, myProfilePic, myEmail;
  TextEditingController messageTextEdittingController = TextEditingController();


 Widget chatMessageTile(String message, bool sendByMe) {
   return Row(
     mainAxisAlignment:
     sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
     children: [
       Flexible(
         child: Container(
             margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(24),
                 bottomRight:
                 sendByMe ? Radius.circular(0) : Radius.circular(24),
                 topRight: Radius.circular(24),
                 bottomLeft:
                 sendByMe ? Radius.circular(24) : Radius.circular(0),
               ),
               color: sendByMe ? Colors.blue : MyColors.appThemeBlue,
             ),
             padding: EdgeInsets.all(16),
             child: Text(
               message,
               style: TextStyle(color: Colors.white),
             )),
       ),
     ],
   );
 }

  addMessage(bool sendClicked) async{
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);

    if (messageTextEdittingController.text != "") {
      String message = messageTextEdittingController.text;

      var lastMessageTs = DateTime.now();

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      ChatModel _chat = ChatModel(message: message, senderUid: _instance.currentUser.uid ?? "", ts: lastMessageTs, docId: messageId);



       _instance.sendMessage(_chat);
      // DatabaseMethods()
      //     .addMessage(chatRoomId, messageId, messageInfoMap)
      //     .then((value) {
      //   Map<String, dynamic> lastMessageInfoMap = {
      //     "lastMessage": message,
      //     "lastMessageSendTs": lastMessageTs,
      //     "lastMessageSendBy": myUserName
      //   };
      //
      //   DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          // remove the text in the message input field
          messageTextEdittingController.text = "";
          // make message id blank to get regenerated on next message send
          messageId = "";
        }
      }
    }

    @override
  void initState() {
    super.initState();
    doThis();
  }
  doThis() async{
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);

    messageStream = await _instance.getChatRoomMessages();
    setState(() {

    });
  }
  Widget chatMessages() {
   CurrentState _instance = Provider.of<CurrentState>(context, listen: false);

   return StreamBuilder(
     stream: messageStream,
     builder: (context,AsyncSnapshot snapshot) {
       return snapshot.hasData
           ? ListView.builder(
           padding: EdgeInsets.only(bottom: 70, top: 16),
           itemCount: snapshot.data?.docs.length?? 0,
           reverse: true,
           itemBuilder: (context, index) {
             print(snapshot.data?.docs[index]);
             DocumentSnapshot ds = snapshot.data?.docs[index];
             return chatMessageTile(
                 ds["message"], _instance.currentUser.uid == ds["senderID"]);
           })
           : Center(child: CircularProgressIndicator());
     },
   );
   return Container();
 }

  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Page"),
      ),
      body: Container(
        child: Stack(
          children: [
            messageStream!=null ? chatMessages() : Container(),
            widget.allowChat == true ? Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                           controller: messageTextEdittingController,
                          onChanged: (value) {
                            // addMessage(false);
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "type a message",
                              hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.6))),
                        )),
                    GestureDetector(
                      onTap: () {
                        addMessage(true);
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ): Container(),
          ],
        ),
      ),
    );
  }
  }
