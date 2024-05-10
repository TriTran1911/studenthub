import 'package:flutter/material.dart';
import 'package:studenthub/components/appbar.dart';
import 'package:studenthub/components/controller.dart';
import 'projectPost2.dart';

class ProjectPost1 extends StatefulWidget {
  const ProjectPost1({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProjectPost1State createState() => _ProjectPost1State();
}

class _ProjectPost1State extends State<ProjectPost1> {
  // Added State class
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backWard: false),
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
          const Text(
            '1/4    Let\'s start with a strong title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          const IconButton(
            icon: Icon(Icons.info),
            tooltip:
                'This helps your post stand out to the right students. It\'s the first thing they\'ll see, so make it impressive!',
            onPressed: null,
          ),
          const SizedBox(height: 10),
           TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Write a title for your post',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Example titles',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '• Build responsive WordPress site with booking/payment functionality',
                    style: TextStyle(fontSize: 16)),
                Text('• Facebook ad specialist needed for product launch',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  moveToPage(
                      ProjectPost2(
                        title: _titleController.text,
                      ),
                      context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Next: Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
