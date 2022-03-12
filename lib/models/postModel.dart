import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'interestModel.dart';

class PostModel {
  late String description;
  late String title;
  File? file;
  late String uid;
  String? downloadLink;
  String? location;
  int stage;
  String? docUid;
  DateTime postTime;
  DateTime deadLine;
  String typeOfProject;
  List<InterestModel> ?interested;
  String ?applied;


  PostModel(
      {
        required this.description,
        this.file,
        required this.title,
        required this.uid,
        this.downloadLink,
        this.location,
        required this.stage,
        this.docUid,
        required this.postTime,
        required this.deadLine,
        required this.typeOfProject,
        this.interested,this.applied
      });

  Map<String, dynamic> toJson() {

    List<Map<String,dynamic>> inter = [];
    if(interested!=null) {
      interested?.forEach((element) {
        inter.add(element.toJson());
      });
    }

    return {
      "title": title,
      "description": description,
      "uid": uid,
      "fileLocation": location,
      "downloadLink": downloadLink,
      "stage": 1,
      "docUid": null,
      "timestamp": postTime,
      "deadline":deadLine,
      "typeOfProject":typeOfProject,
      "interested" : interested!=null?inter : null,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> data, String uid, String mainUid,[String ?type]) {
    String applied = "null";
    List<InterestModel> sample = [];
    if(data["interested"]!=null) {
      data["interested"].forEach((element) {
        if(element["uid"] == mainUid) {

          print("|__________________________________________________________");
          print("|__________________________________________________________");
          print("|__________________________________________________________");
          print("Found a match mate");
          print("|__________________________________________________________");
          print("|__________________________________________________________");
          print("|__________________________________________________________");
          print(element["uid"]);
          //applied = true;
          if(element["approved"] == "approve") {
            print("approvcsbgfdsfgysdgvf suyfjusdvf sudvfsvfjhbfugyds e");
            applied = "applied";
          } else if(element["approved"] == "disapprove") {
            applied = "disapproved";
          } else if(element["approved"] == "apply") {
            applied = "apply";
          }
        }
        sample.add(InterestModel.fromJson(element));
      });
      if(applied== "null" && type == "ap") {
        print("inside here ");
        applied ="disapprove";
      }
    }

    return PostModel(
        uid: data['uid'],
        description: data["description"],
        title: data["title"],
        location: data["fileLocation"],
        downloadLink: data["downloadLink"],
        stage: data["stage"],
        docUid: uid,
        postTime: data["timestamp"] != null
            ? data["timestamp"].toDate()
            : DateTime.now(),
        deadLine: data["deadline"] != null
            ? data["deadline"].toDate()
            : DateTime.now(),
        typeOfProject: data["typeOfProject"]!=null ? data["typeOfProject"] : "",
        interested: data["interested"]!=null ? sample : null,
        applied: applied,

    );
  }
}
