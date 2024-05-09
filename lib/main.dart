import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/components/project.dart';
import '/components/proposer.dart';
import '/components/notifications.dart';
import '/screens/action/home.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/chatController.dart';
import 'package:studenthub/screens/Profile/SinputProfile1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  initialNotifications();
  initialProposers();
  initialSubmittedProjects();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('vi')],
      path: 'lib/translation',
      fallbackLocale: Locale('vi'),
      child: ChangeNotifierProvider(
        create: (context) => Schedule(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        debugShowCheckedModeBanner: false,
        title: 'StudentHub',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
        });
  }
}
