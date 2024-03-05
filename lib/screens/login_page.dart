import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            Text(
              'Login with StudentHub',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Username or Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your username or email',
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Password',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Add your sign in logic here
              },
              child: Text('Sign In'),
            ),
            SizedBox(height: 300.0), // Đã thêm khoảng trống ở đây
            Text(
              "Don't have an Student Hub account?",
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                // Add your sign up navigation logic here
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
