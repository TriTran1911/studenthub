import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/main.dart'; // Thay thế đường dẫn với main.dart thực tế của bạn

// Tạo một Provider để lưu trữ thông tin về ngôn ngữ được chọn
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
    var languageProvider = Provider.of<LanguageProvider>(context, listen: false);

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
