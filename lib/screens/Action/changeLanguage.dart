import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  // Phương thức để thay đổi ngôn ngữ
  void changeLanguage(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

// Trang chuyển đổi ngôn ngữ
class ChangeLanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Language'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                languageProvider.changeLanguage(Locale('en'));
              },
              child: Text('English'),
            ),
            ElevatedButton(
              onPressed: () {
                languageProvider.changeLanguage(Locale('vi'));
              },
              child: Text('Vietnamese'),
            ),
          ],
        ),
      ),
    );
  }
}
