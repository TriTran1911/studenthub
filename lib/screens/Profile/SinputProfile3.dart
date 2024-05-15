import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/appbar.dart';
import 'package:studenthub/components/decoration.dart';

import '../../components/controller.dart';
import '../../components/modelController.dart';
import '../../connection/server.dart';
import '../HomePage/tabs.dart';

class StudentInputProfile3 extends StatefulWidget {
  const StudentInputProfile3({super.key});

  @override
  State<StudentInputProfile3> createState() => _StudentInputProfile3State();
}

class _StudentInputProfile3State extends State<StudentInputProfile3> {
  File? _cvFile;
  PlatformFile? _cvPlatformFile;
  File? _transcriptFile;
  PlatformFile? _transcriptPlatformFile;
  DropzoneViewController? _dropzoneController;
  FileCV? fileCV;

  Future<void> _selectCvFile() async {
    if (kIsWeb) {
      final events = await _dropzoneController!.pickFiles();
      if (events.isEmpty) return;

      final file = events.first;
      setState(() {
        _cvFile = File(file.path!);
        _cvPlatformFile = PlatformFile(
          name: file.name,
          size: file.size,
          //get path of file
          path: file.path,
        );
      });
    } else {
      // Mobile: Use File Picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'], // Example file types
      );
      if (result == null) return;

      final file = File(result.files.single.path!);
      setState(() {
        _cvFile = file;

        print("PATH: ${file.path}");
        _cvPlatformFile = result.files.first;
      });
    }
  }

  Future<void> _selectTranscriptFile() async {
    if (kIsWeb) {
      // Web: Use Drag and Drop
      final events = await _dropzoneController!.pickFiles();
      if (events.isEmpty) return;

      final file = events.first;
      setState(() {
        _transcriptFile = File(file.path!);
        _transcriptPlatformFile = PlatformFile(
          name: file.name,
          size: file.size,
        );
      });
    } else {
      // Mobile: Use File Picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'], // Example file types
      );
      if (result == null) return;

      final file = File(result.files.single.path!);
      setState(() {
        _transcriptFile = file;

        print("PATH: ${file.path}");
        _transcriptPlatformFile = result.files.first;
      });
    }
  }

  Future<void> putFileCv(FileCV fileCV) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? studentId = prefs.getInt('studentId');

    print('Student ID: $studentId');

    try {
      if (fileCV.resume != null) {
        await Connection.putFile(
            '/api/profile/student/$studentId/resume', fileCV.resume.toString());
      }
      if (fileCV.transcript != null) {
        await Connection.putFile(
            '/api/profile/student/$studentId/transcript', fileCV.transcript.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backWard: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildCenterText(
                  'CV & Transcript', 24, FontWeight.bold, Colors.blue),
              const SizedBox(height: 16),
              buildCenterText(
                  'Tell us about your self and you will be on your way connect with real-world project',
                  16,
                  FontWeight.normal),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildText('Resume/CV', 20, FontWeight.bold, Colors.blue),
                  buildText('(*)', 20, FontWeight.normal, Colors.red),
                ],
              ),
              const SizedBox(height: 10),
              if (!kIsWeb)
                if (_cvFile != null)
                  buildUploadArea(
                      title: 'Selected CV File: ${_cvPlatformFile!.name}',
                      onTap: _selectCvFile)
                else
                  buildUploadArea(
                      title:
                          'Drag & drop your Resume/CV here or select your file',
                      onTap: _selectCvFile), // Call with _selectCvFile

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildText('Transcript', 20, FontWeight.bold, Colors.blue),
                  buildText('(*)', 20, FontWeight.normal, Colors.red),
                ],
              ),
              const SizedBox(height: 16),
              if (!kIsWeb)
                if (_transcriptFile != null)
                  buildUploadArea(
                      title:
                          'Selected Transcript File: ${_transcriptPlatformFile!.name}',
                      onTap: _selectTranscriptFile)
                else
                  buildUploadArea(
                      title:
                          'Drag & drop your Transcript here or select your file',
                      onTap:
                          _selectTranscriptFile), // Call with _selectTranscriptFile

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      modelController.user.roles.add(0);
                      fileCV = FileCV(
                        transcript: _transcriptPlatformFile?.path,
                        resume: _cvPlatformFile?.path,
                      );
                      putFileCv(fileCV!);
                      appBarIcon.isSelected = !appBarIcon.isSelected;
                      moveToPage(const TabsPage(index: 0), context);
                    },
                    style: buildButtonStyle(Colors.blue[400]!),
                    child: buildText('Next', 16, FontWeight.bold, Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUploadArea({required String title, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Stack(
          children: [
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              strokeWidth: 2,
              color: Colors.blue,
              dashPattern: const [8, 4],
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 80, 15, 0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: 20,
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'images/file.png',
                  width: 100,
                  height: 100,
                  colorBlendMode: BlendMode.srcOver,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileCV {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? userId;
  int? techStackId;
  String? resume;
  String? transcript;

  FileCV({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userId,
    this.techStackId,
    this.resume,
    this.transcript,
  });

  Map<String, dynamic> toMapFileResume() {
    return {
      'id': null,
      'resume': resume,
    };
  }

  Map<String, dynamic> toMapFileTranscript() {
    return {
      'id': null,
      'transcript': transcript,
    };
  }

  factory FileCV.fromMapFileCV(Map<String, dynamic> map) {
    return FileCV(
      id: map['id'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
      userId: map['userId'],
      techStackId: map['techStackId'],
      resume: map['resume'],
      transcript: map['transcript'],
    );
  }

  static fromListMap(List<Map<String, dynamic>> fileCVs) {
    return fileCVs.map((e) => FileCV.fromMapFileCV(e)).toList();
  }
}
