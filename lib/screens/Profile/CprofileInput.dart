import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../components/appbar.dart';
import '/screens/action/welcome.dart';
import '/connection/server.dart';

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
            buildCenterText("proifle_title1".tr(), 24, FontWeight.bold),
            const SizedBox(height: 15),
            buildText(
                "cprofileinput_text1".tr(),
                16),
            const SizedBox(height: 15),
            buildText("cprofileinput_text2".tr(), 16),
            buildRadioListTile("cprofileinput_text3".tr(), 'Just me'),
            buildRadioListTile("cprofileinput_text4".tr(), '2-9 employees'),
            buildRadioListTile("cprofileinput_text5".tr(), '10-99 employees'),
            buildRadioListTile("cprofileinput_text6".tr(), '100-1000 employees'),
            buildRadioListTile(
                "cprofileinput_text7".tr(), 'More than 1000 employees'),
            const SizedBox(height: 15),
            buildTextField(_companyNameController, "cprofileinput_input1".tr()),
            const SizedBox(height: 15),
            buildTextField(_websiteController, "cprofileinput_input2".tr()),
            const SizedBox(height: 15),
            buildTextField(_descriptionController, "cprofileinput_input3".tr()),
            const SizedBox(height: 15),
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
      title: Text(title, style: const TextStyle(fontSize: 14)),
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
        border: const OutlineInputBorder(),
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
            int nstaff = _selectedCompanySize == "cprofileinput_text3".tr()
                ? 0
                : (_selectedCompanySize == "cprofileinput_text4".tr())
                    ? 1
                    : (_selectedCompanySize == "cprofileinput_text5".tr()
                        ? 2
                        : (_selectedCompanySize == "cprofileinput_text6".tr()
                            ? 3
                            : 4));
            String cname = _companyNameController.text;
            String website = _websiteController.text;
            String description = _descriptionController.text;
            postProfile(cname, nstaff, website, description);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Welcome()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
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
          "cprofileinput_button1".tr(),
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