
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

import '../../provider/currentState.dart';
import '../../splashScreen.dart';
import '../../utils/our_colours.dart';
import '../../utils/our_text_styles.dart';
import '../localWidgets/our_button.dart';
import '../signupScreen/our_signup_screen.dart';


class OurLoginPage extends StatefulWidget {
  const OurLoginPage({Key? key}) : super(key: key);

  @override
  _OurLoginPageState createState() => _OurLoginPageState();
}

class _OurLoginPageState extends State<OurLoginPage> {
  final _formKeyLogin = GlobalKey<FormState>();
  var isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> _LoginUser() async {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
    final isvalid = _formKeyLogin.currentState?.validate();
    final _auth = FirebaseAuth.instance;
    late String retVal = "";
    _formKeyLogin.currentState?.save();
    if (isvalid ?? false) {
      try {
        setState(() {
          isLoading = true;
        });
        // String retVal = await _instance.loginUserWithEmail(
        //     email.text.trim(), pass.text.trim());
        // UserCredential _authResult = await _auth.signInWithEmailAndPassword(email: email.text.trim(), password: pass.text.trim());

        retVal =await _instance.loginUser(email.text, pass.text);
        if (retVal == "success") {
          retVal = "Login Successful";
          // Navigate the user to the page
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => HomeScreen()),
          //         (route) => false);

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurSplashScreen()), (route) => false);

          Fluttertoast.showToast(
              msg: retVal,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0);
          isLoading = false;
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: retVal,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } catch (e) {
        print(e);
      }
    }
    return "fkdkbfbs";
  }

  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);

    MediaQueryData mediaQueryData = MediaQuery.of(context);

    double width = mediaQueryData.size.width;
    double height = mediaQueryData.size.height;
    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [

                    SizedBox(
                      width: width,
                      height: height / 3.3 > 270 ? 280 : height / 3.3,
                      child: SvgPicture.asset(
                          "assets/images/registration/loginTop.svg",
                          semanticsLabel: 'howdy Works',fit: BoxFit.fill,
                      ),
                    ),

                    Positioned(
                      bottom: height > 700 ? 90 : 60,
                      //right: width > 360 ? 20 : 10,
                      left: width > 360 ? 25 : 15,
                      child: Text('Welcome \n Back',
                          style: MyTextStyle.titleLS),
                    ),
                    // Container(
                    //   width: width,
                    //   height: height / 3.3 > 270 ? 280 : height / 3.3,
                    //   padding: EdgeInsets.only(
                    //     left: width > 360 ? 20 : 10,
                    //   ),
                    //   decoration:const BoxDecoration(
                    //       image: DecorationImage(
                    //           image: AssetImage("assets/images/registration/loginTop2.png"),
                    //           fit: BoxFit.fill)),
                    //   child: Stack(
                    //     children: [
                    //
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height > 360 ? 10 : 5,
                    right: width > 360 ? 20 : 10,
                    left: width > 360 ? 20 : 10,
                  ),
                  child: Form(
                    key: _formKeyLogin,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   height: height / 16,
                        // ),
                        TextFormField(
                          controller: email,
                          decoration:const InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: MyColors.blue_ribbon,
                            ),
                            labelText: 'Email address',
                            labelStyle: MyTextStyle.text1,
                          ),
                          style: MyTextStyle.text2,
                          validator: (value) {
                            print(value);
                            if (value?.isNotEmpty ?? false) {
                              if (EmailValidator.validate(email.text)) {
                              } else {
                                return "Enter a valid email";
                              }
                            } else {
                              return "Please enter a email";
                            }
                          },
                          onChanged: (text) {
                            // do something with text
                          },
                        ),
                        SizedBox(
                          height: height / 40,
                        ),
                        TextFormField(
                          controller: pass,
                          decoration:const InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: MyColors.blue_ribbon,
                            ),
                            labelText: 'Password',
                            labelStyle: MyTextStyle.text1,
                          ),
                          style: MyTextStyle.text2,
                          validator: (value) {
                            if (value != null) {
                              if (value.length < 8) {
                                return "Please enter a valid password";
                              }
                            } else {
                              return "Please enter a password";
                            }
                          },
                          obscureText: true,
                          onChanged: (text) {
                            // do something with text
                          },
                        ),
                        SizedBox(
                          height: height / 70,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/forgotPage');
                          },
                          child:const Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "Forgot password?",
                              style: MyTextStyle.text1,
                            ),
                          ),
                        ),
                        !isLoading
                            ? GestureDetector(
                          onTap: () {
                            FocusScope.of(context)
                                .unfocus(); //closes keyboard
                            _LoginUser();
                          },
                          child: Button(
                            text: "Log In",
                            color: 1,
                          ),
                        )
                            : const Center(child: CircularProgressIndicator()),
                        SizedBox(
                          height: height /
                              40, // Use the same height after 'Or text'
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Expanded(
                              child: Divider(
                                color: MyColors.divider_color,
                                thickness: 2.0,
                                endIndent: 11.0,
                              ),
                            ),
                            Text(
                              'OR',
                              style: MyTextStyle.heading2,
                            ),
                            Expanded(
                              child: Divider(
                                color: MyColors.divider_color,
                                thickness: 2.0,
                                indent: 14.0,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            // take the user to the login page
                            //Navigator.of(context, MaterialPageBuilder())
                            //Navigator.of(context).pushNamed('/singupPage');
                            String retVal =
                            await _instance.loginUserWithGoogle();
                            if (retVal == "success") {

                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurSplashScreen()), (route) => false);


                              Fluttertoast.showToast(
                                  msg: retVal,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              // Navigator.pushAndRemoveUntil(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => HomeScreen()),
                              //         (route) => false);
                            } else {
                              Fluttertoast.showToast(
                                  msg: retVal,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Button(
                            text: "Continue with google",
                            color: 2,
                            iconPath: 'assets/images/icons/Google.png',
                          ),
                        ),
                        //SizedBox(height: height / 7),

                        GestureDetector(
                          onTap: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) =>
                                  SignupScreen())),
                          child: Button(
                            text: "Create a account",
                            color: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
