import 'package:flutter/material.dart';
import '/components/custom_appbar.dart';
import '/screens/action/welcome.dart';

class CWithoutProfile extends StatefulWidget {
  @override
  _CWithoutProfileState createState() => _CWithoutProfileState();
}

class _CWithoutProfileState extends State<CWithoutProfile> {
  String _selectedCompanySize = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Welcome to Student Hub',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Tell us about your company and you will be on your way connect with high-skilled students',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),
              Text(
                'How many people are in your company?',
                style: TextStyle(fontSize: 16),
              ),
              RadioListTile(
                title: Text('It\'s just me', style: TextStyle(fontSize: 14)),
                value: 'Just me',
                groupValue: _selectedCompanySize,
                onChanged: (value) {
                  setState(() {
                    _selectedCompanySize = value!;
                  });
                },
              ),
              RadioListTile(
                title: Text('2-9 employees', style: TextStyle(fontSize: 14)),
                value: '2-9 employees',
                groupValue: _selectedCompanySize,
                onChanged: (value) {
                  setState(() {
                    _selectedCompanySize = value!;
                  });
                },
              ),
              RadioListTile(
                title: Text('10-99 employees', style: TextStyle(fontSize: 14)),
                value: '10-99 employees',
                groupValue: _selectedCompanySize,
                onChanged: (value) {
                  setState(() {
                    _selectedCompanySize = value!;
                  });
                },
              ),
              RadioListTile(
                title:
                    Text('100-1000 employees', style: TextStyle(fontSize: 14)),
                value: '100-1000 employees',
                groupValue: _selectedCompanySize,
                onChanged: (value) {
                  setState(() {
                    _selectedCompanySize = value!;
                  });
                },
              ),
              RadioListTile(
                title: Text('More than 1000 employees',
                    style: TextStyle(fontSize: 14)),
                value: 'More than 1000 employees',
                groupValue: _selectedCompanySize,
                onChanged: (value) {
                  setState(() {
                    _selectedCompanySize = value!;
                  });
                },
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Company name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Website',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Discription',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Add functionality for the button here
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Welcome()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
