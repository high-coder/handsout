

import 'package:handsout/models/ourUser.dart';

class ChatTileModel{
  String chatUid;
  String chatterName;
  List<String> uid = [];

  ChatTileModel({required this.chatterName,required this.chatUid,required this.uid});



  factory ChatTileModel.fromJson({required Map<String, dynamic> jso,required OurUser currentUser, required String docId}) {

    List names = [];
    List<String> ids = [];
    jso["users"].forEach((element) {
      List temp = element.split("-");
      ids.add(temp[0]);
      names.add(temp[1]);
    });
    return ChatTileModel(
      uid:ids,
      chatterName: currentUser.uid == ids[0] ? names[1] : "${names[0]} --- ${names[1]}",
      chatUid: docId,
    );
  }
}