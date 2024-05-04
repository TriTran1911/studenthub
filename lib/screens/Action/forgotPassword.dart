import 'dart:convert';

import 'package:flutter/material.dart';
import '/components/appbar.dart';
import '/connection/server.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: true,
      body: _buildBody(context),
    );
  }

  Center _buildBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20.0),
              const Text(
                'Trouble logging in?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              const Text(
                  "Enter your email, phone, or username and we'll send you a link to get back into your account.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              if (showError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Please enter a valid email address.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20.0),
              _buildElevatedButton('Send login link', () {
                if (_emailController.text.isNotEmpty) {
                  _handleForgotPassword(_emailController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill in all the required fields."),
                    ),
                  );
                }
              }),
              const SizedBox(height: 20.0),
              _buildElevatedButton('Back to login', () {
                Navigator.pop(context);
              }),
            ],
          ),
        ),
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
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }

  void _handleForgotPassword(String text) async {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isValidEmail = emailRegex.hasMatch(_emailController.text);
    setState(() {
      showError = !isValidEmail;
    });
    if (!isValidEmail) {
      return;
    }
    ;

    var data = {
      'email': text,
    };

    String url = '/api/user/forgotPassword';
    try {
      var response = await Connection.postRequest(url, data);
      var responseDecoded = jsonDecode(response);
      if (responseDecoded['result'] != null) {
        print('Login link sent successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login link sent'),
              content: Text(
                responseDecoded['result']['message'],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print(' Error occurred: $responseDecoded');
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
}
