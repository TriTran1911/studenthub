import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/loading.dart';
import 'signUp1.dart';
import '../../components/appbar.dart';
import '/screens/HomePage/tabs.dart';
import '/components/controller.dart';
import '/components/modelController.dart';
import '/connection/server.dart';
import '../Action/forgotPassword.dart';

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
      appBar: const CustomAppBar(backWard: false),
      resizeToAvoidBottomInset: true,
      body: _buildBody(context),
    );
  }

  SingleChildScrollView _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
            _buildTextField(_passwordController, "login_password".tr(),
                obscureText: _obscureText),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                moveToPage(ForgotPasswordPage(), context);
              },
              child: Text(
                "login_password1".tr(),
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            _buildElevatedButton("login_button1".tr(), () {
              if (_isInputValid()) {
                appBarIcon.isBlocked = false;
                _handleSingIn(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("login_text2".tr()),
                  ),
                );
              }
            }),
            const SizedBox(height: 120.0),
            _buildSignUpText(),
            _buildElevatedButton("login_button2".tr(), () {
              moveToPage(SignUp1(), context);
            }),
          ],
        ),
      ),
    );
  }

  Text _buildTitleText() {
    return Text(
      "login_title1".tr(),
      textAlign: TextAlign.center,
      style: const TextStyle(
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
        border: const OutlineInputBorder(),
        suffixIcon: label.toLowerCase() == "login_password".tr()
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
    return Text(
      "login_text1".tr(),
      textAlign: TextAlign.center,
    );
  }

  bool _isInputValid() {
    return _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  void _handleSingIn(BuildContext context) async {
    showDialog(context: context, builder: (context) => LoadingPage());

    var body = {
      'email': _usernameController.text,
      'password': _passwordController.text,
    };

    try {
      var response = await Connection.postRequest('/api/auth/sign-in', body);
      var responseDecoded = jsonDecode(response);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (responseDecoded['result'] != null) {
        prefs.setString('token', responseDecoded['result']['token']);
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop();
        print("login_text3".tr());

        var authorization = await Connection.getRequest('/api/auth/me/', {});
        var authorizationDecoded = jsonDecode(authorization);

        Navigator.of(context).pop();
        print('Sign in successful');

        if (authorizationDecoded['result']['company'] != null) {
          prefs.setInt(
              'companyId', authorizationDecoded['result']['company']['id']);
          modelController.user.id =
              authorizationDecoded['result']['company']['userId'];
        }
        if (authorizationDecoded['result']['student'] != null) {
          prefs.setInt(
              'studentId', authorizationDecoded['result']['student']['userId']);
          modelController.user.id =
              authorizationDecoded['result']['student']['id'];
        }
        modelController.user.roles =
            List<int>.from(authorizationDecoded['result']['roles']);
        modelController.user.fullname =
            authorizationDecoded['result']['fullname'];
        print("login_text3".tr());
        moveToPage(TabsPage(index: 0), context);
      } else {
        Navigator.of(context).pop();
        print(responseDecoded['errorDetails']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("login_text4".tr()),
          ),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("login_text5".tr()),
        ),
      );
    }
  }
}
