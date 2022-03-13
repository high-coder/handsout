import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:handsout/provider/bottom_navbar.dart';
import 'package:handsout/provider/currentState.dart';
import 'package:handsout/splashScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';

//import 'package:howdy_works/student/signupScreen/our_signup_screen.dart';
import 'package:provider/provider.dart';


import 'commonScreens/loginScreen/our_login_screen.dart';
import 'models/ourUser.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(OurUserDetailOriginal());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentState()),
        ChangeNotifierProvider(create: (context) => BottomNavBarHelper()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: ''
              'Hands Out',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: OurSplashScreen()
        //home: AdminHomePage(),
      ),
    );
  }
}

