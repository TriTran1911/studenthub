import 'package:flutter/material.dart';
import '../../components/appbar.dart';

class CompanyProfile extends StatefulWidget {
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
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildCenterText('Welcome to Student Hub', 24, FontWeight.bold),
              SizedBox(height: 15),
              buildTextField('Company name'),
              SizedBox(height: 15),
              buildTextField('Website'),
              SizedBox(height: 15),
              buildTextField('Discription'),
              SizedBox(height: 15),
              buildText('How many people are in your company?', 16),
              buildRadioListTile(),
              SizedBox(height: 15),
              buildActionButtons(),
            ],
          ),
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

  Widget buildTextField(String labelText) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
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
      title: Text('It\'s just me', style: TextStyle(fontSize: 14)),
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
          buildButton('Edit', () {
            setState(() {

            });
          }),
          SizedBox(width: 16),
          buildButton('Cancel', () {
            setState(() {

            });
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
