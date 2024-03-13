import 'package:flutter/material.dart';
import '/components/project.dart';
import '/components/appbar.dart';

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  const ProjectDetailPage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: TextStyle(fontSize: 24, color: Colors.green),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Duration: ${project.duration == ProjectDuration.oneToThreeMonths ? '1 to 3 months' : '3 to 6 months'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Status: ${project.status}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Created: ${DateTime.now().difference(project.creationDate).inDays} days ago',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Divider(), // Horizontal line
                    SizedBox(height: 8),
                    Text(
                      'Description:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: project.description
                          .map((descriptionItem) => Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text('• $descriptionItem'),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 8),
                    Divider(), // Horizontal line
                    SizedBox(height: 8),
                    Text(
                      'Proposals: ${project.proposals}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Messages: ${project.messages}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Hired: ${project.hiredCount}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Students Needed: ${project.studentsNeeded}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    
                    Text(
                      'Time Needed: ${project.timeNeeded}',
                      style: TextStyle(fontSize: 16),
                    ),
                    
                  ],
                ),
              ),
              SizedBox(height: 180),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Apply Now button pressed
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                            ),
                          ),
                        ),
                        child: Text(
                          'Apply Now',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Saved button pressed
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                            ),
                          ),
                        ),
                        child: Text(
                          'Saved',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
