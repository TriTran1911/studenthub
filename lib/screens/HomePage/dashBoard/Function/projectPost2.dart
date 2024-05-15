import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/components/controller.dart';
import '/components/appbar.dart';
import 'projectPost3.dart';

class ProjectPost2 extends StatefulWidget {
  final String title;

  ProjectPost2({required this.title});

  @override
  _ProjectPost2State createState() => _ProjectPost2State();
}

class _ProjectPost2State extends State<ProjectPost2> {
  int selectedDuration = 0;
  int numberOfStudents = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backWard: true),
      body: SingleChildScrollView(
        child: _buildPadding(context),
      ),
    );
  }

  Padding _buildPadding(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '2/4    Next, estimate the scope of your job',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Consider the size of your project and the timeline',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          Text('How long will your project take?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          RadioListTile(
            title: Text(tr("project_text2")),
            value: 0,
            groupValue: selectedDuration,
            onChanged: (value) {
              setState(() {
                selectedDuration = value!;
              });
            },
          ),
          RadioListTile(
            title: Text(tr("project_text3")),
            value: 1,
            groupValue: selectedDuration,
            onChanged: (value) {
              setState(() {
                selectedDuration = value!;
              });
            },
          ),
          RadioListTile(
            title: Text(tr("project_text4")),
            value: 2,
            groupValue: selectedDuration,
            onChanged: (value) {
              setState(() {
                selectedDuration = value!;
              });
            },
          ),
          RadioListTile(
            title: Text('6 to 12 months'),
            value: 3,
            groupValue: selectedDuration,
            onChanged: (value) {
              setState(() {
                selectedDuration = value!;
              });
            },
          ),
          SizedBox(height: 16),
          Text('How many students do you want for this project?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                numberOfStudents = int.tryParse(value) ?? 0;
              });
            },
            decoration: InputDecoration(
              hintText: 'Number of students',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          Container(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  moveToPage(
                      ProjectPost3(
                        selectedDuration: selectedDuration,
                        numberOfStudents: numberOfStudents,
                        title: widget.title,
                      ),
                      context);
                },
                child: Text(
                  'Next: Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
