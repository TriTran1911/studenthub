import 'package:flutter/material.dart';
import '/components/appBar.dart';
import 'projectPost4.dart';

class ProjectPost3 extends StatefulWidget {
  final String title;
  final String selectedDuration;
  final int numberOfStudents;

  ProjectPost3({
    required this.title,
    required this.selectedDuration,
    required this.numberOfStudents,
  });

  @override
  _ProjectPost3State createState() => _ProjectPost3State();
}

class _ProjectPost3State extends State<ProjectPost3> {
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: _buildPadding(context),
      ),
    );
  }

  Padding _buildPadding(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '3/4    Next, provide project description',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            'Students are looking for',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Text(
            '• Clear expectation about your project or deliverables\n'
            '• The skills required for your project\n'
            '• Detail about your project',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
          Text(
            'Describe your project',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Container(
            height: 200.0, // Adjust the height as needed
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _descriptionController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Enter your project description here...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
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
                  List<String> descriptionLines = _descriptionController.text.split('\n');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectPost4(
                        title: widget.title,
                        descriptionLines: descriptionLines,
                        selectedDuration: widget.selectedDuration,
                        numberOfStudents: widget.numberOfStudents,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Review your post',
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
