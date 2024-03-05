import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';
import '../screens/signup2_page.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isCompany = false;
  bool _isStudent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Join as company or Student',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCompany = !_isCompany;
                  _isStudent = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isCompany ? Colors.blue : Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.business), // Logo của company
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'I am a company, find engineer for project',
                      ),
                    ),
                    if (_isCompany) Icon(Icons.check),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isStudent = !_isStudent;
                  _isCompany = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isStudent ? Colors.blue : Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.engineering), // Logo của engineer
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'I am a student, find job to apply',
                      ),
                    ),
                    if (_isStudent) Icon(Icons.check),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen_2()),
                );
              },
              child: Text('Create account'),
            ),
            SizedBox(height: 20.0),
            Text(
              "Already have an account? Login",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
