import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
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
                        hintText: 'Search projects...',
                        prefixIcon: const Icon(Icons.search),
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
                            title: const Text('Filter Projects',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Card(
                                  child: ListTile(
                                    title: const Text('All Projects'),
                                    onTap: () {
                                      setState(() {
                                        projectList = allProjects;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: const Text('Less than 1 month'),
                                        onTap: () {
                                          setState(() {
                                            projectList = allProjects
                                                .where((project) =>
                                                    project.projectScopeFlag ==
                                                    0)
                                                .toList();
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: const Text('1 to 3 months'),
                                        onTap: () {
                                          setState(() {
                                            projectList = allProjects
                                                .where((project) =>
                                                    project.projectScopeFlag ==
                                                    1)
                                                .toList();
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: const Text('3 to 6 months'),
                                        onTap: () {
                                          setState(() {
                                            projectList = allProjects
                                                .where((project) =>
                                                    project.projectScopeFlag ==
                                                    2)
                                                .toList();
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: const Text('More than 6 months'),
                                        onTap: () {
                                          setState(() {
                                            projectList = allProjects
                                                .where((project) =>
                                                    project.projectScopeFlag ==
                                                    3)
                                                .toList();
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title:
                                            const Text('Less than 10 students'),
                                        onTap: () {
                                          setState(() {
                                            projectList = allProjects
                                                .where((project) =>
                                                    project.numberOfStudents! <
                                                    10)
                                                .toList();
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: const Text('10 to 20 students'),
                                        onTap: () {
                                          setState(() {
                                            projectList = allProjects
                                                .where((project) =>
                                                    project.numberOfStudents! >=
                                                        10 &&
                                                    project.numberOfStudents! <=
                                                        20)
                                                .toList();
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title:
                                            const Text('More than 20 students'),
                                        onTap: () {
                                          setState(() {
                                            projectList = allProjects
                                                .where((project) =>
                                                    project.numberOfStudents! >
                                                    20)
                                                .toList();
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
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
            onTap: widget.role == 1
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
