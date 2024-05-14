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
              backgroundColor: Colors.blue,
              color: Colors.white,
            ));
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
                      student.languages!.length == 1
                          ? buildText('Language: ', 20, FontWeight.bold)
                          : buildText('Languages: ', 20, FontWeight.bold),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (var language in student.languages!) ...[
                              buildText(
                                language.languageName!,
                                20,
                                FontWeight.normal,
                              ),
                              buildText(
                                language.level!,
                                20,
                                FontWeight.normal,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    if (student.educations!.isNotEmpty) ...[
                      student.educations!.length == 1
                          ? buildText('Education: ', 20, FontWeight.bold)
                          : buildText('Educations: ', 20, FontWeight.bold),
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
                      student.experiences!.length == 1
                          ? buildText('Experience: ', 20, FontWeight.bold)
                          : buildText('Experiences: ', 20, FontWeight.bold),
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
                            children: [
                              buildText(
                                '${experience.title} as ${experience.description} from ${experience.startMonth} to ${experience.endMonth}',
                                20,
                                FontWeight.normal,
                              ),
                              buildText(
                                experience.description!,
                                20,
                                FontWeight.normal,
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
    );
  }
}
