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

Widget buildCenterText(String text, double fontSize, FontWeight fontWeight,
    [Color? color]) {
  return Center(
    child: Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
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

InputDecoration buildDecoration(String text) {
  return InputDecoration(
    labelText: text,
    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.circular(5.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
      borderRadius: BorderRadius.circular(5.0),
    ),
  );
}

String addBulletPoints(String input) {
  List<String> lines = input.split('\n');
  List<String> bulletPoints = lines.map((line) => '• $line').toList();
  return bulletPoints.join('\n');
}

Widget buildTextField(String initialValue, [int maxLines = 1]) {
  return TextFormField(
    maxLines: maxLines,
    initialValue: initialValue,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
