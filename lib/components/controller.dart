import 'package:flutter/material.dart';

class User {
  static String username = '';
  static String email = '';
  static String password = '';
  static bool isCompany = true;
  static String nstaff = '';
  static String cname = '';
  static String website = '';
  static String description = '';
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
