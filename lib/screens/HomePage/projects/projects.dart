import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/components/controller.dart';
import 'package:studenthub/components/decoration.dart';
import '/components/modelController.dart';
import '/connection/server.dart';
import 'Function/favoriteProject.dart';
import 'Function/projectDetail.dart';

class ProjectsPage extends StatefulWidget {
  final int role;

  const ProjectsPage({super.key, required this.role});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Project>>? _projectsFuture;
  List<String> filteredNames = [];
  List<Project> allProjects = [];
  List<Project> projectList = [];

  int? selectedScopeFlag;
  int? selectedStudentCount;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    getProjects().then((value) {
      if (mounted) {
        setState(() {
          allProjects = value;
          projectList = allProjects;
        });
      }
    });
    _projectsFuture = getProjects();
  }

  Future<List<Project>> getProjects() async {
    try {
      var response = await Connection.getRequest('/api/project', {});
      var responseDecode = jsonDecode(response);

      if (responseDecode['result'] != null) {
        print("Connected to the server successfully");
        print(responseDecode['result']);

        List<Project> projectList =
            Project.buildListProject(responseDecode['result']);

        return projectList;
      } else {
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  void _onSearchChanged() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      projectList = allProjects.where((project) {
        return project.title!.toLowerCase().contains(searchText);
      }).toList();
    });
  }

  void _applyFilters() {
    setState(() {
      projectList = allProjects.where((project) {
        bool matchesScope = selectedScopeFlag == null ||
            project.projectScopeFlag == selectedScopeFlag;
        bool matchesStudentCount;
        if (selectedStudentCount == null) {
          matchesStudentCount = true;
        } else if (selectedStudentCount == 0) {
          matchesStudentCount = project.numberOfStudents! < 10;
        } else if (selectedStudentCount == 1) {
          matchesStudentCount = project.numberOfStudents! >= 10 &&
              project.numberOfStudents! <= 20;
        } else {
          matchesStudentCount = project.numberOfStudents! > 20;
        }
        return matchesScope && matchesStudentCount;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: tr("project_text1"),
                        prefixIcon: IconTheme(
                          data: IconThemeData(color: iconColor),
                          child: const Icon(Icons.search),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list_outlined),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            surfaceTintColor: Colors.brown,
                            title: Text(tr("project_text6"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Card(
                                  child: ListTile(
                                    title: Text(tr("project_text7")),
                                    onTap: () {
                                      setState(() {
                                        selectedScopeFlag = null;
                                        selectedStudentCount = null;
                                      });
                                    },
                                  ),
                                ),
                                Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(tr("project_text2")),
                                        onTap: () {
                                          setState(() {
                                            selectedScopeFlag = 0;
                                          });
                                        },
                                        selected: selectedScopeFlag == 0,
                                      ),
                                      ListTile(
                                        title: Text(tr("project_text3")),
                                        onTap: () {
                                          setState(() {
                                            selectedScopeFlag = 1;
                                          });
                                        },
                                        selected: selectedScopeFlag == 1,
                                      ),
                                      ListTile(
                                        title: Text(tr("project_text4")),
                                        onTap: () {
                                          setState(() {
                                            selectedScopeFlag = 2;
                                          });
                                        },
                                        selected: selectedScopeFlag == 2,
                                      ),
                                      ListTile(
                                        title: Text(tr("project_text5")),
                                        onTap: () {
                                          setState(() {
                                            selectedScopeFlag = 3;
                                          });
                                        },
                                        selected: selectedScopeFlag == 3,
                                      ),
                                    ],
                                  ),
                                ),
                                Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(tr("project_text8")),
                                        onTap: () {
                                          setState(() {
                                            selectedStudentCount = 0;
                                          });
                                        },
                                        selected: selectedStudentCount == 0,
                                      ),
                                      ListTile(
                                        title: Text(tr("project_text9")),
                                        onTap: () {
                                          setState(() {
                                            selectedStudentCount = 1;
                                          });
                                        },
                                        selected: selectedStudentCount == 1,
                                      ),
                                      ListTile(
                                        title: Text(tr("project_text10")),
                                        onTap: () {
                                          setState(() {
                                            selectedStudentCount = 2;
                                          });
                                        },
                                        selected: selectedStudentCount == 2,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    _applyFilters();
                                    Navigator.pop(context);
                                  },
                                  child: Text(tr("project_text15")),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  widget.role == 0
                      ? IconButton(
                          icon: const Icon(Icons.bookmarks, color: Colors.red),
                          onPressed: () {
                            moveToPage(
                                FavoriteProjectsPage(projects: projectList),
                                context);
                          },
                        )
                      : const SizedBox(width: 0),
                ],
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Project>>(
                future: _projectsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                        color: Colors.white,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return buildCards();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView buildCards() {
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
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                    widget.role == 0
                        ? IconButton(
                            icon: Icon(
                              pro.isFavorite!
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline,
                              color: pro.isFavorite! ? Colors.red : Colors.blue,
                            ),
                            onPressed: () {
                              setState(() {
                                pro.isFavorite = !pro.isFavorite!;
                                Connection().setFavorite(
                                    pro.id!, pro.isFavorite! ? 0 : 1, context);
                              });
                            },
                          )
                        : const SizedBox(width: 0),
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
                            pro.numberOfStudents == 1 ||
                                    pro.numberOfStudents == 0
                                ? '${pro.numberOfStudents} ' +
                                    'project_text13'.tr()
                                : '${pro.numberOfStudents} ' +
                                    'project_text14'.tr(),
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
                                ? '${pro.countProposals.toString()} ' +
                                    'project_text11'.tr()
                                : '${pro.countProposals.toString()} ' +
                                    'project_text12'.tr(),
                            14,
                            FontWeight.normal,
                            Colors.black),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            onTap: widget.role == 0
                ? () {
                    moveToPage(ProjectDetailPage(project: pro), context);
                  }
                : () {},
          ),
        );
      },
    );
  }
}
