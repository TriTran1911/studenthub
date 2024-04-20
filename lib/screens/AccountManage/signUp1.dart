import 'package:flutter/material.dart';
import '/components/appbar.dart';
import 'signUp2.dart';
import 'login.dart';
import '/components/modelController.dart';
import '/components/controller.dart';

class SignUp1 extends StatefulWidget {
  @override
  _SignUpState1 createState() => _SignUpState1();
}

class _SignUpState1 extends State<SignUp1> {
  bool _isCompany = false;
  bool _isStudent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: _buildBody(context),
      ),
    );
  }

  Column _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitleText(),
        SizedBox(height: 20.0),
        _buildOptionContainer(
          Icons.business,
          'I am a company, find engineer for project',
          _isCompany,
          () {
            setState(() {
              _isCompany = !_isCompany;
            });
          },
        ),
        SizedBox(height: 8.0),
        _buildOptionContainer(
          Icons.engineering,
          'I am a student, find job to apply',
          _isStudent,
          () {
            setState(() {
              _isStudent = !_isStudent;
            });
          },
        ),
        SizedBox(height: 20.0),
        _buildElevatedButton('Create account', _handleOnPressed),
        SizedBox(height: 20.0),
        _buildLoginRow(context),
      ],
    );
  }

  Text _buildTitleText() {
    return Text(
      'Join as company or Student',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    );
  }

  Container _buildOptionContainer(
      IconData icon, String text, bool isSelected, VoidCallback onTap) {
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(width: 8.0),
              Expanded(child: Text(text)),
              if (isSelected) Icon(Icons.check),
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
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }

  Row _buildLoginRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?  ",
          textAlign: TextAlign.center,
        ),
        GestureDetector(
          onTap: () {
            navigateToPagePushReplacement(Login(), context);
          },
          child: Text(
            "Login",
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
    print(_isCompany);
    if (_isCompany || _isStudent) {
      if (_isCompany) {
        User.roles[0] = 1;
      }
      if (_isStudent) {
        User.roles[0] = 0;
      }
      navigateToPagePushReplacement(SignUp2(), context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select an option"),
        ),
      );
    }
  }
}
