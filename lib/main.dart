import 'package:flutter/material.dart';
import 'package:studenthub/screens/HomePage/message/pages/ChatDetailPage.dart';
import '/components/project.dart';
import '/components/proposer.dart';
import '/components/notifications.dart';
import '/screens/action/home.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/chatController.dart';

void main() {
  initialNotifications();
  initialProposers();
  initialProjects();
  initialSubmittedProjects();

  runApp(
    ChangeNotifierProvider(
      create: (context) => Schedule(),
      child: MyApp(),
    ),
  );
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
        routes: {
          '/': (context) => Home(),
          'chatDetailPage': (context) => ChatDetailPage(),
        });
  }
}
