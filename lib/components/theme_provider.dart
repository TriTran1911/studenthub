import 'package:flutter/material.dart';

enum ThemeType {
  Light,
  Dark,
}

class ThemeProvider extends ChangeNotifier {
  ThemeData _lightTheme = ThemeData(
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    // Other theme properties
  );

  ThemeData _darkTheme = ThemeData(
    primaryColor: Colors.grey[900],
    scaffoldBackgroundColor: Colors.grey[800],
    // Other theme properties
  );

  ThemeType _themeType = ThemeType.Light;

  ThemeType getThemeType() {
    return _themeType;
  }

  ThemeData getTheme() {
    return _themeType == ThemeType.Light ? _lightTheme : _darkTheme;
  }

  void toggleTheme() {
    _themeType = _themeType == ThemeType.Light ? ThemeType.Dark : ThemeType.Light;
    notifyListeners();
  }
}

