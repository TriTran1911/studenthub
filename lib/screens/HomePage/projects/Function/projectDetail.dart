import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/controller.dart';
import 'package:studenthub/components/modelController.dart';
import 'package:studenthub/screens/HomePage/tabs.dart';
import '../../../../components/appbar.dart';
import '../../../../components/decoration.dart';
import '../../../../connection/server.dart';
import 'proposalSubmit.dart';

class ProjectDetailPage extends StatefulWidget {
  final Project project;

  const ProjectDetailPage({Key? key, required this.project}) : super(key: key);

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  Future<void> setFavorite(int projectId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? studentId = prefs.getString('studentId');

    var body = {
      'projectId': projectId,
      'disableFlag': widget.project.isFavorite! == false ? 1 : 0,
    };

    try {
      var response = await Connection.patchRequest(
          '/api/favoriteProject/$studentId', body);
      var responseDecode = jsonDecode(response);
      if (responseDecode['result'] != null) {
        print("Connected to the server successfully");
        print(responseDecode['result']);
      } else {
        throw Exception('Failed to load projects');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load projects');
    }
  }

  @override
  Widget build(BuildContext context) {
    Project project = widget.project;
    return Scaffold(
      appBar: const CustomAppBar(backWard: true),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildText('Project Detail', 24, FontWeight.bold, Colors.blue),
                const SizedBox(height: 16),
                buildText('Project Title: ${project.title}', 20,
                    FontWeight.bold, Colors.black),
                const SizedBox(height: 16),
                buildDescription(project),
                const SizedBox(height: 16),
                // show project scope
                buildProjectScope(project),
                const SizedBox(height: 16),
                // show number of students
                buildNumOfStudents(project),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          project.isFavorite = !project.isFavorite!;
                          Connection().setFavorite(project.id!,
                              project.isFavorite! ? 0 : 1, context);
                          moveToPage(TabsPage(index: 0), context);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: project.isFavorite == false
                          ? buildText('Save project', 16, FontWeight.bold,
                              Colors.blueAccent)
                          : buildText('Unsave project', 16, FontWeight.bold,
                              Colors.blueAccent),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        moveToPage(
                            CoverLetterPage(project: project), context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: buildText(
                          'Apply now', 16, FontWeight.bold, Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildNumOfStudents(Project project) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const Icon(Icons.people_outlined, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                    'Number of Students:', 18, FontWeight.bold, Colors.black),
                buildText(
                    project.numberOfStudents == 1
                        ? '${project.numberOfStudents} student'
                        : '${project.numberOfStudents} students',
                    16,
                    FontWeight.normal,
                    Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildProjectScope(Project project) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const Icon(Icons.access_time_outlined, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText('Project Scope:', 18, FontWeight.bold, Colors.black),
                buildText(
                    project.projectScopeFlag == 0
                        ? 'Less than 1 month'
                        : project.projectScopeFlag == 1
                            ? '1 to 3 months'
                            : project.projectScopeFlag == 2
                                ? '3 to 6 months'
                                : 'More than 6 months',
                    16,
                    FontWeight.normal,
                    Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildDescription(Project project) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const Icon(Icons.search, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText('Student are looking for:', 18, FontWeight.bold,
                    Colors.black),
                for (String item in project.description!.split('\n'))
                  buildText('• $item', 16, FontWeight.normal, Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
