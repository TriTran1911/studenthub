import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../../components/appbar.dart';
import '../HomePage/tabs.dart';
import '../../components/controller.dart';

class StudentProfile extends StatefulWidget {
  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  String cvPath = '';
  String cvFileName = '';
  String transcriptPath = '';
  String transcriptFileName = '';

  Future<void> _pickFile(String fileType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          if (fileType == 'CV') {
            cvPath = result.files.single.path!;
            cvFileName = result.files.single.name;
          } else if (fileType == 'Transcript') {
            transcriptPath = result.files.single.path!;
            transcriptFileName = result.files.single.name;
          }
        });
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
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
          children: [
            Center(
              child: Text(
                'CV & Transcript',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Tell us about yourself, and you will be on your way to connect with a real-world project',
            ),
            SizedBox(height: 16.0),
            Text('Resume/CV (*)'),
            _buildFilePickerContainer('CV', cvPath, cvFileName),
            SizedBox(height: 16.0),
            Text('Transcript'),
            _buildFilePickerContainer(
                'Transcript', transcriptPath, transcriptFileName),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                navigateToPagePushReplacement(TabsPage(index: 0), context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePickerContainer(
      String fileType, String filePath, String fileName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 100.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _pickFile(fileType),
                  child: Text(filePath.isEmpty
                      ? 'Choose File or Drag File In'
                      : 'Change File'),
                ),
                SizedBox(height: 8.0),
                if (filePath.isNotEmpty) Text(fileName), // Display filename
              ],
            ),
          ),
        ),
      ],
    );
  }
}
