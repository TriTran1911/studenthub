import 'package:flutter/material.dart';
import '/screens/HomePage/tabs.dart';
import '/components/custom_appbar.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.assignment_ind, // Replace 'welcome' with your desired icon
              size: 50,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome, username', // Replace 'username' with the actual username
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              "Let's start your first project post",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Add functionality for the button here
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TabsPage()),
                );
              },
              child: Text('Get started!'),
            ),
          ],
        ),
      ),
    );
  }
}
