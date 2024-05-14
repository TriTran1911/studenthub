import 'package:flutter/material.dart';

enum ThemeType {
  Light,
  Dark,
}

class ThemeProvider extends ChangeNotifier {
  ThemeData _lightTheme = ThemeData(
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: Colors.grey, // Màu của hintText trong theme sáng
      ),
    ),
  );

  ThemeData _darkTheme = ThemeData(
    primaryColor: Colors.grey[900],
    scaffoldBackgroundColor: Colors.grey[800],
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: const Color.fromARGB(
            255, 245, 242, 242), // Màu của hintText trong theme tối
      ),
    ),
  );

  ThemeType _themeType = ThemeType.Light;

  ThemeType getThemeType() {
    return _themeType;
  }

  ThemeData getTheme() {
    return _themeType == ThemeType.Light ? _lightTheme : _darkTheme;
  }

  void toggleTheme() {
    _themeType =
        _themeType == ThemeType.Light ? ThemeType.Dark : ThemeType.Light;
    notifyListeners();
  }
}
