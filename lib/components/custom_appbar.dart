import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../screens/switch_account.dart';
=======
import 'package:flutter/widgets.dart';
>>>>>>> 480a589 (fix dashboard and custom appbar)

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 92, 92, 92),
      title: Row(
<<<<<<< HEAD
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('StudentHub'),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SwitchAccountScreen()),
              );
            },
          ),
        ],
      ),
=======
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('StudentHub', 
            style: 
              TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.white, size: 30,),
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
          ],
        ),
>>>>>>> 480a589 (fix dashboard and custom appbar)
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
