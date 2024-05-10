import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:studenthub/components/decoration.dart';
import 'package:studenthub/components/modelController.dart';
import 'package:studenthub/screens/HomePage/dashBoard/Function/projectPost1.dart';
import '../../../components/controller.dart';
import '../../../connection/server.dart';

class CDashBoardPage extends StatefulWidget {
  const CDashBoardPage({super.key});

  @override
  State<CDashBoardPage> createState() => _CDashBoardPageState();
}

class _CDashBoardPageState extends State<CDashBoardPage> {
  List<Project> projectList = [];
  List<Project> workingProjectlist = [];
  List<Project> achievedProjectlist = [];
  List<Project> allProjects = [];
  Future<List<Project>>? _projectsFuture;

  @override
  void initState() {
    super.initState();
    getProjects().then((value) {
      if (mounted) {
        setState(() {
          projectList = value;
        });
      }
    });
    _projectsFuture = getProjects();
  }

  Future<List<Project>> getProjects() async {
    int companyId = User.id;

    try {
      var response =
          await Connection.getRequest('/api/project/company/$companyId', {});
      var responseDecode = jsonDecode(response);

      if (responseDecode['result'] != null) {
        print("Connected to the server successfully");
        print(responseDecode['result']);

        List<Project> projectListAPI =
            Project.buildListProject(responseDecode['result']);

        // check statusFlag
        for (Project project in projectListAPI) {
          if (project.typeFlag == 1) {
            workingProjectlist.add(project);
          } else if (project.typeFlag == 2) {
            achievedProjectlist.add(project);
          }
        }

        return projectListAPI;
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildText('Your Projects', 20, FontWeight.bold),
                  ElevatedButton(
                    onPressed: () {
                      moveToPage(ProjectPost1(), context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: buildText(
                        'Post a job', 20, FontWeight.bold, Colors.white),
                  )
                ],
              ),
            ),
            bottom: const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(
                  child: Text('All Projects',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Tab(
                  child: Text('Working',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Tab(
                  child: Text('Achieved',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            )),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: FutureBuilder<List<Project>>(
                future: _projectsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    allProjects = snapshot.data!;
                    projectList = allProjects;
                    return buildCards(projectList);
                  }
                },
              ),
            ),
            buildCards(workingProjectlist),
            buildCards(achievedProjectlist),
          ],
        ),
      ),
    );
  }

  ListView buildCards(List<Project> projectList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projectList.length,
      itemBuilder: (context, index) {
        Project pro = projectList[index];
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
          surfaceTintColor: Colors.blue,
          margin: const EdgeInsets.all(12),
          shadowColor: Colors.blue,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: buildText(
                          pro.createdAt != null
                              ? monthDif(
                                  DateTime.parse(pro.createdAt!.toString()))
                              : '0', // or some default value
                          16,
                          FontWeight.bold,
                          Colors.blue[800]),
                    ),
                    // icon selection
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 30),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  buildBottomSheetItem(context,
                                      "View proposals", Colors.black, () {}),
                                  buildBottomSheetItem(context, "View messages",
                                      Colors.black, () {}),
                                  buildBottomSheetItem(context, "View hired",
                                      Colors.black, () {}),
                                  buildBottomSheetItem(context,
                                      "View job posting", Colors.black, () {}),
                                  buildBottomSheetItem(
                                      context, "Edit posting", Colors.black,
                                      () {
                                    Navigator.pop(context);
                                    showEditDialog(context, pro);
                                  }),
                                  buildBottomSheetItem(context,
                                      "Remove posting", Colors.red, () {}),
                                  buildBottomSheetItem(
                                      context,
                                      "Start working on this project",
                                      Colors.blue,
                                      () {}),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                buildText(pro.title!, 20, FontWeight.bold, Colors.blue),
                const SizedBox(height: 10),
                buildText(
                    pro.description!, 16, FontWeight.normal, Colors.black),
                const SizedBox(height: 10),
                Row(
                  //space between
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          color: Colors.blue,
                        ),
                        buildText(
                            pro.projectScopeFlag == 0
                                ? 'Less than 1 month'
                                : pro.projectScopeFlag == 1
                                    ? '1 to 3 months'
                                    : pro.projectScopeFlag == 2
                                        ? '3 to 6 months'
                                        : 'More than 6 months',
                            14,
                            FontWeight.normal,
                            Colors.black),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          pro.numberOfStudents == 1
                              ? Icons.person_outlined
                              : Icons.people_outlined,
                          color: Colors.blue,
                        ),
                        buildText(
                            pro.numberOfStudents == 1
                                ? '${pro.numberOfStudents} student'
                                : '${pro.numberOfStudents} students',
                            14,
                            FontWeight.normal,
                            Colors.black),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(
                          Icons.assignment,
                          color: Colors.blue,
                        ),
                        buildText(
                            pro.countProposals == 1
                                ? '${pro.countProposals.toString()} proposal'
                                : '${pro.countProposals.toString()} proposals',
                            14,
                            FontWeight.normal,
                            Colors.black),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showEditDialog(BuildContext context, Project project) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    TextEditingController studentController = TextEditingController();

    titleController.text = project.title!;
    descriptionController.text = project.description!;
    durationController.text = project.projectScopeFlag.toString();
    studentController.text = project.numberOfStudents.toString();

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildText('Edit project', 20, FontWeight.bold, Colors.blue),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: buildDecoration('Title'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: buildDecoration('Description'),
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: durationController,
                  decoration: buildDecoration('Duration'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: studentController,
                  decoration: buildDecoration('Number of students'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: buildButtonStyle(Colors.grey[400]!),
                      child: buildText(
                          'Cancel', 16, FontWeight.bold, Colors.white),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: buildButtonStyle(Colors.blue[400]!),
                      child:
                          buildText('Save', 16, FontWeight.bold, Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String monthDif(DateTime? createdAt) {
    final Duration difference = DateTime.now().difference(createdAt!);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      if (difference.inMinutes == 1) {
        return '${difference.inMinutes} minute ago';
      } else {
        return '${difference.inMinutes} minutes ago';
      }
    } else if (difference.inHours < 24) {
      if (difference.inHours == 1) {
        return '${difference.inHours} hour ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inDays < 30) {
      if (difference.inDays == 1) {
        return '${difference.inDays} day ago';
      } else {
        return '${difference.inDays} days ago';
      }
    } else if (difference.inDays < 365) {
      final int months = difference.inDays ~/ 30;
      if (months == 1) {
        return '$months month ago';
      } else {
        return '$months months ago';
      }
    } else {
      final int years = difference.inDays ~/ 365;
      if (years == 1) {
        return '$years year ago';
      } else {
        return '$years years ago';
      }
    }
  }

  Widget buildBottomSheetItem(
      BuildContext context, String text, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        title: buildText(text, 18, FontWeight.bold, color),
        onTap: onTap,
      ),
    );
  }
}
