import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/theme_provider.dart';
import '/components/appbar.dart';
import '/components/controller.dart';
import 'package:studenthub/components/modelController.dart';
import '/connection/server.dart';
import 'login.dart';

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
  void initState() {
    super.initState();
    print('Role: ' + modelController.user.roles[0].toString());
  }

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
              labelStyle: Theme.of(context).textTheme.bodyText1,
              border: OutlineInputBorder(),
              suffixIcon: widget.isPassword
                  ? Consumer<ThemeProvider>(
                      builder: (context, themeProvider, _) => IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: themeProvider.getIconColor(
                              context), // Lấy màu biểu tượng từ chủ đề
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backWard: false),
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
              label: "signup_text6".tr(),
            ),
            ChatBubble(
              textEditingController: _emailController,
              label: "signup_text7".tr(),
            ),
            ChatBubbleWithVisibilityToggle(
              textEditingController: _passwordController,
              label: "signup_text8".tr(),
              isPassword: true,
            ),
            const SizedBox(height: 10.0),
            _buildAgreementRow(),
            const SizedBox(height: 15.0),
            _buildElevatedButton("signup_button2".tr(), _handleOnPressed),
            const SizedBox(height: 10.0),
            _buildToggleUserTypeRow(context),
          ],
        ),
      ),
    );
  }

  Text _buildTitleText() {
    return Text(
      modelController.user.roles[0] == 1
          ? "signup_title4".tr()
          : "signup_title5".tr(),
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
        Text("signup_text9".tr()),
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
          modelController.user.roles[0] == 1
              ? "signup_text10".tr()
              : "signup_text11".tr(),
          textAlign: TextAlign.center,
        ),
        GestureDetector(
          onTap: () {
            modelController.user.roles[0] == 1
                ? modelController.user.roles[0] = 0
                : modelController.user.roles[0] = 1;
            moveToPage(SignUp2(), context);
          },
          child: Text(
            modelController.user.roles[0] == 1
                ? "signup_text12".tr()
                : "signup_text13".tr(),
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
    var data = {
      'fullname': _userNameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'role': modelController.user.roles[0],
    };

    String url = '/api/auth/sign-up';

    try {
      var response = await Connection.postRequest(url, data);
      var responseDecoded = jsonDecode(response);
      print(responseDecoded);
      if (responseDecoded['result'] != null) {
        print("signup_noti1".tr());
        moveToPage(Login(), context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("signup_noti2".tr()),
          ),
        );
      } else {
        print("signup_noti7".tr() + '${responseDecoded['errorDetails']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("signup_noti3".tr()),
          ),
        );
      }
    } catch (e) {
      print("signup_noti7".tr() + '$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("signup_noti3".tr()),
        ),
      );
    }
  }

  bool _checkSignup() {
    if (_userNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("signup_noti4".tr()),
        ),
      );
      return false;
    }

    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("signup_noti5".tr()),
        ),
      );
      return false;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("signup_noti6".tr()),
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
              labelStyle: Theme.of(context).textTheme.bodyText1,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
