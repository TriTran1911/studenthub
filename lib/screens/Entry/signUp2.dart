import 'dart:convert';

import 'package:flutter/material.dart';
import '/screens/HomePage/tabs.dart';
import '/components/appbar.dart';
import '/components/controller.dart';
import '/connection/http.dart';

class SignUp2 extends StatefulWidget {
  @override
  _Signup2State createState() => _Signup2State();
}

class _Signup2State extends State<SignUp2> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleText(),
            SizedBox(height: 20.0),
            ChatBubble(
              textEditingController: _userNameController,
              label: 'Username',
            ),
            ChatBubble(
              textEditingController: _emailController,
              label: 'Work email address',
            ),
            ChatBubble(
              textEditingController: _passwordController,
              label: 'Password (8 or more characters)',
              isPassword: true,
            ),
            SizedBox(height: 10.0),
            _buildAgreementRow(),
            SizedBox(height: 15.0),
            _buildElevatedButton('Create my account', _handleOnPressed),
            SizedBox(height: 10.0),
            _buildToggleUserTypeRow(context),
          ],
        ),
      ),
    );
  }

  Text _buildTitleText() {
    return Text(
      User.isCompany ? 'Sign up as Company' : 'Sign up as Student',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    );
  }

  Row _buildAgreementRow() {
    return Row(
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: (value) => setState(() => _agreedToTerms = value!),
        ),
        Text('Yes, I understand and agree to StudetHub'),
      ],
    );
  }

  Center _buildElevatedButton(String text, VoidCallback onPressed) {
    return Center(
      child: ElevatedButton(
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
      ),
    );
  }

  Row _buildToggleUserTypeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          User.isCompany
              ? "Looking for a project?  "
              : "Want to offer projects?  ",
          textAlign: TextAlign.center,
        ),
        GestureDetector(
          onTap: () {
            User.isCompany = !User.isCompany; // Toggle user type
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignUp2()),
            );
          },
          child: Text(
            User.isCompany ? "Apply as a student" : "Apply as a company",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  void _handleOnPressed() {
    if (_checkSignup()) {
      _handleSignup();
      appBarIcon.isBlocked = false;
    }
  }

  void _handleSignup() async {
    User.username = _userNameController.text;
    User.email = _emailController.text;
    User.password = _passwordController.text;
    User.role = User.isCompany ? 1 : 0;

    var data = {
      'fullname': User.username,
      'email': User.email,
      'password': User.password,
      'role': User.role,
    };

    String url = 'http://10.0.2.2:4400/api/auth/sign-up';

    var response = await postRequest(url, data);
    var responseDecoded = jsonDecode(response);
    if (responseDecoded['statusCode'] == 201) {
      print('User signed up failed');
    } else {
      print('User signed up successfully');
      navigateToPagePushReplacement(TabsPage(index: 0), context);
    }
  }

  bool _checkSignup() {
    if (_userNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all the required fields."),
        ),
      );
      return false;
    }

    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password must be at least 8 characters."),
        ),
      );
      return false;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please agree to the terms to continue"),
        ),
      );
      return false;
    }

    return true;
  }
}

class ChatBubble extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final bool isPassword;

  const ChatBubble({
    required this.textEditingController,
    required this.label,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: textEditingController,
            obscureText: isPassword,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
