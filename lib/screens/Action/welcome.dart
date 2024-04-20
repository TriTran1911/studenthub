import 'package:flutter/material.dart';
import '/screens/HomePage/tabs.dart';
import '/components/appbar.dart';
import '/components/controller.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildBody(context),
    );
  }

  Center _buildBody(BuildContext context) {
    return Center(
      child: _buildColumn(context),
    );
  }

  Column _buildColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildIcon(),
        SizedBox(height: 20),
        _buildWelcomeText(),
        SizedBox(height: 10),
        _buildInstructionText(),
        SizedBox(height: 30),
        _buildGetStartedButton(context),
      ],
    );
  }

  Icon _buildIcon() {
    return Icon(
      Icons.assignment_ind, // Replace 'welcome' with your desired icon
      size: 50,
    );
  }

  Text _buildWelcomeText() {
    return Text(
      'Welcome, username', // Replace 'username' with the actual username
      style: TextStyle(fontSize: 24),
    );
  }

  Text _buildInstructionText() {
    return Text(
      "Let's start your first project post",
      style: TextStyle(fontSize: 18),
    );
  }

  ElevatedButton _buildGetStartedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        appBarIcon.isSelected = false;
        moveToPage(TabsPage(index: 0), context);
      },
      child: Text('Get started!'),
    );
  }
}
