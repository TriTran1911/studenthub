import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Post'),
        ),
        body: ProjectsPage(),
      ),
    );
  }
}

class ProjectsPage extends StatelessWidget {
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
            tooltip:
                'This helps your post stand out to the right students. It\'s the first thing they\'ll see, so make it impressive!',
            onPressed: () {}, // Add functionality if needed
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: 'Write a title for your post',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16.0), // Add left padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Example titles',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                    '• Build responsive WordPress site with booking/payment functionality'),
                Text('• Facebook ad specialist needed for product launch'),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to next page or perform action
            },
            child: Text('Next: Scope'),
          ),
        ],
      ),
    );
  }
}
