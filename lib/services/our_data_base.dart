import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:handsout/models/interestModel.dart';
import 'package:handsout/models/postModel.dart';

import '../models/chatModel.dart';
import '../models/chatsTileModel.dart';
import '../models/ourUser.dart';


class OurDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createUser(OurUser user) async {
    String retVal = "error";

    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser();

    try {
      // this block is running fine
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("users").doc(uid).get();
      print("Above the document snapshot data");
      print(_docSnapshot.data());
      print("below the document snapshot data");
      //retVal(_docSnapshot.data()['name']);

      Map<String, dynamic>? data = _docSnapshot.data() as Map<String, dynamic>?;
      retVal = OurUser.fromJson(_docSnapshot.data() as Map<String, dynamic>);

      print("Exiting the get user information function now");
    } catch (e) {
      print("in the catch of the get user info");
      print(e);
    }
    return retVal;
  }

  Future<String> updateUserData(OurUser user) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(user.uid).update(user.toJson());
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  /// this function is responsible for creating a sucessful post to the server with also uploading the relevant file to
  /// the server
  Future<String> submitPost(PostModel post) async {
    String retVal = "error";
    try {
      //String ?downloadUrl;
      File file = File("sfhksdjf");
      if (post.file != null) {
        var random = new Random();
        int number = random.nextInt(
            100000000); // to get a random number for adding as the name to the file
        post.location = "${post.uid}/$number";
        var snapshot = await FirebaseStorage.instance
            .ref(post.location)
            .putFile(post.file ?? file);
        post.downloadLink = await snapshot.ref.getDownloadURL();
      }
      final snap = await _firestore.collection("posts").doc();
      await snap.set(post.toJson());
      await _firestore.collection("users").doc(post.uid).update({
        "activePosts": FieldValue.arrayUnion([snap.id])
      }).then((value) {
        print("everything is in order now");
      });
      retVal = "success";
    } catch (e) {
      retVal = "something went wrong try again";
    }

    return retVal;
  }

  Future<String> submitInterest(PostModel post, String uid) async {
    String retVal = "error";
    try {
      await _firestore.collection("posts").doc(post.docUid).update({
        "interested": FieldValue.arrayUnion([
          {
            "uid": uid,
            "approved": "apply",
          }
        ])
      });

      print("reached here mate");

      await _firestore.collection("users").doc(uid).update({
        "interested": FieldValue.arrayUnion([post.docUid])
      });

      // now this below list might have duplicate data to remove it add an optional if statement here and also check for the duplicate data
      // in the admin function
      if (post.interested == null) {
        await _firestore.collection("notifications").doc("thisisthat").update({
          "posts": FieldValue.arrayUnion([post.docUid])
        });
      }
      retVal = "success";
    } catch (e) {
      retVal = "something went wrong";
    }

    return retVal;
  }

  /// ------------------------------ the below two functions will fetch the posts that the user is interested in !!!!!!! -------------------
  Future<List<PostModel>> fetchIds(String uid, String collection,String additionalInfo) async {
    var snapShot = await _firestore.collection(collection).doc(uid).get();
    Map data = snapShot.data() ?? {};
    List ids = [];
    if (collection == "users") {
      if(additionalInfo == "active" || additionalInfo == "archive") {
        ids = data[additionalInfo];
      } else {
        ids = data["interested"];
      }
    } else {
      ids = data["posts"];
    }

    print(ids);
    print("something is fishy here i guess");
    List<PostModel> posts = [];
    if(collection == "users") {
      posts = await fetchPosts(ids, uid);
    } else {
      posts = await fetchPosts(ids, uid);
    }
    return posts;
  }

  Future<List<PostModel>> fetchPosts(List ids, String mainUid) async {
    List<PostModel> posts = [];


      await Future.forEach<dynamic>(ids, (element) async {
        print("insider here ");
        print(element);
        try{
          var data = await _firestore.collection("posts").doc(element).get();
          if(data.exists == true) {
            posts.add(PostModel.fromJson(data.data() ?? {}, element, mainUid));
          } else {
            var data = await _firestore.collection("approvedPosts").doc(element).get();
            print(data.data());
           // PostModel instance = PostModel.fromJson(data.data() ?? {}, element, mainUid,);

            posts.add(PostModel.fromJson(data.data() ?? {}, element, mainUid,"ap"));
          }
          print(data.data());

        }catch(e) {
          print("Inside here");
          print(e);

        }

      });
    return posts;
  }




  ///  ---------------------------- End of the functions that will fetch the posts where the user is interested.....---------------------------------------

  /// ------------- Start of the admim functions here ======================///
  Future<List<OurUser>> fetchUser(PostModel post) async {
    List<OurUser> users = [];
    try {
      List<InterestModel> filtered = [];
      post.interested?.forEach((element) {
        if(element.approved == "disapprove") {

        } else {
          filtered.add(element);
        }
      });
      await Future.forEach<InterestModel>(filtered,
          (element) async {
        var data = await _firestore.collection("users").doc(element.uid).get();
        users.add(OurUser.fromJson(data.data() ?? {}));
      });
    } catch (e) {}

    return users;
  }


  // poster, post and teacher
  Future<bool> checkChat(OurUser currentUserId,String postId, OurUser userId) async {
    bool exists = false;
    try {
      String docToSearchFor = "${currentUserId.uid}-$postId-${userId.uid}";
      var snap = await _firestore.collection("chats").doc(docToSearchFor).get();
      exists = snap.exists;
      if (exists == false) {
        var snap2 = await _firestore.collection("chats").doc(docToSearchFor);
        await snap2.set({
          "users": [
            "${currentUserId.uid}-${currentUserId.name}",
            "${userId.uid}-${userId.name}",
          ]
        });
        await _firestore.collection("users").doc(userId.uid).update({
          "chats": FieldValue.arrayUnion([snap2.id])
        });
        if(currentUserId!="thisisthat") {
          await _firestore.collection("users").doc(currentUserId.uid).update({
            "chats": FieldValue.arrayUnion([snap2.id])
          });
        }
        exists = true;
      }
    } catch (e) {}
    return exists;
  }

  Future<String> sendMessage(String docId, ChatModel chatModel) async {
    String retVal = "error";
    try {
      await _firestore
          .collection("chats")
          .doc(docId)
          .collection("chat")
          .doc(chatModel.docId)
          .set(chatModel.toJson());
      retVal = "success";
    } catch (e) {}

    return retVal;
  }


  Future<List<dynamic>> getChatRoomsIds(String uid) async{
    List<dynamic> ids = [];
    var san = await _firestore.collection("users").doc(uid).get();
    ids = san.data()!["chats"];

    return ids;
  }

  Future<List<ChatTileModel>> getChatRooms(
      {required String docId, required String collection, required OurUser currentUser}) async {
    List chatRooms = [];
    List<ChatTileModel> chatRoomsT = [];
    try {
      print("Inside the try function ");
      var snapshot = await _firestore.collection(collection).doc(docId).get();
      chatRooms =await  snapshot.data()!["chats"];
      print(chatRooms);
      await Future.forEach<dynamic>(chatRooms, (element) async{
        print("inside the llpoop");
        var snap = await _firestore.collection("chats").doc(element).get();
        if(snap.exists) {
          print(snap.data());
          chatRoomsT.add(ChatTileModel.fromJson(docId: snap.id,jso: snap.data() ?? {},currentUser: currentUser));
          print("Below this line $chatRoomsT");
        } else {
          print("something went wrong");
        }

      });
    } catch (e) {
      print(e);
    }
    return chatRoomsT;
  }


  Future<List<ChatTileModel>> getAllChatsAdmin(OurUser user) async{
    List<ChatTileModel> ids = [];

    try{
      await _firestore.collection("chats").get().then((value) {
        for (var element in value.docs) {
          ids.add(ChatTileModel.fromJson(jso: element.data(), currentUser: user, docId: element.id));
//          element.data();
        }
      });
    }catch(e) {

    }
    return ids;
  }


  Future<String> approveOrDisapproveTeacherMessage(
      {required String decision, required String postUid, required String userId, required PostModel postModel}) async {
    String retVal = "error";

    try {
      if (decision == "approve")  {
        await _firestore.collection("posts").doc(postUid).update({"stage": 2});


        await _firestore
            .collection("posts")
            .doc(postUid)
            .update({
          "interested":FieldValue.arrayRemove([{
            "approved":"apply",
            "uid":userId,
          }]),
        });
        _firestore
            .collection("posts")
            .doc(postUid)
            .update({
          "interested":FieldValue.arrayUnion([
            {
              "approved":decision,
              "uid":userId,
            }
          ]),
        });
        _firestore.collection("users").doc(userId).update({
          "active": FieldValue.arrayUnion([postUid])
        });
        _firestore.collection("users").doc(userId).update({
          "interested": FieldValue.arrayRemove([postUid])
        });
        var data = await _firestore.collection("posts").doc(postUid).get();
        var data2 =  _firestore.collection("posts").doc(postUid).delete();
        if(decision == "approve") {
          await _firestore.collection("approvedPosts").doc(postUid).set(data.data() ?? {});
          await _firestore.collection("notifications").doc("thisisthat").update({
            "posts":FieldValue.arrayRemove([postUid])
          });

          //TODO : Create a chat module between the user and the teacher

          var sna = await _firestore.collection("users").doc(postModel.uid).get();
          OurUser poster = OurUser.fromJson(sna.data() ?? {});


          var snaf = await _firestore.collection("users").doc(userId).get();
          OurUser teacher = OurUser.fromJson(snaf.data() ?? {});
          // UId of poster, post and the teacher
          await checkChat(poster,postModel.docUid ?? "", teacher);
        } else {
          //await _firestore.collection("disapprovedPosts").doc(postUid).set(data.data() ?? {});
        }


        retVal = "approve";
      }
      else {
       // await _firestore.collection("posts").doc(postUid).update({"stage": 10});

        await _firestore
            .collection("posts")
            .doc(postUid)
            .update({
          "interested":FieldValue.arrayRemove([{
            "approved":"apply",
            "uid":userId,
          }]),
        });
        await _firestore
            .collection("posts")
            .doc(postUid)
            .update({
          "interested":FieldValue.arrayUnion([
            {
              "approved":decision,
              "uid":userId,
            }
          ]),
        });
        _firestore.collection("users").doc(userId).update({
          "interested": FieldValue.arrayRemove([postUid])
        });
        await _firestore.collection("users").doc(userId).update({
          "archived": FieldValue.arrayRemove([postUid])
        });
        retVal = "dis";

      }


    } catch (E) {
      retVal = "something went wrong";
    }
    return retVal;
  }

  Future<List<OurUser>> signupApprovals() async{
    List<OurUser> users = [];
    try{
      var snapshot = await _firestore.collection("users").where("approved",isEqualTo: "apply").get();
      snapshot.docs.forEach((element) {
        users.add(OurUser.fromJson(element.data()));
      });
    }catch(e) {
      print("something went wrong");
    }

    return users;

  }

}
