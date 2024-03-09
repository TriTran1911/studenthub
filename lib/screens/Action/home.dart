import 'package:flutter/material.dart';
import '/components/appbar.dart';
import '/screens/entry/Login.dart';
import '/components/controller.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildBody(context),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50),
          _buildTextColumn(),
          SizedBox(height: 20),
          _buildElevatedButton(
            'Company',
            () {
              navigateToPage(Login(), context);
            },
          ),
          SizedBox(height: 20),
          _buildElevatedButton(
            'Student',
            () {
              User.isCompany = false;
              navigateToPage(Login(), context);
            },
          ),
          SizedBox(height: 20),
          _buildTextColumn(),
        ],
      ),
    );
  }

  Column _buildTextColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Build your product with high-skilled student',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'StudentHub is university marketplace to connect high-skilled student and company on a real-world project',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  ElevatedButton _buildElevatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }
}