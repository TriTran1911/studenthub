import 'package:flutter/material.dart';
import '/components/project.dart';

class DetailTab extends StatelessWidget {
  final Project project;

  DetailTab({required this.project});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Divider(color: Colors.grey, height: 1),
        SizedBox(height: 16),
        Text(
          'Students are looking for:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (project.description ?? '')
              .split('\n')
              .map(
                (descriptionItem) => Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text('• $descriptionItem'),
                ),
              )
              .toList(),
        ),

        SizedBox(height: 16),
        Divider(color: Colors.grey, height: 1),
        SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.alarm_on_sharp, size: 40),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Project scope: '),
                Text(
                    '\t\t\t• ${project.getProjectScopeAsString()}'),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.people_alt_rounded, size: 40),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Student required: \n\t\t\t• ${project.numberOfStudents} students'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
