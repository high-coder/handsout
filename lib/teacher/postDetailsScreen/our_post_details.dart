import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../commonScreens/chatScreen/our_chat_screen.dart';
import '../../commonScreens/localWidgets/our_button.dart';
import '../../commonScreens/localWidgets/screenDisableCode.dart';
import '../../provider/currentState.dart';
import '../../utils/our_colours.dart';
import '../../utils/our_text_styles.dart';

class PostDetails extends StatefulWidget {

  String ?approved;
  PostDetails({Key? key, this.approved}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetch the relevant chat according to this post of the user and then on click open the chat room
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
    _instance.getChatRoomIds();
  }


  @override
  Widget build(BuildContext context) {
    print("The whole page is rebuilding ");
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
    return Scaffold(
      backgroundColor: MyColors.lightWightPBG,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          _instance.postInstance?.title ?? " ",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: MyTextStyle.headingPostPage,
        ),
        actions:  [
          widget.approved=="approved" ?  IconButton(onPressed: () {

            //_instance.createOrCheckChat(_instance.interestedUser[index].uid ?? "");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen(
                          allowChat: true,)));
          }, icon: Icon(Icons.chat,color: Colors.black,)) : Container()
        ],

        // actions: [
        //   IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.black,),onPressed: () {
        //     Navigator.of(context).pop();
        //   },)
        // ],
      ),
      body: ScreenLoader(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: _instance.size.width,
                height: _instance.size.height / 7,
                color: MyColors.appThemeBlue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, top: 15),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "dfmd;",
                        style: GoogleFonts.openSans(
                            color: MyColors.appThemeBlueText,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(flex: 1),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        "Details",
                        style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                    Container(
                      //margin: EdgeInsets.only(left: 15),
                      width: 90,
                      height: 2,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                width: _instance.size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        _instance.postInstance?.title ?? "",
                        style: MyTextStyle.headingPostPage,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.2),
                      width: _instance.size.width,
                      height: 1.5,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Deadline ${_instance.postInstance?.deadLine.day} /${_instance.postInstance?.deadLine.month} /${_instance.postInstance?.deadLine.year}",
                            style: GoogleFonts.openSans(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            _instance.postInstance?.description ?? " ",
                            style: GoogleFonts.openSans(
                                fontSize: 15, color: Colors.black),
                            //maxLines: 7,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Tags : ${_instance.postInstance?.hashTags}",
                            style: GoogleFonts.openSans(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              _instance.postInstance?.downloadLink != null
                  ? GestureDetector(
                      onTap: () async {
                        if (!await launch(
                            _instance.postInstance?.downloadLink ?? ""))
                          throw 'Could not launch';
                      },
                      child: Container(child: Text("View Detailed File")),
                    )
                  : Container(),
              Consumer<CurrentState>(
                builder: (context, _, __) {
                  return GestureDetector(
                      onTap: () async {

                      },
                      child: Button(
                        text: "sf;sfd", color: 1,
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
