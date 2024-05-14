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
    return FutureBuilder<Student>(
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
          return Scaffold(
            appBar: const CustomAppBar(backWard: true),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    buildCenterText(
                        'Your profile', 24, FontWeight.bold, Colors.blue),
                    const SizedBox(height: 16),
                    Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildText('Name: ', 20, FontWeight.bold),
            Flexible(
              child: buildText(student.fullname!, 20, FontWeight.normal),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildText('Email: ', 20, FontWeight.bold),
            const SizedBox(height: 16),
            Flexible(
              child: buildText(student.email! + 'aaaaaaaaaaaa', 20, FontWeight.normal),
            ),
          ],
        ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
