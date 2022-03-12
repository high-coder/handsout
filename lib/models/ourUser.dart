import 'package:hive/hive.dart';

part 'ourUser.g.dart';

/// The user can signup using google and also with email and password
@HiveType(typeId: 123, adapterName: "OurUserDetailOriginal")
class OurUser {
  @HiveField(0)
  String? uid;

  @HiveField(1)
  bool? isCustomer; // if true then its a student else it's a teacher

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? name;

  @HiveField(4)
  String? approved; //apply // disapproved //approved

  @HiveField(5)
  String? interests;

  /// from the map to convert the data back into the normal form
  factory OurUser.fromJson(Map<String, dynamic> data) {
    return OurUser(
      uid: data['uid'],
      email: data['email'],
      isCustomer:
          data['isCustomer'] != null ? data['isCustomer'] as bool? : null,
      name: data["name"],
      //interests : data["interests"] ! = null ? data["interests"] as String? : null
      interests: data["interests"],
      approved: data["approved"],
    );
  }

  /// this will be used to save the map data in the firebase database
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "isCustomer": isCustomer,
      "name": name,
      "interests": interests,
      "approved": approved
    };
  }

  OurUser(
      {this.approved,
      this.email,
      this.isCustomer,
      this.name,
      this.uid,
      this.interests});
}
