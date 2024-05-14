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
                  filterButton(context),
                  widget.role == 0
                      ? IconButton(
                          icon: const Icon(Icons.bookmarks, color: Colors.black),
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

  IconButton filterButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list_outlined),
      onPressed: () {
        bool isSelectAll = false;
        bool isSelect1 = false;
        bool isSelect2 = false;
        bool isSelect3 = false;
        bool isSelect4 = false;
        bool isSelect5 = false;
        bool isSelect6 = false;
        bool isSelect7 = false;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              surfaceTintColor: Colors.brown,
              title: buildCenterText(
                  'Filter Projects', 24, FontWeight.bold, Colors.black),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStateDialog) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: ListTile(
                        title: Text('All Projects',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelectAll ? Colors.blue : Colors.black)),
                        onTap: () {
                          setStateDialog(() {
                            isSelectAll = !isSelectAll;
                            isSelect1 = false;
                            isSelect2 = false;
                            isSelect3 = false;
                            isSelect4 = false;
                            isSelect5 = false;
                            isSelect6 = false;
                            isSelect7 = false;
                          });
                        },
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Less than 1 month',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelect1
                                        ? Colors.blue
                                        : Colors.black)),
                            onTap: () {
                              setStateDialog(() {
                                isSelectAll = false;
                                isSelect1 = !isSelect1;
                                isSelect2 = false;
                                isSelect3 = false;
                                isSelect4 = false;
                              });
                            },
                          ),
                          ListTile(
                            title: Text('1 to 3 months',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelect2
                                        ? Colors.blue
                                        : Colors.black)),
                            onTap: () {
                              setStateDialog(() {
                                isSelectAll = false;
                                isSelect1 = false;
                                isSelect2 = !isSelect2;
                                isSelect3 = false;
                                isSelect4 = false;
                              });
                            },
                          ),
                          ListTile(
                            title: Text('3 to 6 months',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelect3
                                        ? Colors.blue
                                        : Colors.black)),
                            onTap: () {
                              setStateDialog(() {
                                isSelectAll = false;
                                isSelect1 = false;
                                isSelect2 = false;
                                isSelect3 = !isSelect3;
                                isSelect4 = false;
                              });
                            },
                          ),
                          ListTile(
                            title: Text('More than 6 months',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelect4
                                        ? Colors.blue
                                        : Colors.black)),
                            onTap: () {
                              setStateDialog(() {
                                isSelectAll = false;
                                isSelect1 = false;
                                isSelect2 = false;
                                isSelect3 = false;
                                isSelect4 = !isSelect4;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Less than 10 students',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelect5
                                        ? Colors.blue
                                        : Colors.black)),
                            onTap: () {
                              setStateDialog(() {
                                isSelectAll = false;
                                isSelect5 = !isSelect5;
                                isSelect6 = false;
                                isSelect7 = false;
                              });
                            },
                          ),
                          ListTile(
                            title: Text('10 to 20 students',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelect6
                                        ? Colors.blue
                                        : Colors.black)),
                            onTap: () {
                              setStateDialog(() {
                                isSelectAll = false;
                                isSelect5 = false;
                                isSelect6 = !isSelect6;
                                isSelect7 = false;
                              });
                            },
                          ),
                          ListTile(
                            title: Text('More than 20 students',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelect7
                                        ? Colors.blue
                                        : Colors.black)),
                            onTap: () {
                              setStateDialog(() {
                                isSelectAll = false;
                                isSelect5 = false;
                                isSelect6 = false;
                                isSelect7 = !isSelect7;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // cancel button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: buildButtonStyle(Colors.grey[400]!),
                          child: buildText(
                              'Cancel', 16, FontWeight.bold, Colors.white),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (isSelectAll ||
                                isSelect1 ||
                                isSelect2 ||
                                isSelect3 ||
                                isSelect4 ||
                                isSelect5 ||
                                isSelect6 ||
                                isSelect7) {
                              setState(() {
                                filterProject(
                                    isSelectAll,
                                    isSelect1,
                                    isSelect5,
                                    isSelect6,
                                    isSelect7,
                                    isSelect2,
                                    isSelect3,
                                    isSelect4);
                              });
                              Navigator.pop(context);
                            } else {
                              // show dialog
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    surfaceTintColor: Colors.red,
                                    title: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                    content: buildText(
                                        'Please select at least one filter',
                                        18,
                                        FontWeight.bold,
                                        Colors.black),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: buildText('OK', 20,
                                            FontWeight.bold, Colors.red),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          style: buildButtonStyle(Colors.blue[400]!),
                          child: buildText(
                              'Apply', 16, FontWeight.bold, Colors.white),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            );
          },
        );
      },
    );
  }

  void filterProject(
      bool isSelectAll,
      bool isSelect1,
      bool isSelect5,
      bool isSelect6,
      bool isSelect7,
      bool isSelect2,
      bool isSelect3,
      bool isSelect4) {
    if (isSelectAll) {
      projectList = allProjects;
    } else if (isSelect1) {
      projectList = allProjects
          .where((project) => project.projectScopeFlag == 0)
          .toList();
      if (isSelect5) {
        projectList = projectList
            .where((project) => project.numberOfStudents! < 10)
            .toList();
      } else if (isSelect6) {
        projectList = projectList
            .where((project) =>
                project.numberOfStudents! >= 10 &&
                project.numberOfStudents! <= 20)
            .toList();
      } else if (isSelect7) {
        projectList = projectList
            .where((project) => project.numberOfStudents! > 20)
            .toList();
      }
    } else if (isSelect2) {
      projectList = allProjects
          .where((project) => project.projectScopeFlag == 1)
          .toList();
      if (isSelect5) {
        projectList = projectList
            .where((project) => project.numberOfStudents! < 10)
            .toList();
      } else if (isSelect6) {
        projectList = projectList
            .where((project) =>
                project.numberOfStudents! >= 10 &&
                project.numberOfStudents! <= 20)
            .toList();
      } else if (isSelect7) {
        projectList = projectList
            .where((project) => project.numberOfStudents! > 20)
            .toList();
      }
    } else if (isSelect3) {
      projectList = allProjects
          .where((project) => project.projectScopeFlag == 2)
          .toList();
      if (isSelect5) {
        projectList = projectList
            .where((project) => project.numberOfStudents! < 10)
            .toList();
      } else if (isSelect6) {
        projectList = projectList
            .where((project) =>
                project.numberOfStudents! >= 10 &&
                project.numberOfStudents! <= 20)
            .toList();
      } else if (isSelect7) {
        projectList = projectList
            .where((project) => project.numberOfStudents! > 20)
            .toList();
      }
    } else if (isSelect4) {
      projectList = allProjects
          .where((project) => project.projectScopeFlag == 3)
          .toList();
      if (isSelect5) {
        projectList = projectList
            .where((project) => project.numberOfStudents! < 10)
            .toList();
      } else if (isSelect6) {
        projectList = projectList
            .where((project) =>
                project.numberOfStudents! >= 10 &&
                project.numberOfStudents! <= 20)
            .toList();
      } else if (isSelect7) {
        projectList = projectList
            .where((project) => project.numberOfStudents! > 20)
            .toList();
      }
    } else if (isSelect5) {
      projectList = allProjects
          .where((project) => project.numberOfStudents! < 10)
          .toList();
      if (isSelect1) {
        projectList = projectList
            .where((project) => project.projectScopeFlag == 0)
            .toList();
      } else if (isSelect2) {
        projectList = projectList
            .where((project) => project.projectScopeFlag == 1)
            .toList();
      } else if (isSelect3) {
        projectList = projectList
            .where((project) => project.projectScopeFlag == 2)
            .toList();
      } else if (isSelect4) {
        projectList = projectList
            .where((project) => project.projectScopeFlag == 3)
            .toList();
      }
    } else if (isSelect6) {
      projectList = allProjects
          .where((project) =>
              project.numberOfStudents! >= 10 &&
              project.numberOfStudents! <= 20)
          .toList();
      if (isSelect1) {
        projectList = projectList
            .where((project) => project.projectScopeFlag == 0)
            .toList();
      } else if (isSelect2) {
        projectList = projectList
            .where((project) => project.projectScopeFlag == 1)
            .toList();
      } else if (isSelect3) {
        projectList = projectList
            .where((project) => project.projectScopeFlag == 2)
            .toList();
      } else if (isSelect4) {
        projectList = projectList
            .where((project) => project.projectScopeFlag == 3)
            .toList();
      }
    } else if (isSelect7) {
      projectList = allProjects
          .where((project) => project.numberOfStudents! > 20)
          .toList();
      if (isSelect1) {
        projectList = projectList
            .where((project) => project.projectScopeFlag == 0)
            .toList();
      } else if (isSelect2) {
        projectList = projectList
            .where((project) => project.projectScopeFlag == 1)
            .toList();
      } else if (isSelect3) {
        projectList = projectList
            .where((project) => project.projectScopeFlag == 2)
            .toList();
      } else if (isSelect4) {
        projectList = projectList
            .where((project) => project.projectScopeFlag == 3)
            .toList();
      }
    }
  }

  ListView buildCards() {
    if (projectList.isEmpty) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Card(
            color: Colors.yellow[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 3,
            surfaceTintColor: Colors.blue,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            shadowColor: Colors.blue,
            child: ListTile(
              title: buildCenterText(
                  'No projects found', 20, FontWeight.bold, Colors.black),
            ),
          ),
        ],
      );
    } else {
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
                                color:
                                    pro.isFavorite! ? Colors.red : Colors.blue,
                              ),
                              onPressed: () {
                                setState(() {
                                  pro.isFavorite = !pro.isFavorite!;
                                  Connection().setFavorite(pro.id!,
                                      pro.isFavorite! ? 0 : 1, context);
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
}
