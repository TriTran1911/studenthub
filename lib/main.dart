import 'package:flutter/material.dart';
import '/components/project.dart';
import '/components/proposer.dart';
import '/screens/action/home.dart';

void main() {
  DateTime now = DateTime.now();
  DateTime projectCreationDate = DateTime(now.year, now.month, now.day);

  // Add a project before running the app
  Project.addProject(
    Project(
      'Web Development',
      ProjectDuration.oneToThreeMonths,
      [
        'Create a website for a small business.',
        'The website should be responsive and user-friendly.',
      ],
      'Open',
      projectCreationDate,
      members: 1,
      proposals: 3,
      messages: 5,
      hiredCount: 1,
    ),
  );
  Project.addProject(
    Project(
      'Mobile Development',
      ProjectDuration.threeToSixMonths,
      [
        'Create a mobile app for a small business.',
        'The app should be responsive and user-friendly.',
      ],
      'Open',
      projectCreationDate,
      members: 1,
      proposals: 2,
      messages: 3,
      hiredCount: 1,
    ),
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
