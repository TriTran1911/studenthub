import 'package:flutter/material.dart';
import '/components/project.dart';
import '/components/proposer.dart';
import '/screens/action/home.dart';
import '/screens/homepage/tabs.dart';

void main() {
  DateTime now = DateTime.now();
  DateTime projectCreationDate = DateTime(now.year, now.month, now.day);

  // Add a project before running the app
  Project.addProject(
    'Create a website',
    ProjectDuration.oneToThreeMonths,
    [
      'We need a website for our company. It should be modern and responsive.',
      'We need a website for our company. It should be modern and responsive.',
    ],
    'Open',
    projectCreationDate,
    studentsNeeded: 3,
    timeNeeded: '1-3 months',
  );
  Project.addProject(
    'Create a mobile app',
    ProjectDuration.threeToSixMonths,
    [
      'We need a mobile app for our company. It should be modern and responsive.',
      'We need a mobile app for our company. It should be modern and responsive.',
    ],
    'Open',
    projectCreationDate,
    studentsNeeded: 2,
    timeNeeded: '3-6 months',
  );

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
