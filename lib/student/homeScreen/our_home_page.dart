import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../commonScreens/localWidgets/our_button.dart';
import '../../commonScreens/localWidgets/screenDisableCode.dart';
import '../../models/postModel.dart';
import '../../provider/bottom_navbar.dart';
import '../../provider/currentState.dart';
import '../../utils/our_colours.dart';
import '../../utils/our_text_styles.dart';
import '../postPage.dart';

class OurHomePageUser extends StatefulWidget {
  const OurHomePageUser({Key? key}) : super(key: key);

  @override
  _OurHomePageUserState createState() => _OurHomePageUserState();
}

class _OurHomePageUserState extends State<OurHomePageUser> {
  int _selectedIndex = 0;
  final _formKey2 = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _typeOfProject = TextEditingController();
  DateTime selectedDate = DateTime.now();
  var d = 0;
  var m = 0;
  var y = 0;
  //FocusNode _nameFocus;
  var loading = false;

  File? file;

  void _formSubmit(BuildContext ctx) async {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
    print('enter');

    bool isValid = _formKey2.currentState?.validate() ?? false;

    _formKey2.currentState?.save();
    FocusScope.of(ctx).unfocus(); //closes keyboard

    // try {
    //   if (isValid && d!= 0) {
    //     // setState(() {
    //     //loading = true;
    //     //});
    //
    //     PostModel post = PostModel(
    //         postTime: DateTime.now(),
    //         stage: 1,
    //         description: _description.text,
    //         title: _name.text,
    //         uid: _instance.currentUser.uid ?? "",
    //         file: file,
    //       typeOfProject: _typeOfProject.text,
    //       deadLine: selectedDate
    //     );
    //
    //     String retVal = await _instance.createPost(post: post);
    //
    //     if (retVal == "success") {
    //       // the whole process was successful ready to roll
    //       loading = false;
    //       _name.clear();
    //       _description.clear();
    //       _typeOfProject.clear();
    //       file = null;
    //       setState(() {
    //         showForm = false;
    //       });
    //       Fluttertoast.showToast(
    //           msg: "The post is successfully uploaded",
    //           toastLength: Toast.LENGTH_SHORT,
    //           gravity: ToastGravity.BOTTOM,
    //           timeInSecForIosWeb: 1,
    //           backgroundColor: Colors.blue,
    //           textColor: Colors.white,
    //           fontSize: 16.0);
    //       //Navigator.of(context).pushNamed('/homescreen');
    //     }
    //     else {
    //       //setState(() {
    //       loading = false;
    //
    //       //});
    //       // show the snack bar to the user here
    //       // _scaffoldKey2.currentState.showSnackBar(
    //       //   SnackBar(
    //       //       duration: Duration(seconds: 1),
    //       //       content: Text(retVal),
    //       //   ),
    //       // );
    //       Fluttertoast.showToast(
    //           msg: retVal,
    //           toastLength: Toast.LENGTH_SHORT,
    //           gravity: ToastGravity.BOTTOM,
    //           timeInSecForIosWeb: 1,
    //           backgroundColor: Colors.blue,
    //           textColor: Colors.white,
    //           fontSize: 16.0);
    //     }
    //     // await _auth.createUserWithEmailAndPassword(
    //     //     email: email.text.trim(), password: pass.text.trim());
    //     //
    //     // await FirebaseFirestore.instance
    //     //     .collection('users')
    //     //     .doc(_auth.currentUser.uid)
    //     //     .set(
    //     //   {
    //     //     'name': name.text.trim(),
    //     //     'email': email.text.trim(),
    //     //     'user is': isCustomerSelected ? 'Customer' : 'Mechanic',
    //     //   },
    //     // );
    //
    //   } else if(d== 0) {
    //     Fluttertoast.showToast(
    //         msg: "Please selected project dealine",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Colors.blue,
    //         textColor: Colors.white,
    //         fontSize: 16.0);
    //   }
    // } catch (error) {
    //   print(error);
    //   var mes = "Invalid Credentials";
    //   setState(() {
    //     loading = false;
    //   });
    //   //add a snackbar here
    // }
  }


  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        d = selectedDate.day;
        m = selectedDate.month;
        y = selectedDate.year;
      });
  }


  bool showForm = false;

  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);

    BottomNavBarHelper _navBarHelp =
        Provider.of<BottomNavBarHelper>(context, listen: false);

    print("Rebuilding the home spage");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.backgroundColor,
          elevation: 0,
          // leading: IconButton(
          //     icon: Icon(
          //       Icons.arrow_back,
          //       color: MyColors.yellowish,
          //     ),
          //     onPressed: () => Navigator.pop(context)),
          title: Text(
            'Create Assignment',
            style: MyTextStyle.text3,
          ),
        ),
        // bottomNavigationBar: CustomBottomNavigationBar(
        //   iconList: const [
        //     "assets/images/icons/homeIcon.png",
        //     "assets/images/icons/chatIcon.png",
        //     "assets/images/icons/profile.png",
        //   ],
        //   onChange: (val) {
        //     // setState(() {
        //     //   _selectedIndex = val;
        //     // });
        //   },
        //   textList: const [
        //     "Home",
        //     "Chats",
        //     "Profile",
        //   ],
        // ),
        body: SafeArea(
          child: ScreenLoader(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Spacer(flex: 1,),
                   const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPost()));

                          // setState(() {
                          //   showForm = !showForm;
                          // });
                        },
                        child: Container(
                          //margin: EdgeInsets.only(left: 15, right: 15),
                          height: _instance.size.height / 16,
                          width: _instance.size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(width: 1.5, color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Create a Donation Cause",
                                style: MyTextStyle.buttontext2,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                   const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
