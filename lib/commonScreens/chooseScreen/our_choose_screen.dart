import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

import '../../provider/currentState.dart';
import '../../splashScreen.dart';
import '../../student/homeScreen/our_home_page.dart';
import '../../utils/our_colours.dart';
import '../../utils/our_text_styles.dart';
import '../localWidgets/screenDisableCode.dart';

class OurChooseScreen extends StatefulWidget {
  const OurChooseScreen({Key? key}) : super(key: key);

  @override
  _OurChooseScreenState createState() => _OurChooseScreenState();
}

class _OurChooseScreenState extends State<OurChooseScreen> {
  bool selected1 = false;
  bool selected2 = false;
  TextEditingController interests = TextEditingController();

  int color = 2;

  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: ScreenLoader(
          child: Container(
            child: Column(
              children: [
                Spacer(flex: 1),
                Text(
                  "Choose",
                  style: MyTextStyle.titleLSBlack,
                ),
                Spacer(flex: 1),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selected1 = !selected1;
                      if (selected1 == true) {
                        selected2 = false;
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: _instance.size.height / 16,
                    width: _instance.size.width,
                    decoration: BoxDecoration(
                      color:
                      selected1 == true ? MyColors.appThemeRed : Colors.white,
                      border: Border.all(width: 1.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Want to Donate",
                              style: selected1 == true
                                  ? MyTextStyle.buttontext1
                                  : MyTextStyle.buttontext2,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selected2 = !selected2;
                      if (selected2 == true) {
                        selected1 = false;
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: _instance.size.height / 16,
                    width: _instance.size.width,
                    decoration: BoxDecoration(
                      color:
                      selected2 == true ? MyColors.appThemeRed : Colors.white,
                      border: Border.all(width: 1.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Seeking Donation",
                              style: selected2 == true
                                  ? MyTextStyle.buttontext1
                                  : MyTextStyle.buttontext2,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                          ],
                        )),
                  ),
                ),
                selected2 == true
                    ? Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    controller: interests,
                    decoration: const InputDecoration(
                      hintText: "NGO",
                      // prefixIcon: Icon(
                      //   Icons.email_outlined,
                      //   color: MyColors.blue_ribbon,
                      // ),
                      labelText: 'NGO website (in future KYC verification can be done)',
                      labelStyle: MyTextStyle.text1,
                    ),
                    style: MyTextStyle.text2,
                    validator: (value) {},
                    onChanged: (text) {
                      // do something with text
                    },
                  ),
                )
                    : Container(),
                const Spacer(
                  flex: 2,
                ),
                GestureDetector(
                  onTap: () async{
                    if (selected1) {
                      String ret = await _instance.updateUserData(customerType: true,);

                      if(ret == "success") {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurSplashScreen()), (route) => false);
                      }
                    }
                    else if (selected2 == true) {
                      if (interests.text.isNotEmpty) {
                        // call to the database to save the customer type and the interests
                        String ret = await _instance.updateUserData(customerType:false,interests: interests.text);
                        if(ret == "success") {

                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurSplashScreen()), (route) => false);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please enter your Ngo Website",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    }

                    else {
                      Fluttertoast.showToast(
                          msg: "Please select one of the above",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: Container(
                    height: _instance.size.height / 16,
                    width: _instance.size.width,
                    decoration: BoxDecoration(
                        color: selected1 || selected2 == true
                            ? MyColors.appThemeBlue
                            : MyColors.appThemeBlue.withOpacity(0.2),
                        border: Border.all(width: 1.5, color: Colors.black)),
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Next",
                              style: selected1 || selected2 == true
                                  ? MyTextStyle.buttontext1
                                  : MyTextStyle.buttontext2,
                            ),
                            // SizedBox(
                            //   width: 3,
                            // ),
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),

        ),
      ),
    );
  }
}
