import 'package:easy_localization/easy_localization.dart';
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
      appBar: const CustomAppBar(backWard: false),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildBody(context),
      ),
    );
  }

  Column _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitleText(),
        const SizedBox(height: 20.0),
        _buildOptionContainer(
          Icons.business,
          "signup_title2".tr(),
          _isCompany,
          () {
            setState(() {
              _isCompany = !_isCompany;
            });
          },
        ),
        const SizedBox(height: 8.0),
        _buildOptionContainer(
          Icons.engineering,
          "signup_title3".tr(),
          _isStudent,
          () {
            setState(() {
              _isStudent = !_isStudent;
            });
          },
        ),
        const SizedBox(height: 20.0),
        _buildElevatedButton("signup_button1".tr(), _handleOnPressed),
        const SizedBox(height: 20.0),
        _buildLoginRow(context),
      ],
    );
  }

  Text _buildTitleText() {
    return Text(
      "signup_title1".tr(),
      textAlign: TextAlign.center,
      style: const TextStyle(
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
          padding: const EdgeInsets.all(16.0),
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
              const SizedBox(width: 8.0),
              Expanded(child: Text(text)),
              if (isSelected) const Icon(Icons.check),
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
          "signup_text1".tr(),
          textAlign: TextAlign.center,
        ),
        GestureDetector(
          onTap: () {
            moveToPage(Login(), context);
          },
          child: Text(
            "signup_text2".tr(),
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
    modelController.user.roles = [];
    if (_isCompany || _isStudent) {
      if (_isCompany) {
        modelController.user.roles.add(1);
      }
      if (_isStudent) {
        modelController.user.roles.add(0);
      }
      moveToPage(SignUp2(), context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an option"),
        ),
      );
    }
  }
}
