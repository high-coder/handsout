import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handsout/teacher/postDetailsScreen/our_post_details.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
    data = _instance.fetchAppliedPosts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
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
                                  _instance.postInstance = _instance.postIds[index];
                                //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetails()),);
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 25,
                                      right: 15,
                                      child: Container(
                                        width: 130,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Center(child: Text("₹ ${_instance.activePosts[index].donatedAmountByUser.toString()} Donated",style: GoogleFonts.openSans(color: Colors.white,fontSize: 15))),
                                      ),
                                    ),
                                    Container(
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
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                            //mainAxisAlignment: ,
                                            children: [
                                              CircleAvatar(radius: 30,),
                                              SizedBox(width: 19,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(_instance.currentUser.name ?? "",style: GoogleFonts.openSans(color: Colors.white,fontSize: 15),),
                                                  Text(
                                                    _instance.postIds[index].title,
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 17,
                                                        color: MyColors.appThemeBlueText,
                                                        fontWeight: FontWeight.w700),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          //title of the post

                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            height: _instance.size.height/2,
                                            width: _instance.size.width,
                                            child: CachedNetworkImage(
                                              imageUrl: _instance.postIds[index].downloadLink ?? "",fit: BoxFit.fitWidth,
                                            ),
                                          ),

                                          Flexible(
                                            child: Text("Ends on ${_instance.postIds[index].deadLine.day} /${_instance.postIds[index].deadLine.month} /${_instance.postIds[index].deadLine.year}",
                                              style: GoogleFonts.openSans(fontStyle: FontStyle.italic,color: Colors.white),),
                                          ),

                                          Flexible(
                                            child: Text("₹ ${_instance.postIds[index].donatedTillNow} Raised",
                                              style: GoogleFonts.openSans(fontStyle: FontStyle.italic,color: Colors.red),),
                                          ),

                                          Builder(
                                            builder: (context) {
                                              double  valueToShow = 0;
                                              valueToShow = _instance.postIds[index].donatedTillNow / _instance.postIds[index].totalDonationNeeded;
                                              if(valueToShow >1) {
                                                valueToShow = 1;
                                              } else if(valueToShow <0) {
                                                valueToShow = 0;
                                              }


                                              return LinearPercentIndicator(
                                                width: MediaQuery.of(context).size.width - 50,
                                                animation: true,
                                                lineHeight: 20.0,
                                                animationDuration: 2000,
                                                percent: valueToShow,
                                                //center: Text("90.0%"),
                                                linearStrokeCap: LinearStrokeCap.roundAll,
                                                progressColor: Colors.greenAccent,
                                              );
                                            },
                                          ),


                                          Flexible(
                                            child: Text("Goal ₹ ${_instance.postIds[index].totalDonationNeeded}",
                                              style: GoogleFonts.openSans(fontStyle: FontStyle.italic,color: Colors.white),),
                                          ),
                                          Flexible(
                                            child: Text(
                                              _instance.postIds[index].description,
                                              maxLines: 2,
                                            ),
                                          ),
                                          SizedBox(height: 10,),

                                          Flexible(
                                              child: Text(
                                                "Tags : ${_instance.postIds[index].hashTags}",
                                                style: GoogleFonts.openSans(color: Colors.white,fontWeight: FontWeight.w500),
                                                maxLines: 1,
                                              )),


                                        ],
                                      ),
                                    ),
                                  ],
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
