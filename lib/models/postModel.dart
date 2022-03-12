import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'interestModel.dart';

class PostModel {
  late String description;
  late String title;
  XFile? file;
  String? downloadLink; // this will be the image link that can be usedd to
  String? location; // this is the location at which the photo will be saved
  String? postDocUid;
  DateTime postTime;
  DateTime deadLine;
  String? hashTags;
  double totalDonationNeeded;
  double donatedTillNow;
  String posterUid;

  PostModel({
    required this.totalDonationNeeded,
    required this.description,
    this.file,
    required this.title,
    required this.posterUid,
    this.downloadLink,
    this.location,
    required this.postTime,
    required this.deadLine,
    required this.donatedTillNow,
    this.hashTags,
    this.postDocUid,
  });

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> inter = [];

    return {
      "title": title,
      "description": description,
      "posterUid": posterUid,
      "fileLocation": location,
      "downloadLink": downloadLink,
      "postDocUid": postDocUid,
      "timestamp": postTime,
      "deadline": deadLine,
      "hashTags": hashTags,
      "postTime": postTime,
      "donatedTillNow": donatedTillNow,
      "totalDonationNeeded" : totalDonationNeeded,
    };
  }

  factory PostModel.fromJson(
      Map<String, dynamic> data, String uid, String mainUid,
      [String? type]) {


    return PostModel(
      totalDonationNeeded :data["totalDonationNeeded"] as double,
      description: data["description"],
      title: data["title"],
      location: data["fileLocation"],
      downloadLink: data["downloadLink"],


      postTime: data["timestamp"] != null
          ? data["timestamp"].toDate()
          : DateTime.now(),
      deadLine:
          data["deadline"] != null ? data["deadline"].toDate() : DateTime.now(),
      donatedTillNow: data["donatedTillNow"].toDouble(),
      posterUid: data["posterUid"],
      hashTags: data["hashTags"],
      postDocUid: data["postDocUid"],
    );
  }
}
