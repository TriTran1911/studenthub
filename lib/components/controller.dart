import 'package:flutter/material.dart';

class User {
  static String username = '';
  static String email = '';
  static String password = '';
  static num role = 0;
  static bool isCompany = true;
  static num nstaff = 0;
  static String cname = '';
  static String website = '';
  static String description = '';
  static bool hasProfile = false;
}

class appBarIcon {
  static bool isSelected = false;
  static bool isBlocked = true;
}

class TabInfo {
  final Widget page;
  final String label;
  final IconData icon;

  TabInfo({required this.page, required this.label, required this.icon});
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

void navigateToPagePushReplacement(Widget page, BuildContext context) {
  Navigator.of(context).pushReplacement(_createRoute(page));
}

void navigateToPagePush(Widget page, BuildContext context) {
  Navigator.of(context).push(_createRoute(page));
}
