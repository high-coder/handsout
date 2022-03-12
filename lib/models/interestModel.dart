class InterestModel {
  String uid;
  String approved; //apply, disapproved, approved


  InterestModel({
    required this.uid,
    required this.approved,
  });



  Map<String,dynamic> toJson() {
    return {
      "uid":uid,
      "approved":approved,
    };
  }


  factory InterestModel.fromJson(Map<String,dynamic> json) {
    return InterestModel(
      uid: json["uid"],
      approved: json["approved"],
    );
  }

}