import 'dart:convert';

import 'package:flutter/material.dart';
import '/screens/HomePage/tabs.dart';
import '/components/appbar.dart';
import '/components/controller.dart';
import 'package:studenthub/components/modelController.dart';
import '/connection/http.dart';

class SignUp2 extends StatefulWidget {
  @override
  _Signup2State createState() => _Signup2State();
}

class ChatBubbleWithVisibilityToggle extends StatefulWidget {
  final TextEditingController textEditingController;
  final String label;
  final bool isPassword;

  const ChatBubbleWithVisibilityToggle({
    required this.textEditingController,
    required this.label,
    this.isPassword = false,
  });

  @override
  _ChatBubbleWithVisibilityToggleState createState() =>
      _ChatBubbleWithVisibilityToggleState();
}

class _ChatBubbleWithVisibilityToggleState
    extends State<ChatBubbleWithVisibilityToggle> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.textEditingController,
            obscureText: widget.isPassword && _obscureText,
            decoration: InputDecoration(
              labelText: widget.label,
              border: OutlineInputBorder(),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _Signup2State extends State<SignUp2> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;
  String _errorDetails = '';

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
            const SizedBox(height: 20.0),
            ChatBubble(
              textEditingController: _userNameController,
              label: 'Username',
            ),
            ChatBubble(
              textEditingController: _emailController,
              label: 'Work email address',
            ),
            ChatBubbleWithVisibilityToggle(
              textEditingController: _passwordController,
              label: 'Password (8 or more characters)',
              isPassword: true,
            ),
            const SizedBox(height: 10.0),
            _buildAgreementRow(),
            const SizedBox(height: 15.0),
            _buildElevatedButton('Create my account', _handleOnPressed),
            const SizedBox(height: 10.0),
            _buildToggleUserTypeRow(context),
          ],
        ),
      ),
    );
  }

  Text _buildTitleText() {
    return Text(
      User.roles[0] == 1 ? 'Sign up as Company' : 'Sign up as Student',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    );
  }

  Row _buildAgreementRow() {
    return Row(
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: (value) => setState(() => _agreedToTerms = value!),
        ),
        const Text('Yes, I understand and agree to StudetHub'),
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
          style: const TextStyle(
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
          User.roles[0] == 1
              ? "Looking for a project?  "
              : "Want to offer projects?  ",
          textAlign: TextAlign.center,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignUp2()),
            );
          },
          child: Text(
            User.roles[0] == 1 ? "Apply as a student" : "Apply as a company",
            textAlign: TextAlign.center,
            style: const TextStyle(
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
    User.fullname = _userNameController.text;
    User.email = _emailController.text;
    User.password = _passwordController.text;

    var data = {
      'fullname': User.fullname,
      'email': User.email,
      'password': User.password,
      'role': User.roles[0],
    };

    String url = '/api/auth/sign-up';

    try {
      var response = await Connection.postRequest(url, data);
      var responseDecoded = jsonDecode(response);
      if (responseDecoded['statusCode'] == 201) {
        print('User signed up successfully');
        navigateToPagePushReplacement(TabsPage(index: 0), context);
      } else {
        print('User signed up failed');
        dynamic errorDetails = responseDecoded['errorDetails'];
        String errorMessage = '';
        if (errorDetails is List) {
          errorMessage = errorDetails.first.toString();
        } else {
          errorMessage = errorDetails ?? 'Unknown error occurred';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while processing your request.'),
        ),
      );
    }
  }

  bool _checkSignup() {
    if (_userNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all the required fields."),
        ),
      );
      return false;
    }

    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 8 characters."),
        ),
      );
      return false;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
