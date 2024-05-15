import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/components/theme_provider.dart';
import '/components/project.dart';
import '/components/proposer.dart';
import '/components/notifications.dart';
import '/screens/action/home.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/chatController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // Khởi tạo các thông báo, proposers, và submitted projects
  initialNotifications();
  initialProposers();
  initialSubmittedProjects();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('vi')],
      path: 'lib/translation',
      fallbackLocale: Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Schedule()),
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          debugShowCheckedModeBanner: false,
          title: 'StudentHub',
          theme: themeProvider.getTheme(),
          initialRoute: '/',
          routes: {
            '/': (context) => Home(),
          },
        );
      },
    );
  }
}
