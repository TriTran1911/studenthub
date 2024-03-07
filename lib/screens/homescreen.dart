import 'package:flutter/material.dart';
import 'login_page.dart';
import '../components/custom_appbar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Đặt mainAxisAlignment thành start
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50), // Duy chuyển nội dung lên trên 50 pixels
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Build your product with high-skilled student',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'StudentHub is university marketplace to connect high-skilled student and company on a real-world project',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to SignUp1Page when Company button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Company'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to SignUp1Page when Student button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Student'),
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'StudentHub is university marketplace to connect high-skilled student and company on a real-world project',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Build your product with high-skilled student',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
