import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../commonScreens/shimmerCode.dart';
import '../../provider/currentState.dart';
import '../../utils/our_colours.dart';
import '../../utils/our_text_styles.dart';
import '../postDetailsScreen/our_post_details.dart';

class ActivePosts extends StatefulWidget {
  const ActivePosts({Key? key}) : super(key: key);

  @override
  _ActivePostsState createState() => _ActivePostsState();
}

class _ActivePostsState extends State<ActivePosts> {


  late Future data;

  @override
  void initState() {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
    data = _instance.fetchAppliedPosts("active");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: MyColors.backgroundColor,
      //   elevation: 0,
      //   leading: IconButton(
      //       icon: Icon(
      //         Icons.arrow_back,
      //         color: MyColors.yellowish,
      //       ),
      //       onPressed: () => Navigator.pop(context)),
      //   title: Text(
      //     'History',
      //     style: MyTextStyle.text3,
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            //left: 20.0,
            //right: 20.0,
            bottom: 20.0,
          ),
          child: Consumer<CurrentState>(
            builder: (context, _, __) {
              return FutureBuilder(
                future:data,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text("loading.....");
                    case ConnectionState.waiting:
                      return ShimmerForCategories(
                          _instance.size.height / 5.2, _instance.size.width - 20);
                    case ConnectionState.done:
                      if (_instance.activePosts.isNotEmpty) {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _instance.activePosts.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  _instance.postInstance = _instance.activePosts[index];
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetails(approved: "approved",)),);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: 15, left: 10, right: 10, top: 15),
                                  decoration: BoxDecoration(
                                      border: Border.symmetric(
                                          horizontal: BorderSide(
                                              color: Colors.black.withOpacity(0.15),
                                              width: 1))),
                                  margin: EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  child: Row(
                                    children: [
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
                                                  _instance.activePosts[index].title,
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 17,
                                                      color: MyColors.appThemeBlueText,
                                                      fontWeight: FontWeight.w700),
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


                                            Flexible(
                                              child: Text("Deadline ${_instance.activePosts[index].deadLine.day} /${_instance.activePosts[index].deadLine.month} /${_instance.activePosts[index].deadLine.year}",
                                                style: GoogleFonts.openSans(fontStyle: FontStyle.italic),),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),

                                            Flexible(
                                              child: Text(
                                                _instance.activePosts[index].description,
                                                maxLines: 7,
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Flexible(
                                                child: Text(
                                                  "Tags : ${_instance.activePosts[index]
                                                      .hashTags}",
                                                  style: GoogleFonts.openSans(color: Colors.black,fontWeight: FontWeight.w500),
                                                  maxLines: 1,
                                                )),



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
          // child: StreamBuilder(
          //   stream: _instance.fetchPost(),
          //   builder: (context, AsyncSnapshot snapShot) {
          //     return ListView.builder(
          //       shrinkWrap: true,
          //         itemCount: _instance.postIds.length,
          //         itemBuilder: (context, index) {
          //       return Container(
          //         child: Text(_instance.postIds[index].title),
          //       );
          //     });
          //   },
          // ),
        ),
      ),
    );
  }
}
