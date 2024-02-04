import 'package:flutter/material.dart';
import 'package:musicme/themes/lightmode.dart';
import 'package:musicme/themes/darkmode.dart';

class ThemeProvider extends ChangeNotifier { 

  ThemeData _themeData = lightMode; 

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) { 
      _themeData = themeData; 

      // updates the UI
      notifyListeners(); 
  }

  void toggleTheme() { 
    if (_themeData == lightMode) { 
      themeData = darkMode;
    } else { 
      themeData = lightMode;
    }
  }
}