import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../../components/appbar.dart';
import '/screens/action/welcome.dart';
import '/components/controller.dart';
import '/connection/http.dart';
import '/components/modelController.dart';

class CWithoutProfile extends StatefulWidget {
  @override
  _CWithoutProfileState createState() => _CWithoutProfileState();
}

class _CWithoutProfileState extends State<CWithoutProfile> {
  String _selectedCompanySize = '';
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _BuildScaffold(context);
  }

  Scaffold _BuildScaffold(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: true,
      body: _buidSingleChildScrollView(),
    );
  }

  SingleChildScrollView _buidSingleChildScrollView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildCenterText('Welcome to Student Hub', 24, FontWeight.bold),
            SizedBox(height: 15),
            buildText(
                'Tell us about your company and you will be on your way connect with high-skilled students',
                16),
            SizedBox(height: 15),
            buildText('How many people are in your company?', 16),
            buildRadioListTile('It\'s just me', 'Just me'),
            buildRadioListTile('2-9 employees', '2-9 employees'),
            buildRadioListTile('10-99 employees', '10-99 employees'),
            buildRadioListTile('100-1000 employees', '100-1000 employees'),
            buildRadioListTile(
                'More than 1000 employees', 'More than 1000 employees'),
            SizedBox(height: 15),
            buildTextField(_companyNameController, 'Company name'),
            SizedBox(height: 15),
            buildTextField(_websiteController, 'Website'),
            SizedBox(height: 15),
            buildTextField(_descriptionController, 'Description'),
            SizedBox(height: 15),
            buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget buildCenterText(String text, double fontSize, FontWeight fontWeight) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }

  Widget buildText(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }

  Widget buildRadioListTile(String title, String value) {
    return RadioListTile(
      title: Text(title, style: TextStyle(fontSize: 14)),
      value: value,
      groupValue: _selectedCompanySize,
      onChanged: (value) {
        setState(() {
          _selectedCompanySize = value!;
        });
      },
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> postProfile(String companyName, int size, String website, String description) async {
    var data = {
      'companyName': companyName,
      'size': size,
      'website': website,
      'description': description,
    };
    String url = '/api/profile/company';

    var response = await Connection.postRequest(url, data);
    var responseDecoded = jsonDecode(response);
    if (responseDecoded['statusCode'] == 401) {
      print('Company profile input failed');
    } else {
      print('Company profile input successful');
    }
  }

  Widget buildContinueButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          if (_isInputValid()) {
            int nstaff = _selectedCompanySize == 'It\'s just me'
                ? 0
                : (_selectedCompanySize == '2-9 employees')
                    ? 1
                    : (_selectedCompanySize == '10-99 employees'
                        ? 2
                        : (_selectedCompanySize == '100-1000 employees'
                            ? 3
                            : 4));
            String cname = _companyNameController.text;
            String website = _websiteController.text;
            String description = _descriptionController.text;
            postProfile(cname, nstaff, website, description);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Welcome()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please fill in all the required fields."),
              ),
            );
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        child: Text(
          'Continue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  bool _isInputValid() {
    return _selectedCompanySize.isNotEmpty &&
        _companyNameController.text.isNotEmpty &&
        _websiteController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty;
  }
}