import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signUp1.dart';
import '../../components/appbar.dart';
import '/screens/HomePage/tabs.dart';
import '/components/controller.dart';
import '/connection/http.dart';

class Login extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: true,
      body: _buildBody(context),
    );
  }

  SingleChildScrollView _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            _buildTitleText(),
            SizedBox(height: 20.0),
            _buildTextField(_usernameController, 'Email'),
            SizedBox(height: 20.0),
            _buildTextField(_passwordController, 'Password', obscureText: true),
            SizedBox(height: 20.0),
            _buildElevatedButton('Sign In', () {
              if (_isInputValid()) {
                appBarIcon.isBlocked = false;
                _handleSingIn();
                navigateToPagePushReplacement(TabsPage(index: 0), context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please fill in all the required fields."),
                  ),
                );
              }
            }),
            SizedBox(height: 300.0),
            _buildSignUpText(),
            _buildElevatedButton('Sign Up', () {
              navigateToPagePushReplacement(SignUp1(), context);
            }),
          ],
        ),
      ),
    );
  }

  Text _buildTitleText() {
    return Text(
      'Login with StudentHub',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    );
  }

  TextField _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  ElevatedButton _buildElevatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }

  Text _buildSignUpText() {
    return Text(
      "Don't have a Student Hub account?",
      textAlign: TextAlign.center,
    );
  }

  bool _isInputValid() {
    return _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  void _handleSingIn() async {
    var body = {
      'email': _usernameController.text,
      'password': _passwordController.text,
    };
    var response =
        await postRequest('http://10.0.2.2:4400/api/auth/sign-in', body);

    var responseDecoded = jsonDecode(response);
    print(responseDecoded['result']['token']);
    if (responseDecoded['result'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseDecoded['result']['token']);
      print('Sign in successful');
    } else {
      print('Sign in failed');
    }
  }
}
