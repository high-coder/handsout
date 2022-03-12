class ChatModel {
  String senderUid;
  String message;
  DateTime ts;
  String docId;


  ChatModel({
    required this.message,
    required this.docId,
    required this.senderUid,
    required this.ts
  });


  Map<String, dynamic>  toJson() {
    return {
      "senderID": senderUid,
      "message": message,
      "ts": ts,
    };
  }


  factory ChatModel.fromJson(Map<String, dynamic> json,String docId) {
    return ChatModel(
        message: json["message"],
        docId: docId,
        senderUid: json["senderID"],
        ts: json["ts"].toDate(),
    );
  }

}