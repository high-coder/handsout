import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handsout/teacher/postDetailsScreen/our_post_details.dart';
import 'package:provider/provider.dart';

import '../../commonScreens/shimmerCode.dart';
import '../../provider/currentState.dart';
import '../../utils/our_colours.dart';
import '../../utils/our_text_styles.dart';

class ArchivedPosts extends StatefulWidget {
  const ArchivedPosts({Key? key}) : super(key: key);

  @override
  _ArchivedPostsState createState() => _ArchivedPostsState();
}

class _ArchivedPostsState extends State<ArchivedPosts> {


  late Future data;

  @override
  void initState() {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
    data = _instance.fetchAppliedPosts("archive");

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
                      if (_instance.archivePosts.isNotEmpty) {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _instance.archivePosts.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  _instance.postInstance = _instance.archivePosts[index];
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetails()),);
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
                                                  _instance.archivePosts[index].title,
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
                                              child: Text("Deadline ${_instance.archivePosts[index].deadLine.day} /${_instance.archivePosts[index].deadLine.month} /${_instance.archivePosts[index].deadLine.year}",
                                                style: GoogleFonts.openSans(fontStyle: FontStyle.italic),),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),

                                            Flexible(
                                              child: Text(
                                                _instance.archivePosts[index].description,
                                                maxLines: 7,
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Flexible(
                                                child: Text(
                                                  "Tags : ${_instance.archivePosts[index]
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
