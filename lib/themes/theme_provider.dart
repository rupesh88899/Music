import 'package:flutter/material.dart';
import 'package:music/themes/dark_mode.dart';
import 'package:music/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //initially light mide
  ThemeData _themeData = lightMode;

  //get current theme
  ThemeData get themeData => _themeData;

  // is dark mode
  bool get isDarkMode => _themeData == darkMode; // this will give true false

  ///set theme
  set themeData(ThemeData theme) {
    _themeData = theme;

    //updates ui
    notifyListeners();
  } // this will give dark mode & light mode

  // toggle theme
  void toggletheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
