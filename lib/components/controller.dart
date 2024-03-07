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

class TabInfo {
  final Widget page;
  final String label;
  final IconData icon;

  TabInfo({required this.page, required this.label, required this.icon});
}
