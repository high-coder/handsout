import 'package:flutter/material.dart';
import 'package:handsout/provider/currentState.dart';
import 'package:handsout/student/our_home_page_main_user.dart';
import 'package:handsout/student/verification/verification_failed.dart';
import 'package:handsout/student/verification/verification_in_process.dart';


import 'package:provider/provider.dart';


import 'commonScreens/chooseScreen/our_choose_screen.dart';
import 'commonScreens/loginScreen/our_login_screen.dart';
import 'commonScreens/signupScreen/our_signup_screen.dart';


class OurSplashScreen extends StatefulWidget {
  const OurSplashScreen({Key? key}) : super(key: key);

  @override
  _OurSplashScreenState createState() => _OurSplashScreenState();
}

class _OurSplashScreenState extends State<OurSplashScreen> {

  @override
  void initState() {
    initialCalls();
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
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => VerificationInProcess()), (route) => false);
    } else if(where == "failed") {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => VerificationFailedPage()), (route) => false);
    }

    else if(where == "student") {
      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => OurHomePage()));
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurHomePageMainUser()), (route) => false);
    } else if(where == "teacher") {
      //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurHomeTeacher()), (route) => false);
    } else if(where == "admin") {
     // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurHomeAdmin()), (route) => false);
    }
   // Navigator.of(context).push(MaterialPageRoute(builder: (context) => OurChooseScreen()));
  }


  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context,listen:false);
    _instance.size = MediaQuery.of(context).size;
    return Container();
  }
}
