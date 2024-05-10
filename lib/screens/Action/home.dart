import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '/components/appbar.dart';
import '/screens/AccountManage/Login.dart';
import '/components/controller.dart';
import '/components/theme_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
          Lottie.asset('assets/animation/home.json',
              height: 300, repeat: true, reverse: true),
          SizedBox(height: 20),
          _buildElevatedButton(
            "home_button1".tr(),
            () {
              moveToPage(Login(), context);
            },
          ),
          SizedBox(height: 20),
          _buildElevatedButton(
            "home_button2".tr(),
            () {
              moveToPage(Login(), context);
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
          "home_title1".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "home_title2".tr(),
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
