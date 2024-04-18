import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signUp1.dart';
import '../../components/appbar.dart';
import '/screens/HomePage/tabs.dart';
import '/components/controller.dart';
import '/connection/http.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;

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
            const SizedBox(height: 20.0),
            Lottie.asset('assets/animation/login.json',
                height: 200, repeat: true, reverse: true),
            _buildTitleText(),
            const SizedBox(height: 20.0),
            _buildTextField(_usernameController, 'Email'),
            const SizedBox(height: 20.0),
            _buildTextField(_passwordController, 'Password',
                obscureText: _obscureText),
            const SizedBox(height: 20.0),
            _buildElevatedButton('Sign In', () {
              if (_isInputValid()) {
                appBarIcon.isBlocked = false;
                _handleSingIn(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please fill in all the required fields."),
                  ),
                );
              }
            }),
            const SizedBox(height: 120.0),
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
    return const Text(
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
        suffixIcon: label.toLowerCase() == 'password'
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }

  Text _buildSignUpText() {
    return const Text(
      "Don't have a Student Hub account?",
      textAlign: TextAlign.center,
    );
  }

  bool _isInputValid() {
    return _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  void _handleSingIn(BuildContext context) async {
    var body = {
      'email': _usernameController.text,
      'password': _passwordController.text,
    };
    var response = await Connection.postRequest('/api/auth/sign-in', body);

    var responseDecoded = jsonDecode(response);
    if (responseDecoded['result'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseDecoded['result']['token']);
      print('Sign in successful');
      navigateToPagePushReplacement(TabsPage(index: 0), context);
    } else {
    }
  }
}
