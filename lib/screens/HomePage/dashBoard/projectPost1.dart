import 'package:flutter/material.dart';
import 'projectPost2.dart';
import '/components/project.dart';

void main() {
  runApp(ProjectPost1());
}

class ProjectPost1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Post'),
        ),
        body: BuildProjectPost1(), // Changed to use PascalCase for class name
      ),
    );
  }
}

class BuildProjectPost1 extends StatefulWidget { // Changed to StatefulWidget
  @override
  _BuildProjectPost1State createState() => _BuildProjectPost1State();
}

class _BuildProjectPost1State extends State<BuildProjectPost1> { // Added State class
  final _titleController = TextEditingController(); // Added controller

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1/4     Let\'s start with a strong title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          IconButton(
            icon: Icon(Icons.info),
            tooltip: 'This helps your post stand out to the right students. It\'s the first thing they\'ll see, so make it impressive!',
            onPressed: () {}, // Add functionality if needed
          ),
          SizedBox(height: 10),
          TextField(
            controller: _titleController, // Assigning controller
            decoration: InputDecoration(
              hintText: 'Write a title for your post',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Example titles',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 16.0), // Apply left padding here
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Build responsive WordPress site with booking/payment functionality'),
                Text('• Facebook ad specialist needed for product launch'),
              ],
            ),
          ),
          SizedBox(height: 20),
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
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => projectPost2()), // Changed to PascalCase
                  );
                },
                child: Text(
                  'Next: Description',
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
    );
  }
}
