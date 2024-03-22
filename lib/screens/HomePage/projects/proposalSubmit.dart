import 'package:flutter/material.dart';
import '/components/appbar.dart';
import '/components/project.dart';

class CoverLetterPage extends StatelessWidget {
  final Project project;

  const CoverLetterPage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cover letter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Describe why do you fit this project',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Container(
              height: 200, 
              child: TextFormField(
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top, 
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your cover letter...',
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _sendCoverLetter(context);
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendCoverLetter(BuildContext context) {
    if (!SubmittedProjects().isProjectSubmitted(project)) {
      DateTime sentTime = DateTime.now();
      SubmittedProjects().addSubmittedProject(project, sentTime, "Submitted");
    }
    Navigator.pop(context);
  }
}