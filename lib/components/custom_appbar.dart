import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '/screens/action/account.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar();
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
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AccountController()),
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
