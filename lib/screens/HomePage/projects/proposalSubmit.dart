import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/controller.dart';
import 'package:studenthub/screens/HomePage/tabs.dart';
import '../../../components/appbar.dart';
import '../../../components/decoration.dart';
import '../../../components/modelController.dart';
import '../../../connection/server.dart';

// ignore: must_be_immutable
class CoverLetterPage extends StatefulWidget {
  Project project;
  
  CoverLetterPage({super.key, required this.project});

  @override
  State<CoverLetterPage> createState() => _CoverLetterPageState();
}

class _CoverLetterPageState extends State<CoverLetterPage> {
  TextEditingController coverLetterController = TextEditingController();

  Future<void> submitProposal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {
      'projectId': widget.project.id,
      'studentId': prefs.getInt('studentId'),
      'coverLetter': coverLetterController.text,
    };

    var response = await Connection.postRequest('/api/proposal', body);
    if (response != null) {
      print('Proposal submitted');
    } else {
      print('Proposal failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backWard: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText('Cover letter', 24, FontWeight.bold, Colors.blueAccent),
            const SizedBox(height: 16),
            buildText('Describe why do you fit this project', 16, FontWeight.normal),
            const SizedBox(height: 16),
            TextFormField(
              decoration: buildDecoration('Enter your cover letter...'),
              controller: coverLetterController,
              maxLines: 10,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    submitProposal();
                    moveToPage(TabsPage(index: 0), context);
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