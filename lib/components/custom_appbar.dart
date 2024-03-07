import 'package:flutter/material.dart';
import '../screens/switch_account.dart';
import 'package:flutter/widgets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 92, 92, 92),
      title: Row(
<<<<<<< Updated upstream
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
>>>>>>> Stashed changes
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
