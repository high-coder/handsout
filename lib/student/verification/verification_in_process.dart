import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handsout/student/verification/verification_failed.dart';

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';


import '../../commonScreens/chooseScreen/our_choose_screen.dart';
import '../../commonScreens/loginScreen/our_login_screen.dart';
import '../../provider/currentState.dart';

import '../../utils/our_text_styles.dart';
import '../our_home_page_main_user.dart';


class VerificationInProcess extends StatefulWidget {
  const VerificationInProcess({Key? key}) : super(key: key);

  @override
  _VerificationInProcessState createState() => _VerificationInProcessState();
}

class _VerificationInProcessState extends State<VerificationInProcess> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  GlobalKey<LiquidPullToRefreshState>();
  Future<void> _handleRefresh() async{
    CurrentState _instance = Provider.of<CurrentState>(context,listen:false);
   await  initialCalls();
    print("sjhiasdfhnoishdfiubdsf");
    // final Completer<void> completer = Completer<void>();
    // Timer(const Duration(seconds: 3), () {
    //   completer.complete();
    // });
    // setState(() {
    //   refreshNum = Random().nextInt(100);
    // });
    // return completer.future.then<void>((_) {
    //   ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
    //     SnackBar(
    //       content: const Text('Refresh complete'),
    //       action: SnackBarAction(
    //         label: 'RETRY',
    //         onPressed: () {
    //           _refreshIndicatorKey.currentState!.show();
    //         },
    //       ),
    //     ),
    //   );
    // });
    return Future.delayed(Duration(milliseconds: 100));
  }
  initialCalls() async {
    CurrentState _instance = Provider.of<CurrentState>(context,listen:false);
    String where = await _instance.onStartUp();

    print(where);

    if(where == "signup") {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurLoginPage()), (route) => false);
    } else if(where == "type") {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurChooseScreen()), (route) => false);
    } else if(where == "apply") {
      //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => VerificationInProcess()), (route) => false);
    } else if(where == "failed") {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => VerificationFailedPage()), (route) => false);
    } else if(where == "student") {
      //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurHomeTeacher()), (route) => false);

    } else if(where == "teacher") {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurHomePageMainUser()), (route) => false);

    } else if(where == "admin") {
      //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurHomeAdmin()), (route) => false);
    }
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => OurChooseScreen()));
  }


  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context,listen:false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF272727),
        title: Text(
          "Verification",
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 15.0, top: 10),
        //     child: GestureDetector(
        //       onTap: (){
        //         Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
        //       },
        //       child: Icon(
        //         Icons.notifications,
        //         color: ThemeProvider.themeOf(context).id == "light_theme"
        //             ? weBlueColor
        //             : Colors.white,
        //         size: 30,
        //       ),
        //     ),
        //   )
        // ],
      ),

      body: LiquidPullToRefresh(
        height: 100,
        backgroundColor: Colors.red,
        showChildOpacityTransition: false,
        onRefresh: _handleRefresh,
        key: _refreshIndicatorKey,
        color: Color(0xFF272727),
        child: Padding(
          padding: const EdgeInsets.only(left:28.0),
          child: ListView(
            children: [
              Container(
                height: size.height - 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Verification \n Process", style: MyTextStyle.heading4,),
                    SizedBox(height: 10,),
                    Container(
                      width: 69,
                      color: Colors.black.withOpacity(0.4),
                      height: 2,
                    ),

                    SizedBox(height: 30,),
                    Row(
                      children: [
                        Icon(Icons.lock_clock_outlined),
                        SizedBox(width: 6,),
                        Text("sit and hold tight",style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),),
                      ],
                    ),
                    SizedBox(height: 10,),

                    Text("Check back regular for updates",style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
