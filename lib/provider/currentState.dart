import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/chatModel.dart';
import '../models/chatsTileModel.dart';
import '../models/ourUser.dart';
import '../models/postModel.dart';
import '../services/our_data_base.dart';
class CurrentState extends ChangeNotifier {

  final _auth = FirebaseAuth.instance;

  // this will contain all the information about the user
  OurUser currentUser = OurUser();
  late Box userBox;
  late Size size;

  /// this will be called everytime and will be used to navigate to the pages of the screen
  Future<String> onStartUp() async {
    //await _auth.signOut();
    String where = "signup";
    userBox = await Hive.openBox("userDetails");
    //await signOut();

    OurUser ?currentUser2;
    currentUser2 = await userBox.get("data");

    // Navigate to the first screen of the application
    if (currentUser2 == null) {
      print("Inside here");
      where = "signup";
    }
    else if (currentUser2 != null) {
      print("Inside the else condition mate");
      currentUser = currentUser2;
      // Navigate the user to the type selection screen
      if (currentUser2.isCustomer == null) {
        where = "type";
      }
      // ok everything seems
      else {

        print("inside the second else");

        print("Inside ${currentUser.approved}");
        if(currentUser2.uid == "thisisthat") {
          where = "admin";
          return where;
        }
        // navigate the user to the student home page
        if (currentUser2.isCustomer == true) {
          where = "student";
        }
        else if(currentUser2.approved !=null) {
          print("Inside here");
          if(currentUser2.approved == "apply") {
            // navigate to the verification pending screen
            currentUser2 = await OurDatabase().getUserInfo(currentUser2.uid ?? "");
            await userBox.put("data", currentUser2);
            if(currentUser2.approved!="apply"){
              return onStartUp();
            }
            where = "apply";
            return "apply";
          } else if(currentUser2.approved == "approved") {
            where = "teacher";
            return "teacher";
            // navigate to the home page
          } else if(currentUser2.approved == "disapproved") {
            // navigate to the verification failed page
            where = "failed";
            return "failed";
          }
        }
        // Navigate the user to the teacher home page
        // else {
        //   where = "teacher";
        // }
      }
    }

    return where;
  }

