import 'package:flutter/material.dart';
import '/components/appbar.dart';

class ProjectPost4 extends StatelessWidget {
  final String title;
  final List<String> descriptionLines; // Changed type to List<String>
  final String selectedDuration;
  final int numberOfStudents;

  ProjectPost4({
    required this.title,
    required this.descriptionLines,
    required this.selectedDuration,
    required this.numberOfStudents,
  });

  @override
  Widget build(BuildContext context) {
    String description = descriptionLines.join('\n'); // Convert list to string

    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildPadding(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your functionality here
        },
        label: Text('Post job', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Padding _buildPadding() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(
            '4/4    Project details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          Divider(height: 17, thickness: 2, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Students are looking for',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          // Use a ListView to display multiple lines of the description
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: descriptionLines.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          descriptionLines[index],
                          style: TextStyle(fontSize: 16)
                          ),
                      ),
                    ],
                  ),
                );
              },
            ),
          SizedBox(height: 16),
          Divider(height: 17, thickness: 2, color: Colors.grey),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.access_time),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project scope',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(selectedDuration, style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.group),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Students required',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(numberOfStudents.toString(), style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
