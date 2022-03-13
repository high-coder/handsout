import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../../provider/bottom_navbar.dart';

class CustomBottomNavigationBar extends StatefulWidget {

   Function(int) onChange;
   List<String> iconList;
   List<String> textList;
  CustomBottomNavigationBar(
      {
        required this.iconList,
        required this.onChange,
        required this.textList,
      });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  //int _selectedIndex = 0;
  List<String> _iconList = [];
  List<String> _textList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
    _textList = widget.textList;
  }

  @override
  Widget build(BuildContext context) {
    print(_iconList.length);
    print("sdgfihsdfighosdhfghjdsog");
    print(_iconList.length);
    print(_textList.length);

    BottomNavBarHelper _navHelper = Provider.of<BottomNavBarHelper>(context, listen:false);
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], i , _textList[i]));
    }

    return Container(
      decoration:const  BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 12.0,
            spreadRadius: 1.0,
            offset: Offset(
              0,
              -5.0,
            ),
          ),
        ],
        color: Colors.black //: Color(0xFF3F3F3F),
      ),

      padding: const EdgeInsets.only(left: 15 , right: 15 , bottom: 10 , top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _navBarItemList,
      ),
    );
  }

  Widget buildNavBarItem(String icon, int index , String text) {
    BottomNavBarHelper _navHelper = Provider.of<BottomNavBarHelper>(context, listen:false);

    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        setState(() {
          //_navHelper.selectedIndex = index;
          _navHelper.updateSelectedIndex(index);
        });
      },
      //Color(0xFF464646),
      //Colors.red,

      child: Container(
        height: 59,
        padding:const EdgeInsets.symmetric(vertical: 8.0 , horizontal: 12.0),
        decoration: _navHelper.selectedIndex == index ? BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient:const LinearGradient(
            colors: [
              Color(0xFF05478A),
              //MyColors.appThemeRed,
              Color(0xFF73BCF8),
              //MyColors.appThemeBlue
            ],
//                 : [
//               Color(0xFF05478A),
//               Color(0xff549AD4),
// //              Color(0xFF636363),
//             ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ): const BoxDecoration(),
        child: Column(
          children: [
            Image.asset(
              icon,
              color: _navHelper.selectedIndex == index ? Colors.white : Colors.grey,
              height: 24,
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Text(
              text,
              style: GoogleFonts.montserrat(
                color: _navHelper.selectedIndex == index ? Colors.white : Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}