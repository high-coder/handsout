import 'package:flutter/cupertino.dart';

class BottomNavBarHelper extends ChangeNotifier {
  int selectedIndex = 0;


  updateSelectedIndex(int localIndex) {
    int local = selectedIndex;
    selectedIndex = localIndex;
    if(local!=selectedIndex)
    notifyListeners();
  }

  updateTheFileState() {
    notifyListeners();
  }
}