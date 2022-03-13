import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handsout/commonScreens/localWidgets/screenDisableCode.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:provider/provider.dart';

import '../../provider/currentState.dart';
import '../../utils/our_colours.dart';
import '../../utils/our_text_styles.dart';
import '../postDetailsScreen/our_post_details.dart';

class HomeModule extends StatefulWidget {
  const HomeModule({Key? key}) : super(key: key);

  @override
  _HomeModuleState createState() => _HomeModuleState();
}

class _HomeModuleState extends State<HomeModule> {


  TextEditingController _donationAmount = TextEditingController();
  @override
  void initState() {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
    _instance.fetchPost().listen((event) {
      print(event);
    });
    _instance.initCodePayment();
    super.initState();
  }

  Widget alert(BuildContext context) {
    return SimpleDialog(
      title:const Text('Enter the Amount'),
      children: <Widget>[
        SimpleDialogOption(
            onPressed: () { },
            child:TextFormField(

            )

        ),
        SimpleDialogOption(
          onPressed: () { },
          child:Container(
            child: Text("Send"),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);

    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor:Colors.black,
          elevation: 0,
          // leading: IconButton(
          //     icon: Icon(
          //       Icons.arrow_back,
          //       color: MyColors.yellowish,
          //     ),
          //     onPressed: () => Navigator.pop(context)),
          title: Text(
            'Feed', style: GoogleFonts.openSans(color: Colors.white,fontSize: 15)
          ),
        ),
        body: ScreenLoader(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(
                //left: 20.0,
                //right: 20.0,
                bottom: 20.0,
              ),
              child: Consumer<CurrentState>(
                builder: (context, _, __) {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _instance.postIds.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _instance.postInstance = _instance.postIds[index];
                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetails()),);
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
                                        Container(
                                          width: 260,
                                          child: Text(
                                            _instance.postIds[index].title,
                                            style: GoogleFonts.openSans(
                                                fontSize: 17,
                                                color: MyColors.appThemeBlueText,
                                                fontWeight: FontWeight.w700),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
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

                                GestureDetector(
                                  onTap: () {
                                    _instance.selectedRightNow = _instance.postIds[index];
                                    showDialog(context: context, builder: (BuildContext context){
                                      return SimpleDialog(
                                        title:const Text('Enter the Amount'),
                                        children: <Widget>[
                                          SimpleDialogOption(
                                              onPressed: () { },
                                              child:TextFormField(
                                                controller: _donationAmount,

                                              )

                                          ),
                                          SimpleDialogOption(
                                            onPressed: () async{
                                              print(_donationAmount.text);
                                              _instance.openCheckout(int.parse(_donationAmount.text), context);
                                              Navigator.pop(context);
                                            },
                                            child:Container(
                                              child: Text("Send"),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(child: Text("Donate",style: GoogleFonts.openSans(color: Colors.white,fontSize: 15))),
                                  ),
                                ),
                                Flexible(
                                    child: Text(
                                      "Tags : ${_instance.postIds[index].hashTags}",
                                      style: GoogleFonts.openSans(color: Colors.white,fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                    )),


                              ],
                            ),
                          ),
                        );
                      });
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
        ),
      ),
    );
  }
}
