import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../commonScreens/loginScreen/our_login_screen.dart';
import '../../provider/currentState.dart';
import '../../utils/our_text_styles.dart';
import '../proposals/historyPosts/post_history_page.dart';

class OurProfile extends StatefulWidget {
  const OurProfile({Key? key}) : super(key: key);

  @override
  _OurProfileState createState() => _OurProfileState();
}

class _OurProfileState extends State<OurProfile> {
  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context,listen:false);
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  "View Previously applied",
                  style:MyTextStyle.listTileFont,

                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SubmittedHistory()));
                },
              ),
            ),

            Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  "Logout",
                  style:MyTextStyle.listTileFont,

                ),
                onTap: () async{

                  await _instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OurLoginPage()), (route) => false);

                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
