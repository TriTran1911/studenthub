import 'package:flutter/material.dart';
import '/components/project.dart';
import '/components/proposer.dart';
import '/screens/action/home.dart';

void main() {
  DateTime now = DateTime.now();
  DateTime projectCreationDate = DateTime(now.year, now.month, now.day);

  Project.addProject(
      'Build a website ',
      ProjectDuration.oneToThreeMonths,
      ["I need a university student", "Have 1 year experience"],
      'Open',
      projectCreationDate,
      proposals: 5,
      messages: 3,
      hiredCount: 1);
  Project.addProject(
      'Build a mobile app',
      ProjectDuration.threeToSixMonths,
      ["I need a college student", "Have 2 year experience"],
      'Open',
      projectCreationDate,
      proposals: 3,
      messages: 2,
      hiredCount: 0);
  Project.addProject(
      'Build a web app',
      ProjectDuration.oneToThreeMonths,
      ["I need a high school student", "Have 3 year experience"],
      'Open',
      projectCreationDate,
      proposals: 2,
      messages: 1,
      hiredCount: 0);
  Project.addProject(
      'Build a desktop app',
      ProjectDuration.threeToSixMonths,
      ["I need a university student", "Have 4 year experience"],
      'Open',
      projectCreationDate,
      proposals: 1,
      messages: 0,
      hiredCount: 0);

  // Add a proposer before running the app
  Proposer.addProposer(
    'John Doe',
    'Web Developer',
    'I have 3 years of experience in web development.',
    false,
  );
  Proposer.addProposer(
    'Jane Doe',
    'Mobile Developer',
    'I have 2 years of experience in mobile development.',
    false,
  );
  Proposer.addProposer(
    'John Smith',
    'Web Developer',
    'I have 1 year of experience in web development.',
    true,
  );

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
