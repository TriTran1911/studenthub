import 'package:flutter/material.dart';
import 'package:studenthub/screens/HomePage/tabs.dart';
import '/screens/action/account.dart';
import '/components/controller.dart';
import 'package:easy_localization/easy_localization.dart';
import '/components/theme_provider.dart';
import 'package:provider/provider.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool backWard;
  
  const CustomAppBar({super.key, required this.backWard});

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
              IconButton(
                  icon: context.locale == Locale('en')
                    ? Image.asset('images/usa.png', width: 26, height: 26)
                    : Image.asset('images/vietnam.png', width: 26, height: 26),
                onPressed: () {
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
                              // Chuyển đổi ngôn ngữ
                              if (context.locale == Locale('en')) {
                                context.setLocale(Locale('vi'));
                              } else {
                                context.setLocale(Locale('en'));
                              }
                              // Restart ứng dụng
                              Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                            },
                            child: Text("appbar_text4".tr()),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) => Icon(themeProvider.getThemeType() == ThemeType.Dark ? Icons.light_mode : Icons.dark_mode),
                ),
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
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
                        !appBarIcon.isBlocked
                            ? moveToPage(TabsPage(index: 0), context)
                            : null;
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
