import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/appbar.dart';

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
  bool isEditting = false;

  @override
  void initState() {
    super.initState();
    getStudent();
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
      print('Failed to load student profile');
      return Student();
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
                          child:
                              buildText(student.email!, 20, FontWeight.normal),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        buildText('Skillset: ', 20, FontWeight.bold),
                        //show skillset
                        Flexible(
                          child: buildText(
                              student.skillSets!.map((e) => e.name).join(', '),
                              20,
                              FontWeight.normal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (student.languages!.isNotEmpty) ...[
                      buildText('Language: ', 20, FontWeight.bold),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: student.languages!.map((language) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(15.0),
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
                                    // switch the color denpend on the 4 level
                                    color: language.level == 'Beginner'
                                        ? Colors.green[100]
                                        : language.level == 'Intermediate'
                                            ? Colors.yellow[100]
                                            : language.level == 'Advanced'
                                                ? Colors.orange[100]
                                                : Colors.red[100],
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: buildText(language.level!, 20,
                                      FontWeight.normal, Colors.black),
                                ),
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
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: student.educations!.map((education) {
                            return buildText(
                              '${education.schoolName} from ${education.startYear} to ${education.endYear}',
                              20,
                              FontWeight.normal,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    if (student.experiences!.isNotEmpty) ...[
                      buildText('Experience: ', 20, FontWeight.bold),
                      // return experience as a card
                      const SizedBox(height: 16),
                      for (var experience in student.experiences!) ...[
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
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
                                Colors.grey[400],
                              ),
                              buildText(
                                'Description: ${experience.description!}',
                                20,
                                FontWeight.normal,
                                Colors.grey[700],
                              ),
                              Row(
                                children: [
                                  buildText('Skillset:', 20, FontWeight.bold),
                                  const SizedBox(width: 8),
                                  for (var skill in student.skillSets!) ...[
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[100],
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: buildText(skill.name!, 20,
                                          FontWeight.normal, Colors.blueAccent),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          setState(() {
            isEditting = !isEditting;
          });
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
