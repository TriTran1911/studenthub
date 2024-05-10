import 'package:flutter/material.dart';
import 'package:studenthub/components/decoration.dart';
import '/components/appbar.dart';
import '/components/modelController.dart';

class CoverLetterPage extends StatelessWidget {
  final Project project;

  const CoverLetterPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backWard: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText('Cover letter', 24, FontWeight.bold, Colors.blueAccent),
            const SizedBox(height: 16),
            buildText('Describe why do you fit this project', 16, FontWeight.normal),
            const SizedBox(height: 16),
            TextFormField(
              decoration: buildDecoration('Enter your cover letter...'),
              maxLines: 10,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: buildButtonStyle(Colors.blue),
                  child: buildText('Submit', 16, FontWeight.bold, Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
