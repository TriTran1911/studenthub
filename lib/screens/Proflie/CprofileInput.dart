import 'package:flutter/material.dart';
import '/components/custom_appbar.dart';

class ProfileInputScreen extends StatefulWidget {
  @override
  _ProfileInputScreenState createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  bool isJustMeSelected = true;

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
              Text(
                'How many people are in your company?',
                style: TextStyle(fontSize: 16),
              ),
              RadioListTile(
                title: Text('It\'s just me', style: TextStyle(fontSize: 14)),
                value: 'Just me',
                groupValue: isJustMeSelected ? 'Just me' : null,
                onChanged: isJustMeSelected
                    ? null // Không có hành động khi người dùng cố gắng thay đổi giá trị
                    : (value) {
                        setState(() {
                        });
                      },
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Align buttons to the end (right)
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Add functionality for the 'Edit' button here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueGrey, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.0), // Border radius
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12), // Button padding
                        ),
                        child: Text('Edit'),
                      ),
                    ),
                    SizedBox(width: 16), // Add some space between the buttons
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Add functionality for the 'Cancel' button here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueGrey, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.0), // Border radius
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12), // Button padding
                        ),
                        child: Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
