import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/homescreen.dart';
import 'screens/login_page.dart';
import 'screens/signup1_page.dart';
import '../screens/switch_account.dart';
import 'screens/profile_input_2.dart';
import '../components/project.dart';

void main() {
  Project.addProject('Project 1', ProjectDuration.oneToThreeMonths,
      'Description 1', 'Working');
  Project.addProject('Project 2', ProjectDuration.threeToSixMonths,
      'Description 2', 'Achieved');
  Project.addProject('Project 3', ProjectDuration.oneToThreeMonths,
      'Description 3', 'Working');
  Project.addProject('Project 4', ProjectDuration.threeToSixMonths,
      'Description 4', 'Achieved');
  Project.addProject('Project 5', ProjectDuration.oneToThreeMonths,
      'Description 5', 'Working');
  Project.addProject('Project 6', ProjectDuration.threeToSixMonths,
      'Description 6', 'Achieved');

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
<<<<<<< Updated upstream
      home: ProfileInputScreen(),
=======
      home: SwitchAccountScreen(),
>>>>>>> Stashed changes
    );
  }
}
