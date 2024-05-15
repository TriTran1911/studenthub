import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/decoration.dart';
import '../../components/modelController.dart';
import '../../connection/server.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  Student student = Student();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    getStudent();
    getResume().then((value) {
      setState(() {
        resumeUrl = value;
      });
    });
    print('Resume URL: $resumeUrl');
    getTranscript().then((value) {
      setState(() {
        transcriptUrl = value;
      });
    });
  }

  Future<Student> getStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? studentId = prefs.getInt('studentId');
    print('Student ID: $studentId');

    try {
      var response =
          await Connection.getRequest('/api/profile/student/$studentId', {});
      var responseDecode = jsonDecode(response);

      if (responseDecode['result'] != null) {
        print(responseDecode['result']);
        print('Student profile loaded');
        student = Student.formStudentInfo(responseDecode['result']);
        return student;
      } else {
        print('Failed to load student profile..');
        return Student();
      }
    } catch (e) {
      print('Failed to load student profile $e');
      return Student();
    }
  }

  String resumeUrl = '';
  String transcriptUrl = '';

  Future<String> getResume() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? studentId = prefs.getInt('studentId');
    print('Student ID: $studentId');

    var response = await Connection.getRequest(
        '/api/profile/student/$studentId/resume', {});
    var responseDecode = jsonDecode(response);

    return responseDecode['result'];
  }

  Future<String> getTranscript() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? studentId = prefs.getInt('studentId');
    print('Student ID: $studentId');

    var response = await Connection.getRequest(
        '/api/profile/student/$studentId/transcript', {});
    var responseDecode = jsonDecode(response);

    return responseDecode['result'];
  }

  void _launchUrl(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backWard: true),
      body: FutureBuilder<Student>(
        future: getStudent(),
        builder: (BuildContext context, AsyncSnapshot<Student> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            student = snapshot.data!;
            if (student.fullname == null) {
              return const Center(
                child: Text('No data found'),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildCenterText(
                          'Your profile', 24, FontWeight.bold, Colors.blue),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          buildText('Name: ', 20, FontWeight.bold),
                          buildText(student.fullname!, 20, FontWeight.normal),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          buildText('Email: ', 20, FontWeight.bold),
                          const SizedBox(height: 16),
                          Flexible(
                            child: buildText(
                                student.email!, 20, FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          buildText('Resume/CV: ', 20, FontWeight.bold),
                          InkWell(
                            onTap: () => _launchUrl(Uri.parse(resumeUrl)),
                            child: const Text(
                              'View Resume/CV',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          buildText('Transcript: ', 20, FontWeight.bold),
                          InkWell(
                            onTap: () => _launchUrl(Uri.parse(transcriptUrl)),
                            child: const Text(
                              'View Transcript',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          buildText('Tectstack: ', 20, FontWeight.bold),
                          buildText(
                              student.techStack!.name!, 20, FontWeight.normal),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8.0, // Space between adjacent children
                        runSpacing: 8.0, // Space between lines
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: buildText(
                              'Skillset:',
                              20,
                              FontWeight.bold,
                            ),
                          ),
                          for (var skill in student.skillSets!) ...[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: buildText(
                                skill.name!,
                                20,
                                FontWeight.normal,
                                Colors.blueAccent,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (student.languages!.isNotEmpty) ...[
                        buildText('Language: ', 20, FontWeight.bold),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(
                              16.0), // Increased padding for more space
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: student.languages!.map((language) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: buildText(
                                          language.languageName!,
                                          20,
                                          FontWeight.normal,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          // switch the color depending on the 4 levels
                                          color: language.level == 'Beginner'
                                              ? Colors.green[100]
                                              : language.level == 'Intermediate'
                                                  ? Colors.yellow[100]
                                                  : language.level == 'Advanced'
                                                      ? Colors.orange[100]
                                                      : Colors.red[100],
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: buildText(language.level!, 20,
                                            FontWeight.normal, Colors.black),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height:
                                          8.0), // Add space between each row
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (student.educations!.isNotEmpty) ...[
                        buildText('Education: ', 20, FontWeight.bold),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Aligning text to the start
                            children: student.educations!.map((education) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0), // Space between rows
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: buildText(
                                        education.schoolName!,
                                        20,
                                        FontWeight.normal,
                                      ),
                                    ),
                                    buildText(
                                      '${education.startYear} - ${education.endYear}',
                                      20,
                                      FontWeight.normal,
                                      Colors.black,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (student.experiences!.isNotEmpty) ...[
                        buildText('Experience: ', 20, FontWeight.bold),
                        const SizedBox(height: 16),
                        for (var experience in student.experiences!) ...[
                          Container(
                            padding: const EdgeInsets.all(
                                16.0), // Increased padding for more space
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color
                              border: Border.all(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildText(
                                  'Project name: ${experience.title!}',
                                  20,
                                  FontWeight.bold,
                                ),
                                buildText(
                                  'Duration: ${experience.startMonth!} - ${experience.endMonth}',
                                  20,
                                  FontWeight.normal,
                                  Colors.grey[600],
                                ),
                                buildText(
                                  'Description:',
                                  20,
                                  FontWeight.normal,
                                  Colors.grey[700],
                                ),
                                buildText(
                                  addBulletPoints(experience.description!),
                                  20,
                                  FontWeight.normal,
                                  Colors.grey[700],
                                ),
                                Wrap(
                                  spacing:
                                      8.0, // Space between adjacent children
                                  runSpacing: 8.0, // Space between lines
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0, top: 8.0),
                                      child: buildText(
                                        'Skillset:',
                                        20,
                                        FontWeight.bold,
                                      ),
                                    ),
                                    for (var skill in experience.skillSets!) ...[
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: buildText(
                                          skill.name!,
                                          20,
                                          FontWeight.normal,
                                          Colors.blueAccent,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                      const SizedBox(height: 16),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isEditing)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEditing = !isEditing;
                              });
                            },
                            style: buildButtonStyle(Colors.grey),
                            child: buildText(
                                'Cancel', 18, FontWeight.bold, Colors.white),
                          ),
                        if (isEditing) const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (isEditing) {
                              

                            }
                            setState(() {
                              isEditing = !isEditing;
                            });
                          },
                          style: buildButtonStyle(Colors.blue),
                          child: buildText(isEditing ? "Save" : "Edit", 18,
                              FontWeight.bold, Colors.white),
                        ),
                      ],
                    ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
