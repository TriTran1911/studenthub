import 'package:flutter/material.dart';
import 'package:studenthub/components/appbar.dart';
import 'projectPost2.dart';

class ProjectPost1 extends StatefulWidget {
  @override
  _ProjectPost1State createState() => _ProjectPost1State();
}

class _ProjectPost1State extends State<ProjectPost1> {
  // Added State class
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: _buildPadding(context),
        ),
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
            '1/4    Let\'s start with a strong title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          IconButton(
            icon: Icon(Icons.info),
            tooltip:
                'This helps your post stand out to the right students. It\'s the first thing they\'ll see, so make it impressive!',
            onPressed: () {},
          ),
          SizedBox(height: 10),
          TextField(
            controller: _titleController,
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
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Build responsive WordPress site with booking/payment functionality', 
                    style: TextStyle(fontSize: 16)),
                Text('• Facebook ad specialist needed for product launch',
                  style: TextStyle(fontSize: 16)),
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectPost2(
                          title: _titleController.text,
                        ),
                      ),
                    );
                },
                child: Text(
                  'Next: Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
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
