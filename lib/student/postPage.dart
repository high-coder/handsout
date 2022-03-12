import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handsout/commonScreens/localWidgets/screenDisableCode.dart';
import 'package:provider/provider.dart';
import '../models/postModel.dart';
import '../provider/currentState.dart';
import '../utils/our_colours.dart';
import '../utils/our_text_styles.dart';



// Global model state, should be removed soon

class AddPost extends StatefulWidget {
   AddPost({Key? key, this.drawerKey}) : super(key: key);


   final GlobalKey<ScaffoldState>? drawerKey;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
   DateTime selectedDate = DateTime.now();

   var d = 0;

   var m = 0;

   var y = 0;

   var loading = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _description = TextEditingController();

  TextEditingController _hashtags = TextEditingController();
   final _formKey2 = GlobalKey<FormState>();

   void _formSubmit(BuildContext ctx) async {
     CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
     print('enter');

     bool isValid = _formKey2.currentState?.validate() ?? false;

     _formKey2.currentState?.save();
     FocusScope.of(ctx).unfocus(); //closes keyboard

     try {
       if (isValid && d!= 0) {
         PostModel post = PostModel(
           totalDonationNeeded: double.parse(_priceController.text),
             postTime: DateTime.now(),
             description: _description.text,
             title: _titleController.text,
             file: _instance.image,
             deadLine: selectedDate,
           donatedTillNow: 0,
           hashTags: _hashtags.text, posterUid: _instance.currentUser.uid ?? "sample",

         );

          String retVal = await _instance.createPost(post: post);
         //
         if (retVal == "success") {
           // the whole process was successful ready to roll
           loading = false;
           _titleController.clear();
           _description.clear();
           _description.clear();
           _instance.image = null;
           setState(() {
             //showForm = false;
           });
           Fluttertoast.showToast(
               msg: "The post is successfully uploaded",
               toastLength: Toast.LENGTH_SHORT,
               gravity: ToastGravity.BOTTOM,
               timeInSecForIosWeb: 1,
               backgroundColor: Colors.blue,
               textColor: Colors.white,
               fontSize: 16.0);
           //Navigator.of(context).pushNamed('/homescreen');
         }
         else {
           //setState(() {
           loading = false;
           Fluttertoast.showToast(
               msg: retVal,
               toastLength: Toast.LENGTH_SHORT,
               gravity: ToastGravity.BOTTOM,
               timeInSecForIosWeb: 1,
               backgroundColor: Colors.blue,
               textColor: Colors.white,
               fontSize: 16.0);
         }

       } else if(d== 0) {
         Fluttertoast.showToast(
             msg: "Please selected project dealine",
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.blue,
             textColor: Colors.white,
             fontSize: 16.0);
       }
     } catch (error) {
       print(error);
       var mes = "Invalid Credentials";
       setState(() {
         loading = false;
       });
       //add a snackbar here
     }
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

         _dateController.text = "$d - $m $y";
       });
   }

  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context,listen:false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.9,
        centerTitle: true,
        title: Text(
          "Add your Cause",
          style: Theme.of(context).textTheme.headline6!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          color: Theme.of(context).iconTheme.color,
          icon: const Icon(Icons.menu),
          onPressed: () => widget.drawerKey!.currentState!.openDrawer(),
        ),
        actions: [
          IconButton(
            onPressed: ()  {
              print("Calling the form submit function ");
              _formSubmit(context);
            },
            icon: Icon(Icons.send,color: Colors.white,),
          ),
        ],
      ),
      body: Scaffold(
        body: ScreenLoader(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey2,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const CircleAvatar(radius: 25),
                    title: Row(
                      children: [
                        //Expanded(flex:4,child: Text(_instance.currentUser.name?? "")),
                        Expanded(
                          flex: 8,
                          child: TextFormField(
                            validator: (value) {
                              print("sdfbdsf");
                              if (value?.isNotEmpty ?? false) {
                              } else {
                                return "Please enter Fundraise Title";
                              }
                            },

                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: "FundRaiser Title",
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // subtitle: Text(
                    //   "${_instance.currentUser.name}"
                    // ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex:2,
                        child: IconButton(
                          //onPressed: () => model.getImageFromGallery(),
                          onPressed: () {
                            _instance.pickImageFromGallery();
                          },
                          icon: const Icon(Icons.photo),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          //onPressed: () => model.getImageFromGallery(camera: true),
                          onPressed: () {
                            _instance.pickImageFromCamera();
                          },
                          icon: const Icon(Icons.camera_alt),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: TextFormField(
                          controller: _hashtags,
                          decoration: InputDecoration(
                            labelText: "HashTags",
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                          ),
                        ),
                      ),

                    ],
                  ),
                  const Divider(),
                   Padding(
                    padding:EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      //controller: model.controller,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText:
                          "Explain your cause in a few words",
                      ),
                    ),
                  ),
                  Consumer<CurrentState>(
                    builder: (context,_,__) {
                      return _instance.image != null ?
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: size.height/2.2,
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Image.file(
                              File(_instance.image?.path ?? ""),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                            Positioned(
                              right: 5,
                              top: 5,
                              child: IconButton(
                                //onPressed: () => model.removeImage(),
                                onPressed: () {
                                  _instance.removeImage();
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ) : Container();
                    },
                  ),


                  Row(
                    children: [

                      // price controller
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Goal',
                                style: MyTextStyle.referEarnText,
                              ),
                              TextFormField(
                                //focusNode: _nameFocus,
                                  controller: _priceController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),

                                  ),
                                  validator: (value) {
                                    print(value);
                                    print(value);
                                    print(
                                        "this is being called now $value");
                                    if (value?.isNotEmpty ?? false) {
                                    } else {
                                      return "Target Money not entered";
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Date',
                                style: MyTextStyle.referEarnText,
                              ),
                              TextFormField(
                                onTap: () {
                                  _selectDate(context);
                                },

                                  //enabled: false,
                                //focusNode: _nameFocus,
                                  controller: _dateController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),

                                  ),
                                  validator: (value) {

                                    if (value?.isNotEmpty ?? false) {
                                    } else {
                                      return "Please select a date";
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                      // Expanded(
                      //   flex:1,
                      //   child: Padding(
                      //     padding: EdgeInsets.all(15),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           'End Date',
                      //           style: MyTextStyle.referEarnText,
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.only(top: 7, bottom: 28),
                      //           child: GestureDetector(
                      //             onTap: () {
                      //               _selectDate(context);
                      //             },
                      //             child: Container(
                      //                 padding: EdgeInsets.only(left: 10, right: 10),
                      //                 decoration: BoxDecoration(
                      //                     borderRadius: BorderRadius.circular(10),
                      //                     border:
                      //                     Border.all(width: 2, color: Colors.black38)),
                      //                 height: 50,
                      //                 width: double.infinity,
                      //                 child: Row(
                      //                   mainAxisAlignment: d != 0
                      //                       ? MainAxisAlignment.spaceBetween
                      //                       : MainAxisAlignment.end,
                      //                   children: [
                      //                     if (d != 0) Center(child: Text('$d - $m - $y')),
                      //                     Icon(
                      //                       Icons.calendar_today_rounded,
                      //                       color: MyColors.blue_ribbon,
                      //                     ),
                      //                   ],
                      //                 )),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
                      //: Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
