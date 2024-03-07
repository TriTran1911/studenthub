import 'package:flutter/material.dart';
import 'package:studenthub/screens/action/account.dart';
import '/components/custom_appbar.dart';

class SignUp2 extends StatefulWidget {
  @override
  _Signup2State createState() => _Signup2State();
}

class _Signup2State extends State<SignUp2> {
  bool _isCompany = true; // Track the user type
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  _isCompany ? 'Sign up as Company' : 'Sign up as Student',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.0),
              ChatBubble(
                textEditingController: _fullNameController,
                label: 'Fullname',
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
              Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (value) =>
                        setState(() => _agreedToTerms = value!),
                  ),
                  Text('Yes, I understand and agree to StudetHub'),
                ],
              ),
              SizedBox(height: 15.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_checkSignup()) {
                      _handleSignup();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountController(),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Create my account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isCompany
                        ? "Looking for a project?  "
                        : "Want to offer projects?  ",
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCompany = !_isCompany; // Toggle user type
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp2()),
                      );
                    },
                    child: Text(
                      _isCompany ? "Apply as a user" : "Apply as a company",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignup() {
    print('Signup with:');
    print('Fullname: ${_fullNameController.text}');
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
  }

  bool _checkSignup() {
    if (_fullNameController.text.isEmpty ||
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
