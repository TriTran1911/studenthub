import 'package:flutter/material.dart';
import 'package:studenthub/components/appbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studenthub/components/controller.dart';
import 'package:studenthub/components/keyword.dart';
import 'package:studenthub/screens/HomePage/tabs.dart';

class StudentInputProfile3 extends StatefulWidget {
  const StudentInputProfile3({super.key});

  @override
  State<StudentInputProfile3> createState() => _StudentInputProfile3State();
}

class _StudentInputProfile3State extends State<StudentInputProfile3> {
  FilePickerResult? resume;
  FilePickerResult? transcript;

  Future<void> pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        if (type == 'resume') {
          resume = result;
        } else if (type == 'transcript') {
          transcript = result;
        }
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildCenterText('CV & Transcript', 20, FontWeight.bold),
            const SizedBox(height: 16),
            buildCenterText(
                'Tell us about your self and you will be on your way connect with real-world project',
                16,
                FontWeight.normal),
            const SizedBox(height: 16),
            buildText('Resume', 20, FontWeight.bold),
            const SizedBox(height: 16),
            buildFilePickerContainer('resume', resume),
            const SizedBox(height: 16),
            buildText('Transcript', 20, FontWeight.bold),
            const SizedBox(height: 16),
            buildFilePickerContainer('transcript', transcript),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          moveToPage(TabsPage(index: 0), context);
        },
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: buildText('Next', 16, FontWeight.bold),
      ),
    );
  }

  Widget buildFilePickerContainer(String type, FilePickerResult? file) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: buildCenterText(
                        file != null ? file.files.single.name : 'No file chosen',
                        16,
                        FontWeight.normal),
                  ),
                  IconButton(
                    icon: const Icon(Icons.upload_file),
                    onPressed: () {
                      pickFile(type);
                    },
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
