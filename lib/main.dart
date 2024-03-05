import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudentHub',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StudentHub'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to Company section
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CompanyScreen() 
                )); 
              },
              child: Text('Company'),
            ),
            SizedBox(height: 20), 
            ElevatedButton(
              onPressed: () {
                // Navigate to Student section
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => StudentScreen() 
                )); 
              },
              child: Text('Student'),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder screens for navigation
class CompanyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Company')),
      body: Center(child: Text('Company Section')),
    );
  }
}

class StudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student')),
      body: Center(child: Text('Student Section')),
    );
  }
}

