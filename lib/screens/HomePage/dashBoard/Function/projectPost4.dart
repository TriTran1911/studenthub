import 'package:flutter/material.dart';
import '/components/appbar.dart';
import '/components/project.dart';
import '/screens/HomePage/tabs.dart';
import '/components/controller.dart';

class ProjectPost4 extends StatefulWidget {
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
  _ProjectPost4State createState() => _ProjectPost4State();
}

class _ProjectPost4State extends State<ProjectPost4> {
  @override
  Widget build(BuildContext context) {
    // Convert list to string

    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildPadding(context),
    );
  }

  Padding _buildPadding(BuildContext context) {
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
            widget.title,
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
            itemCount: widget.descriptionLines.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
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
                      child: Text(widget.descriptionLines[index],
                          style: TextStyle(fontSize: 16)),
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
                  Text(widget.selectedDuration, style: TextStyle(fontSize: 16)),
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
                  Text(widget.numberOfStudents.toString(),
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
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
                  Project.addProject(
                    Project(
                      widget.title,
                      widget.selectedDuration == '1-3 months'
                          ? ProjectDuration.oneToThreeMonths
                          : ProjectDuration.threeToSixMonths,
                      widget.descriptionLines,
                      'Open',
                      DateTime.now(),
                      studentsNeeded: widget.numberOfStudents,
                    ),
                  );
                  navigateToPage(TabsPage(index: 1), context);
                },
                child: Text(
                  'Post job',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
