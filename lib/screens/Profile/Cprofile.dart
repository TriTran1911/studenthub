import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../components/appbar.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  _CompanyProfileState createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  bool isJustMeSelected = true;

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: const CustomAppBar(backWard: false),
      resizeToAvoidBottomInset: true,
      body: _buildSingleChildScrollView(),
    );
  }

  SingleChildScrollView _buildSingleChildScrollView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildCenterText("proifle_title1".tr(), 24, FontWeight.bold),
            const SizedBox(height: 15),
            buildText("cprofileinput_input1".tr(), 16),
            const SizedBox(height: 15),
            buildTextField("cprofileinput_input1".tr(), 1),
            const SizedBox(height: 15),
            buildText("cprofileinput_input2".tr(), 16),
            const SizedBox(height: 15),
            buildTextField("cprofileinput_input2".tr(), 1),
            const SizedBox(height: 15),
            buildText("cprofileinput_input3".tr(), 16),
            const SizedBox(height: 15),
            buildTextField("cprofileinput_input3".tr(), 3),
            const SizedBox(height: 15),
            buildText("cprofileinput_text2".tr(), 16),
            buildRadioListTile(),
            const SizedBox(height: 15),
            buildActionButtons(),
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

  Widget buildTextField(String labelText, int maxLines) {
    return Container(
      height: 50 * maxLines.toDouble(),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: labelText,
          ),
        ),
      ),
    );
  }

  Widget buildText(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }

  Widget buildRadioListTile() {
    return RadioListTile(
      title: Text("cprofileinput_text3".tr(), style: TextStyle(fontSize: 14)),
      value: 'Just me',
      groupValue: isJustMeSelected ? 'Just me' : null,
      onChanged: isJustMeSelected
          ? null
          : (value) {
              setState(() {});
            },
    );
  }

  Widget buildActionButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildButton("cprofile_button1".tr(), () {
            setState(() {});
          }),
          SizedBox(width: 16),
          buildButton("cprofile_button2".tr(), () {
            setState(() {});
          }),
        ],
      ),
    );
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: Text(text),
      ),
    );
  }
}
