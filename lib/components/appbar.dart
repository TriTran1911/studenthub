import 'package:flutter/material.dart';
import '/components/theme_provider.dart'; // Import ThemeProvider
import '/screens/action/account.dart';
import '/components/controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool backWard;

  const CustomAppBar({Key? key, required this.backWard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: backWard,
      backgroundColor: const Color.fromARGB(255, 92, 92, 92),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('StudentHub',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Row(
            children: [
              // Nút chuyển đổi ngôn ngữ
              PopupMenuButton<String>(
                icon: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) => Icon(
                    Icons.language,
                    color: themeProvider.getIconColor(context),
                  ),
                ),
                onSelected: (String value) {
                  if ((value == 'vi' && context.locale != Locale('vi')) ||
                      (value == 'en' && context.locale != Locale('en'))) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("appbar_text1".tr()),
                          content: Text("appbar_text2".tr()),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("appbar_text3".tr()),
                            ),
                            TextButton(
                              onPressed: () {
                                if (value == 'vi') {
                                  context.setLocale(Locale('vi'));
                                } else {
                                  context.setLocale(Locale('en'));
                                }
                                Navigator.popUntil(
                                  context,
                                  ModalRoute.withName(
                                      Navigator.defaultRouteName),
                                );
                              },
                              child: Text("appbar_text4".tr()),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'vi',
                    child: Row(
                      children: <Widget>[
                        Image.asset('images/vietnam.png',
                            width: 26, height: 26),
                        SizedBox(width: 8),
                        Text('Vietnamese'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'en',
                    child: Row(
                      children: <Widget>[
                        Image.asset('images/usa.png', width: 26, height: 26),
                        SizedBox(width: 8),
                        Text('English'),
                      ],
                    ),
                  ),
                ],
              ),

              // Thay đổi chủ đề sử dụng ThemeProvider
              IconButton(
                icon: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) => Icon(
                    themeProvider.getThemeType() == ThemeType.Dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: themeProvider
                        .getIconColor(context), // Lấy màu biểu tượng từ chủ đề
                  ),
                ),
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
              ),

              // Nút đăng nhập hoặc tìm kiếm
              !appBarIcon.isSelected
                  ? IconButton(
                      icon: const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        if (!appBarIcon.isBlocked) {
                          appBarIcon.isSelected = true;
                          moveToPage(AccountController(), context);
                        }
                      })
                  : IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        appBarIcon.isSelected = false;
                        !appBarIcon.isBlocked ? Navigator.pop(context) : null;
                      },
                    ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
class CustomAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Gradient gradient;

  const CustomAppBar1({
    Key? key,
    required this.title,
    this.showBackButton = false,
    required this.gradient,
  }) : preferredSize = const Size.fromHeight(60.0), super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
      ),
    );
  }
}