  Future<String> loginUserWithGoogle() async {
    String retVal = "error";


    if(kIsWeb)  {
      print("This is a web appication here");
      User ?user;
      final GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);

        user = userCredential.user;

        if(user!=null) {
          if (userCredential.additionalUserInfo?.isNewUser ?? false) {
            print("this is a new user so make an account for ");
            print("this is tha ");
            currentUser.email = userCredential.user?.email;
            currentUser.name = userCredential.user?.displayName;
            currentUser.uid = userCredential.user?.uid;
            currentUser.approved = "apply";
            //print(_authResult.user.e)
            print(currentUser.uid);
            print(userCredential.user?.uid);
            String retVal34 = await OurDatabase().createUser(currentUser);
            retVal = retVal34;
            // this will then save the data of the user in the local database
            if (retVal34 == "success") {
              userBox.put("data", currentUser);
            }

            else {
              // in an actually correct application i should either delete the account of the user or do something about it

            }
          }
          else {
            currentUser.uid = userCredential.user?.uid;
            print("this is an old user so lets welcome him/her");
            // get the information of the user from the database this already exists
            currentUser = await OurDatabase().getUserInfo(currentUser.uid ?? "");
            print(currentUser.toJson());
            print("-------------------------------------------");
            if (currentUser.uid != null) {
              retVal = "success";
              userBox.put("data", currentUser);
            }
          }
        }
      }on FirebaseAuthException catch (e) {
        retVal = "something went wrong";
        print(
            "Entering the catch block in the google signin function===========");
        print(e.message);
      }


    }
    else {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      try {
        //OurUser _user = OurUser();
        // The first line sign the user into their google account
        GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
        //These create the google account on firebase for us
        GoogleSignInAuthentication ?_googleAuth = await _googleUser
            ?.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: _googleAuth?.idToken, accessToken: _googleAuth?.accessToken);
        UserCredential _authResult = await _auth.signInWithCredential(credential);


        if (_authResult.additionalUserInfo?.isNewUser ?? false) {
          print("this is a new user so make an account for ");
          print("this is tha ");
          currentUser.email = _authResult.user?.email;
          currentUser.name = _authResult.user?.displayName;
          currentUser.uid = _authResult.user?.uid;
          currentUser.approved = "apply";
          //print(_authResult.user.e)
          print(currentUser.uid);
          print(_authResult.user?.uid);
          String retVal34 = await OurDatabase().createUser(currentUser);
          retVal = retVal34;
          // this will then save the data of the user in the local database
          if (retVal34 == "success") {
            userBox.put("data", currentUser);
          }

          else {
            // in an actually correct application i should either delete the account of the user or do something about it

          }
        }
        else {
          currentUser.uid = _authResult.user?.uid;
          print("this is an old user so lets welcome him/her");
          // get the information of the user from the database this already exists
          currentUser = await OurDatabase().getUserInfo(currentUser.uid ?? "");
          print(currentUser.toJson());
          print("-------------------------------------------");
          if (currentUser.uid != null) {
            retVal = "success";
            userBox.put("data", currentUser);
          }
        }
        // await saveAllData();
        //_currentUser = await OurDatabase().getUserInfo(_authResult.user.uid);
        print("Above the uid---------------");
        // print(currentUser);
        //  if (currentUser != null) {
        //    retVal = "success";
        //  }
      } on FirebaseAuthException catch (e) {
        retVal = "something went wrong";
        print(
            "Entering the catch block in the google signin function===========");
        print(e.message);
      }
      //print(retVal);
    }
    return retVal;
  }

  /// this is the function to update the data in the application
  Future<String> updateUserData({bool ?customerType, String? interests}) async {
    disableScreen = true;
    notifyListeners();
    String retVal = "error";
    currentUser.isCustomer = customerType;
    currentUser.interests = interests;

    if(currentUser.isCustomer == true) {
      currentUser.approved = "approved";
    }
    retVal = await OurDatabase().updateUserData(currentUser);

    if (retVal == "success") {
      userBox.put("data", currentUser);
    }
    disableScreen = false;
    notifyListeners();
    return retVal;
  }

  /// this is the function to create a new user in the application
  Future<String> createNewUser(
      {required String name, required String email, required String password}) async {
    String retVal = "error";
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (result.user != null) {
        User? user = result.user;
        currentUser.email = user?.email;
        currentUser.name = name;
        currentUser.uid = user?.uid;
        currentUser.approved = "apply";

        retVal = await OurDatabase().createUser(currentUser);

        if (retVal == "success") {
          userBox.put("data", currentUser);
        }
      }

      // await DatabaseManager().getUsersList(user.uid);

    } on FirebaseAuthException catch (e) {
      retVal = e.message ?? "something went wrong";
    }

    return retVal;
  }


  /// this is the function to login in the application
  Future<String> loginUser(String email, String password) async {
    String retVal = "error";
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        retVal = "success";

        currentUser = await OurDatabase().getUserInfo(result.user?.uid ?? "");
        if(currentUser.uid == "thisisthat") {

        }

        userBox.put("data", currentUser);

        // currentUser.email = result.user?.email;
        // currentUser.uid = result.user?.displayName;
      }
    } on FirebaseAuthException catch (e) {
      retVal = e.message ?? "something went wrong";
      print(e.toString());
    }
    return retVal;
  }

  // this is the function to sign out of the application
  Future signOut() async {
    try {
      await _auth.signOut();
      await userBox.delete("data");
      currentUser = OurUser();
      return;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }


  /// This function will be responsible for creating a post for the user
  ///

  PostModel ?postInstance;


  bool disableScreen =false;
  Future<String> createPost({required PostModel post})async {
    disableScreen = true;
    notifyListeners();
    print(post.toJson());

    String retVal = "error";
    retVal = await OurDatabase().submitPost(post);

    disableScreen = false;
    notifyListeners();
    return retVal;
  }


  /// Teacher section -------------------------------------------------------------------------
  List<PostModel> postIds = [];
  Stream fetchPost() async* {

    postIds.clear();
    print("Entering the post function");
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    int i = 0;
    var ac =  _firestore.collection("posts").orderBy('timestamp').snapshots();
    //print(ac.first);

    ac.listen((event) {
//      postIds.clear();
      //print(i);
      for (var element in event.docChanges) {
        print(i);
        i++;
        int index = 0;
        // removing the document that was already in the list and inserting it at the same index as before
        postIds.removeWhere((element2)
        {
          if(element2.docUid == element.doc.id) {
            index = postIds.indexOf(element2);
          }
          return element2.docUid == element.doc.id;
        });

        // now adding this again
        postIds.insert(index,PostModel.fromJson(element.doc.data() ?? {},element.doc.id,currentUser.uid ?? ""));
      }
      /// one way to do things
      // event.docs.forEach((element) {
      //
      //   print(element.data());
      //
      //   print(i);
      //   i++;
      //   postIds.insert(0,PostModel.fromJson(element.data(),element.id));
      //   notifyListeners();
      //
      // });
      notifyListeners();

    });
    print(postIds.length);

    yield postIds;
  }


  Future<String> applyForPost() async{
    String retVal = "error";
    disableScreen = true;
    notifyListeners();
    retVal = await OurDatabase().submitInterest(postInstance!, currentUser.uid ?? "");
    await Future.delayed(Duration(seconds: 2));
    if(retVal == "success") {
      postInstance?.applied = "apply";
    }
    disableScreen = false;
    notifyListeners();
    return retVal;
  }

  // this is used to fetch the old posts that the user once applied for in the past
  List<PostModel> interestedPosts = [];
  List<PostModel> activePosts = [];
  List<PostModel> archivePosts = [];
  Future<String> fetchAppliedPosts(String additionalInfo) async{
   if(additionalInfo == "active") {
     activePosts =  await OurDatabase().fetchIds(currentUser.uid ?? "","users",additionalInfo);
   } else if(additionalInfo == "archive"){
     archivePosts =  await OurDatabase().fetchIds(currentUser.uid ?? "","users",additionalInfo);
   } else {
     interestedPosts =  await OurDatabase().fetchIds(currentUser.uid ?? "","users",additionalInfo);

   }

   print(interestedPosts.length);
   String retVal = "error";
   if(interestedPosts.isEmpty) {
     retVal = "no data";
   } else if(interestedPosts.isNotEmpty) {
     retVal = "success";
   }
   notifyListeners();
    return retVal;
  }



  List<ChatTileModel> chatIds= [];
  Future<String> getChatRooms(String collection) async{
    chatIds.clear();
    String retVal = "something";
    if(collection == "users") {
      print("above the line to fetch the details of the chat room");
      chatIds = await OurDatabase().getChatRooms(collection: "users",docId: currentUser.uid ?? "", currentUser: currentUser);
      print("done bro");
      print(chatIds);
    } else {
      chatIds= await OurDatabase().getAllChatsAdmin(currentUser);


      sortAllChats();

    }
    notifyListeners();
    print(chatIds);
    print("Ending this function");
    return retVal;
  }


  List<ChatTileModel> adminChatsTile = [];
  List<ChatTileModel> userChats = [];
  sortAllChats() {
    adminChatsTile.clear();
    userChats.clear();
    chatIds.forEach((element) {
      if(element.chatUid.contains("thisisthat")){
        adminChatsTile.add(element);
      } else{
        userChats.add(element);
      }
    });
    //
    //
    // for (var element in chatIds) {
    //
    // }
  }

  /// ---------------------------- ADmin Application Starts here ------------------------
  
  List<PostModel> ?interestedPostsAdmin;
  Future<String> fetchInterestedPosts() async{
    String retVal = "error";
    interestedPostsAdmin?.clear();
    interestedPostsAdmin = await OurDatabase().fetchIds("thisisthat","notifications","none");

    return retVal;
  }

  Stream getInterestedPeeps() async*{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List ids = [];

    var ac = _firestore.collection("notifications").doc("thisisthat").snapshots();

    ac.listen((event) async{
      ids = event.data()!["posts"];
      print(ids);
      interestedPostsAdmin = await OurDatabase().fetchPosts(ids, "thisisthat");
      notifyListeners();
    });

  }


  List<PostModel> approvedPosts= [];
  List<PostModel> disapproved= [];
  getApprovedPosts(String approved) async{
    if(approved == "approvedPosts") {
      approvedPosts.clear();
    } else {
      disapproved.clear();
    }
    try{
      var snaps= FirebaseFirestore.instance.collection(approved).get();
      await snaps.then((value) => value.docs.forEach((element) {
        if(approved == "approvedPosts") {
          approvedPosts.add(PostModel.fromJson(element.data(), element.id, currentUser.uid ?? "thisisthat"));
        } else{
          disapproved.add(PostModel.fromJson(element.data(), element.id, currentUser.uid ?? "thisisthat"));
        }
      }));

      notifyListeners();

    }catch(e) {
      print(e);
    }
  }

  List<OurUser>  interestedUser  =[];
  Future<String> fetchInterestedPeeps() async{
    String retVal = "error";

    interestedUser=  await OurDatabase().fetchUser(postInstance!);

    return retVal;
  }

  // check if the chat exists or not
  //late String selectedUid;

  late String chatDoc;
  Future<String> createOrCheckChat(OurUser selectedUid) async {

    chatDoc = "thisisthat-${postInstance?.docUid}-${selectedUid.uid}";
    String retVal = "error";

    bool exists = await OurDatabase().checkChat(currentUser,postInstance?.docUid ?? "",selectedUid);
    print(exists);
    return retVal;
  }


  // This function will be used to fetch all the user who have submitted for there approval
  List<OurUser> toApproveUser = [];
  signupApproval() async{
    toApproveUser=  await OurDatabase().signupApprovals();
    notifyListeners();
  }

  // this function will approve the user signup process
  Future<String> approveUserSignup(int index, String approve) async{
    disableScreen = true;
    notifyListeners();
    String retVal = "error";
    try{

      await FirebaseFirestore.instance.collection("users").doc(toApproveUser[index].uid).update({
        "approved":approve
      });


      retVal = "success";
      toApproveUser.remove(toApproveUser[index]);
    } catch(e) {
      print("something went wrong");
      retVal = "something went wrong";
    }

    disableScreen = false;
    notifyListeners();
    return retVal;
  }
  /// -------------------------------------- Common Functions ----------------------------------------------
  Future<Stream<QuerySnapshot>> getChatRoomMessages() async {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatDoc)
        .collection("chat")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  List<dynamic> chatRoomsIds = [];
  getChatRoomIds() async{
    print("dfuigsdfgisdbf Endtering tyhis fucntion ");
    chatRoomsIds = await OurDatabase().getChatRoomsIds(currentUser.uid ?? "");
    print(chatRoomsIds);
    chatRoomsIds.forEach((element) {
      String toSearch = "${currentUser.uid}-${postInstance?.docUid}-";
      String toSearch2 = "-${postInstance?.docUid}-${currentUser.uid}";

      print("To Search ------- ${toSearch}");
      print("To Search ------- ${toSearch2}");
      bool found = false;
      if(element.contains(toSearch) ||element.contains(toSearch2)) {
        print("found the match");
        found = true;
        print(element);
        chatDoc = element;
      }

    });
  }

  List<ChatModel> userMessages = [];
  sendMessage(ChatModel chatModel) async {
    String retVal  =await OurDatabase().sendMessage(chatDoc, chatModel);
    print(retVal);
  }

  approveDis(String decision, OurUser model,int index) async{
    disableScreen = true;
    notifyListeners();
    String retVal = await OurDatabase().approveOrDisapproveTeacherMessage(decision: decision, postUid: postInstance?.docUid ?? "", userId: model.uid ?? "",postModel: postInstance!);

    if(retVal == "dis") {
      interestedUser.remove(interestedUser[index]);
    } else {

    }
    disableScreen = false;
    notifyListeners();

  }
}