import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/decoration.dart';
import 'package:studenthub/components/modelController.dart';
import 'package:studenthub/screens/HomePage/dashBoard/Function/projectPost1.dart';
import 'package:studenthub/screens/HomePage/tabs.dart';
import '../../../components/controller.dart';
import '../../../connection/server.dart';
import 'Function/companyProjectDetail.dart';

class CompanyDashboardPage extends StatefulWidget {
  const CompanyDashboardPage({super.key});

  @override
  State<CompanyDashboardPage> createState() => _CompanyDashboardPageState();
}

class _CompanyDashboardPageState extends State<CompanyDashboardPage> {
  List<Project> newProjectList = [];
  List<Project> workingProjectList = [];
  List<Project> achievedProjectList = [];
  List<Project> allProjects = [];
  Future<List<Project>>? _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = getProjects();
  }

  Future<List<Project>> getProjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? companyId = prefs.getInt('companyId');
    print('Company ID: $companyId');

    try {
      var response =
          await Connection.getRequest('/api/project/company/$companyId', {});
      var responseDecode = jsonDecode(response);

      if (responseDecode['result'] != null) {
        print("Connected to the server successfully");
        print(responseDecode['result']);

        List<Project> projectListAPI =
            Project.buildListProject(responseDecode['result']);

        for (Project project in projectListAPI) {
          if (project.typeFlag == 0) {
            newProjectList.add(project);
          } else if (project.typeFlag == 1) {
            workingProjectList.add(project);
          } else if (project.typeFlag == 2) {
            achievedProjectList.add(project);
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

  Future<void> editProject(Project project) async {
    try {
      var body = {
        'title': project.title,
        'description': project.description,
        'projectScopeFlag': project.projectScopeFlag,
        'numberOfStudents': project.numberOfStudents,
        'typeFlag': project.typeFlag,
      };

      var response =
          await Connection.patchRequest('/api/project/${project.id}', body);
      var responseDecode = jsonDecode(response);

      if (responseDecode != null) {
        print("Edit project successfully");
        print(responseDecode);
      } else {
        throw Exception('Failed to edit project');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to edit project');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: TabBarView(
          children: [
            buildTabBarView(newProjectList),
            buildTabBarView(workingProjectList),
            buildTabBarView(achievedProjectList),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<Project>> buildTabBarView(List<Project> ProjectList) {
    return FutureBuilder<List<Project>>(
      future: _projectsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return buildCards(ProjectList);
        }
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildText("project_text21".tr(), 20, FontWeight.bold),
              ElevatedButton(
                onPressed: () {
                  moveToPage(const ProjectPost1(), context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: buildText(
                    "project_text22".tr(), 20, FontWeight.bold, Colors.white),
              )
            ],
          ),
        ),
        bottom: TabBar(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(
              child: Text("project_text7".tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Tab(
              child: Text("project_text19".tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Tab(
              child: Text("project_text20".tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ));
  }

  ListView buildCards(List<Project> projectList) {
    if (projectList.isEmpty) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          Center(
            child: buildText("project_text23".tr(), 16, FontWeight.bold),
          ),
        ],
      );
    } else {
      return ListView.builder(
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
                                ? timeDif(
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
                                    buildBottomSheetItem(
                                        context,
                                        "project_text24".tr(),
                                        Colors.black, () {
                                      Navigator.pop(context);
                                      moveToPage(
                                          ProjectDetailPage(project: pro),
                                          context);
                                    }),
                                    buildBottomSheetItem(
                                        context,
                                        "project_text25".tr(),
                                        Colors.black, () {
                                      Navigator.pop(context);
                                      showEditDialog(context, pro);
                                    }),
                                    buildBottomSheetItem(context,
                                        "project_text26".tr(), Colors.red, () {
                                      Navigator.pop(context);
                                      showDeleteDialog(context, pro);
                                    }),
                                    buildBottomSheetItem(context,
                                        "project_text27".tr(), Colors.blue, () {
                                      Navigator.pop(context);
                                      showConfirmationDialog(context, pro);
                                    }),
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
                                  ? tr("project_text2")
                                  : pro.projectScopeFlag == 1
                                      ? tr("project_text3")
                                      : pro.projectScopeFlag == 2
                                          ? tr("project_text4")
                                          : tr("project_text5"),
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
                              pro.numberOfStudents == 1 || pro.numberOfStudents == 0
                                  ? '${pro.numberOfStudents} ' + tr('project_text13')
                                  : '${pro.numberOfStudents} ' + tr('project_text14'),
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
                              pro.countProposals == 1 || pro.countProposals == 0
                                  ? '${pro.countProposals.toString()} ' + tr('project_text11')
                                  : '${pro.countProposals.toString()} ' + tr('project_text12'),
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
  }

  // reconfirm to delete
  Future<void> showDeleteDialog(BuildContext context, Project project) async {
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
                buildText(tr('project_text30'), 20, FontWeight.bold, Colors.red),
                const SizedBox(height: 20),
                buildText(tr('project_text31'), 16,
                    FontWeight.normal, Colors.black),
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
                          tr('cprofile_button2'), 16, FontWeight.bold, Colors.white),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          Connection.deleteRequest(
                              '/api/project/${project.id}');
                          // remove the project from the list of selected projects
                          newProjectList.remove(project);
                          workingProjectList.remove(project);
                          achievedProjectList.remove(project);
                        });
                        Navigator.of(context).pop();
                      },
                      style: buildButtonStyle(Colors.red[400]!),
                      child: buildText(
                          tr('cprofile_button3'), 16, FontWeight.bold, Colors.white),
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
    TextEditingController studentController = TextEditingController();

    titleController.text = project.title!;
    descriptionController.text = project.description!;
    int durationController = project.projectScopeFlag!;
    studentController.text = project.numberOfStudents.toString();
    int typeFlag = project.typeFlag!;

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
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildText(tr('project_text32'), 20, FontWeight.bold, Colors.blue),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleController,
                    decoration: buildDecoration(tr('project_text33')),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: buildDecoration(tr('cprofileinput_input3')),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: <Widget>[
                      RadioListTile<int>(
                        title: Text(tr("project_text2")),
                        value: 0,
                        groupValue: durationController,
                        onChanged: (int? value) {
                          setStateDialog(() {
                            durationController = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        title: Text(tr("project_text3")),
                        value: 1,
                        groupValue: durationController,
                        onChanged: (int? value) {
                          setStateDialog(() {
                            durationController = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        title: Text(tr("project_text4")),
                        value: 2,
                        groupValue: durationController,
                        onChanged: (int? value) {
                          setStateDialog(() {
                            durationController = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        title: Text(tr("project_text5")),
                        value: 3,
                        groupValue: durationController,
                        onChanged: (int? value) {
                          setStateDialog(() {
                            durationController = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: studentController,
                    decoration: buildDecoration(tr('project_text34')),
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
                            tr('cprofile_button2'), 16, FontWeight.bold, Colors.white),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            project.title = titleController.text;
                            project.description = descriptionController.text;
                            project.projectScopeFlag = durationController;
                            project.numberOfStudents =
                                int.parse(studentController.text);
                            project.typeFlag = typeFlag;
                            editProject(project);
                          });
                          Navigator.of(context).pop();
                        },
                        style: buildButtonStyle(Colors.blue[400]!),
                        child: buildText(
                            tr('project_text35'), 16, FontWeight.bold, Colors.white),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Future<void> showConfirmationDialog(
      BuildContext context, Project project) async {
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
                buildText(tr('project_text36'), 20, FontWeight.bold,
                    Colors.blue),
                const SizedBox(height: 20),
                buildText(
                    tr('project_text37'),
                    16,
                    FontWeight.normal,
                    Colors.black),
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
                          tr('cprofile_button2'), 16, FontWeight.bold, Colors.white),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          project.typeFlag = 1;
                          newProjectList.remove(project);
                          workingProjectList.add(project);
                          editProject(project);
                        });
                        Navigator.of(context).pop();
                      },
                      style: buildButtonStyle(Colors.blue[400]!),
                      child:
                          buildText(tr('project_text38'), 16, FontWeight.bold, Colors.white),
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

  RadioListTile<int> buildRadioListTile(
      String title, int value, int groupValue) {
    return RadioListTile<int>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: (int? newValue) {
        setState(() {
          groupValue = newValue!;
        });
      },
    );
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
