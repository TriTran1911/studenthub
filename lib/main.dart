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
      'Web development',
      ProjectDuration.oneToThreeMonths,
      [
        'We are looking for a web developer to help us build a website.',
        'The website will be built using HTML, CSS, and JavaScript.',
        'The website will be hosted on Firebase.',
      ],
      'Open',
      projectCreationDate,
      studentsNeeded: 3,
    ),
  );
  Project.addProject(
    Project(
      'Mobile development',
      ProjectDuration.threeToSixMonths,
      [
        'We are looking for a mobile developer to help us build a mobile app.',
        'The mobile app will be built using Flutter.',
        'The mobile app will be hosted on Firebase.',
      ],
      'Open',
      projectCreationDate,
      studentsNeeded: 2,
    ),
  );
  Project.addProject(
    Project(
      'Web development',
      ProjectDuration.oneToThreeMonths,
      [
        'We are looking for a web developer to help us build a website.',
        'The website will be built using HTML, CSS, and JavaScript.',
        'The website will be hosted on Firebase.',
      ],
      'Open',
      projectCreationDate,
      studentsNeeded: 1,
    ),
  );
  Project.addProject(
    Project(
      'Mobile development',
      ProjectDuration.threeToSixMonths,
      [
        'We are looking for a mobile developer to help us build a mobile app.',
        'The mobile app will be built using Flutter.',
        'The mobile app will be hosted on Firebase.',
      ],
      'Open',
      projectCreationDate,
      studentsNeeded: 2,
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
