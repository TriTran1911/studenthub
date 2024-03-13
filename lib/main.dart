import 'package:flutter/material.dart';
import '/components/project.dart';
import '/screens/action/home.dart';

void main() {
  DateTime now = DateTime.now();
  DateTime projectCreationDate = DateTime(now.year, now.month, now.day);

  Project.addProject('Build a website ', ProjectDuration.oneToThreeMonths, 'I need a website for my business', 'Open', projectCreationDate, proposals: 5, messages: 3, hiredCount: 1);
  Project.addProject('Create a mobile app', ProjectDuration.threeToSixMonths, 'I need a mobile app for my business', 'Open', projectCreationDate, proposals: 3, messages: 2, hiredCount: 0);
  Project.addProject('Design a logo', ProjectDuration.oneToThreeMonths, 'I need a logo for my business', 'Open', projectCreationDate, proposals: 2, messages: 1, hiredCount: 0);
  Project.addProject('Write a business plan', ProjectDuration.threeToSixMonths, 'I need a business plan for my business', 'Open', projectCreationDate, proposals: 1, messages: 0, hiredCount: 0);
  Project.addProject('Create a marketing strategy', ProjectDuration.oneToThreeMonths, 'I need a marketing strategy for my business', 'Open', projectCreationDate, proposals: 0, messages: 0, hiredCount: 0);
  Project.addProject('Build a website 1', ProjectDuration.oneToThreeMonths, 'I need a website for my business', 'Open', projectCreationDate, proposals: 5, messages: 3, hiredCount: 1);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudentHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Home(),
    );
  }
}
