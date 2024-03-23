import 'package:flutter/material.dart';
import '/components/appbar.dart';
import '/components/project.dart';
import '/components/notifications.dart';
import 'package:intl/intl.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _sendCoverLetter(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
                  ),
                  child: Text('Send',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
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
    notifications.add({
      'type': 'You have submitted to join project '+ project.title,
      'icon': Icons.assignment_turned_in,
      'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
    	});
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
