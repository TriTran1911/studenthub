import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studenthub/screens/HomePage/tabs.dart';
import '/screens/action/account.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar();
  static bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 92, 92, 92),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('StudentHub',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          !isSelected
              ? IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    isSelected = !isSelected;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountController()),
                    );
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    isSelected = !isSelected;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TabsPage()),
                    );
                  },
                ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
