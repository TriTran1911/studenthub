import 'package:flutter/material.dart';
import '/components/project.dart';
import '/components/proposer.dart';
import '/components/notifications.dart';
import '/screens/action/home.dart';

void main() {
  initialNotifications();
  initialProposers();
  initialProjects();

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
