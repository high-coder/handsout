import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../commonScreens/localWidgets/our_custom_navbar.dart';
import '../provider/bottom_navbar.dart';
import '../provider/currentState.dart';
import '../teacher/profileScreen/our_profile_screen.dart';
import 'homeScreen/our_home_page.dart';


class OurHomePageMainUser extends StatefulWidget {
  const OurHomePageMainUser({Key? key}) : super(key: key);

  @override
  _OurHomePageMainUserState createState() => _OurHomePageMainUserState();
}

class _OurHomePageMainUserState extends State<OurHomePageMainUser> {

  //
  // @override
  // void dispose() {
  //   CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
  //   _instance.fetchPost().drain();
  //   super.dispose();
  //
  // }

  Widget returnCurrentScreen(){
    BottomNavBarHelper _navBarHelp =
    Provider.of<BottomNavBarHelper>(context, listen: false);
    if(_navBarHelp.selectedIndex == 0){
      return OurHomePageUser();
    }
    // else if(_navBarHelp.selectedIndex  == 1){
    //   //return AllChatsFetch(collection: "users",);
    //   return Container();
    // }
    else if(_navBarHelp.selectedIndex  == 1) {
      return OurProfile();
    }
    else {
      return Container();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);


    BottomNavBarHelper _navBarHelp =
    Provider.of<BottomNavBarHelper>(context, listen: false);

    print(_instance.postIds.length);
    print("Rebuilding the home spage");
    context.select<BottomNavBarHelper, int>((value) => value.selectedIndex);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: MyColors.backgroundColor,
      //   elevation: 0,
      //   // leading: IconButton(
      //   //     icon: Icon(
      //   //       Icons.arrow_back,
      //   //       color: MyColors.yellowish,
      //   //     ),
      //   //     onPressed: () => Navigator.pop(context)),
      //   title: Text(
      //     'Feed',
      //     style: MyTextStyle.text3,
      //   ),
      // ),
        bottomNavigationBar: CustomBottomNavigationBar(
          iconList: const [
            "assets/images/icons/homeIcon.png",
         //   "assets/images/icons/chatIcon.png",
            "assets/images/icons/profile.png",
          ],
          onChange: (val) {
            // setState(() {
            //   _selectedIndex = val;
            // });
          },
          textList: const [
            "Home",
           // "Chats",
            "Profile",
          ],
        ),
        body: returnCurrentScreen()
    );
  }
}
