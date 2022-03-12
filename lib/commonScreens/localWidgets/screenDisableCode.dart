import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../provider/currentState.dart';

class ScreenLoader extends StatelessWidget {
  Widget child;

  ScreenLoader({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("the screen loader page is rebuilding");
    CurrentState _instance = Provider.of<CurrentState>(context,listen:false);
    return Stack(
      children: [
       child,
        Consumer<CurrentState>(
          builder: (context,hn, child2) {
            return Visibility(
              visible: _instance.disableScreen, child: child2 ?? Container(),
            );
          },
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: _instance.size.height,
              width: _instance.size.width,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              child: Center(child: Lottie.asset("assets/lottie/airplane.json")),
            ),
          ),
        )
      ],
    );
  }
}
