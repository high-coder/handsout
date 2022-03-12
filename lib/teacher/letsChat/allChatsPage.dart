import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../commonScreens/chatScreen/our_chat_screen.dart';
import '../../commonScreens/shimmerCode.dart';
import '../../provider/currentState.dart';
import '../../utils/our_colours.dart';
import '../../utils/our_text_styles.dart';

class AllChatsFetch extends StatefulWidget {
  String collection;

  AllChatsFetch({Key? key, required this.collection}) : super(key: key);

  @override
  _AllChatsFetchState createState() => _AllChatsFetchState();
}

class _AllChatsFetchState extends State<AllChatsFetch> {
  late Future data2;

  @override
  void initState() {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
    data2 = _instance.getChatRooms(widget.collection);
  }

  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);

    print(_instance.userChats.length);
    print(_instance.adminChatsTile.length);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<CurrentState>(
            builder: (context, _, __) {
              return FutureBuilder(
                future: data2,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text("loading.....");
                    case ConnectionState.waiting:
                      return ShimmerForCategories(
                          _instance.size.height / 5.2, _instance.size.width - 20);
                    case ConnectionState.done:
                      if (_instance.chatIds.isNotEmpty) {
                        return _instance.currentUser.uid == "thisisthat"
                            ? Column(
                                children: [
                                  Text("Ongoing convos"),

                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _instance.adminChatsTile.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            //_instance.postInstance = _instance.interestedPosts[index];
                                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetails()),);
                                            //print(_instance.postInstance.uid);
                                            _instance.chatDoc = _instance
                                                .adminChatsTile[index].chatUid;
                                            //_instance.createOrCheckChat(_instance.interestedUser[index].uid ?? "");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatScreen(
                                                            allowChat: true,)));
                                            // open the chat page here if the chat does not exist then create one
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 15,
                                                left: 10,
                                                right: 10,
                                                top: 15),
                                            decoration: BoxDecoration(
                                                border: Border.symmetric(
                                                    horizontal: BorderSide(
                                                        color: Colors.black
                                                            .withOpacity(0.15),
                                                        width: 1))),
                                            margin: EdgeInsets.only(
                                              bottom: 20,
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 30,
                                                ),
                                                Spacer(flex: 1),
                                                Expanded(
                                                  flex: 15,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      //title of the post
                                                      Flexible(
                                                          child: Text(
                                                        _instance
                                                            .adminChatsTile[index]
                                                            .chatterName,
                                                        style: GoogleFonts.openSans(
                                                            fontSize: 17,
                                                            color: MyColors
                                                                .appThemeBlueText,
                                                            fontWeight:
                                                                FontWeight.w700),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                      )),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      // Container(
                                                      //   width: 400,height: 2,
                                                      //   color: Colors.black,
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(flex: 1),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                  Text("User Chats for Monitoring"),
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _instance.userChats.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            //_instance.postInstance = _instance.interestedPosts[index];
                                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetails()),);
                                            //print(_instance.postInstance.uid);
                                            _instance.chatDoc = _instance
                                                .userChats[index].chatUid;
                                            //_instance.createOrCheckChat(_instance.interestedUser[index].uid ?? "");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatScreen(
                                                            allowChat: false)));
                                            // open the chat page here if the chat does not exist then create one
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 15,
                                                left: 10,
                                                right: 10,
                                                top: 15),
                                            decoration: BoxDecoration(
                                                border: Border.symmetric(
                                                    horizontal: BorderSide(
                                                        color: Colors.black
                                                            .withOpacity(0.15),
                                                        width: 1))),
                                            margin: EdgeInsets.only(
                                              bottom: 20,
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 30,
                                                ),
                                                Spacer(flex: 1),
                                                Expanded(
                                                  flex: 15,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      //title of the post
                                                      Flexible(
                                                          child: Text(
                                                        _instance.userChats[index]
                                                            .chatterName,
                                                        style: GoogleFonts.openSans(
                                                            fontSize: 17,
                                                            color: MyColors
                                                                .appThemeBlueText,
                                                            fontWeight:
                                                                FontWeight.w700),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                      )),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      // Container(
                                                      //   width: 400,height: 2,
                                                      //   color: Colors.black,
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(flex: 1),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _instance.chatIds.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      //_instance.postInstance = _instance.interestedPosts[index];
                                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetails()),);
                                      //print(_instance.postInstance.uid);
                                      _instance.chatDoc =
                                          _instance.chatIds[index].chatUid;
                                      //_instance.createOrCheckChat(_instance.interestedUser[index].uid ?? "");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatScreen(allowChat: true,)));
                                      // open the chat page here if the chat does not exist then create one
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 15,
                                          left: 10,
                                          right: 10,
                                          top: 15),
                                      decoration: BoxDecoration(
                                          border: Border.symmetric(
                                              horizontal: BorderSide(
                                                  color: Colors.black
                                                      .withOpacity(0.15),
                                                  width: 1))),
                                      margin: EdgeInsets.only(
                                        bottom: 20,
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                          ),
                                          Spacer(flex: 1),
                                          Expanded(
                                            flex: 15,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                //title of the post
                                                Flexible(
                                                    child: Text(
                                                  _instance.chatIds[index]
                                                      .chatterName,
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 17,
                                                      color: MyColors
                                                          .appThemeBlueText,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                )),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                // Container(
                                                //   width: 400,height: 2,
                                                //   color: Colors.black,
                                                // ),
                                              ],
                                            ),
                                          ),
                                          Spacer(flex: 1),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                      } else {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "No Data Found",
                            style: MyTextStyle.referEarnText,
                          ),
                        ));
                      }
                      break;
                    default:
                      return Text("Some error occured");
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
