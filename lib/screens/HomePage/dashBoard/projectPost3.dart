import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: projectPost3(),
    );
  }
}
class projectPost3 extends StatefulWidget {
  @override
  _projectPost3State createState() => _projectPost3State();
}

class _projectPost3State extends State<projectPost3> {
  TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Post 3'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3/4 Next, provide project description',
              style: TextStyle(fontSize: 16.0),
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
                  String description = _descriptionController.text;
                  print('Project Description: $description');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => projectPost3()),
                  );
                },
                child: Text(
                  'Review your post',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
