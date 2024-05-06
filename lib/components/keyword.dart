import 'package:flutter/material.dart';

Widget buildText(String text, double fontSize, FontWeight fontWeight,
    [Color? color]) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}

Widget buildCenterText(String text, double fontSize, FontWeight fontWeight) {
  return Center(
    child: Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    ),
  );
}