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

ButtonStyle buildButtonStyle(Color color) {
  return ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.all(16.0),
    ),
    backgroundColor: MaterialStateProperty.all<Color>(color),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
  );
}
