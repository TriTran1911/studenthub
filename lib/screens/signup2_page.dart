import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';

class SignupScreen_2 extends StatefulWidget {
  @override
  _SignupScreenState_2 createState() => _SignupScreenState_2();
}

class _SignupScreenState_2 extends State<SignupScreen_2> {
  // Create state variables for form fields
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign up as Company',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
                  onChanged: (value) => setState(() => _agreedToTerms = value!),
                ),
                Text('Yes, I understand and agree to StudetHub'),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _agreedToTerms ? () => _handleSignup() : null,
              child: Text('Create my account'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.0),
              ),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {},
              child: Text('Looking for a project? Apply as a user'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSignup() {
    // Add your signup logic here
    print('Signup with:');
    print('Fullname: ${_fullNameController.text}');
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
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
