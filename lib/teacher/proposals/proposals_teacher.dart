import 'package:flutter/material.dart';

import '../../utils/our_colours.dart';
import 'activePosts.dart';
import 'archivedPosts.dart';
import 'historyPosts/post_history_page.dart';

class ProposalsMain extends StatefulWidget {
  const ProposalsMain({Key? key}) : super(key: key);

  @override
  _ProposalsMainState createState() => _ProposalsMainState();
}

class _ProposalsMainState extends State<ProposalsMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.appThemeBlue,
        elevation: 0,
        // leading: IconButton(
        //     icon: Icon(
        //       Icons.arrow_back,
        //       color: MyColors.yellowish,
        //     ),
        //     onPressed: () => Navigator.pop(context)),


      ),

      body: ArchivedPosts(),
    );
  }
}
