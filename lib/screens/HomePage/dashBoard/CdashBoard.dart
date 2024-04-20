import 'package:flutter/material.dart';
import 'package:studenthub/components/controller.dart';
import '/components/project.dart';
import '/screens/Action/projectTab.dart';
import '/screens/HomePage/dashBoard/Function/projectPost1.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // count number of time open the page
  late List<Project> onBoardingProjects;
  late List<Project> workingProjects;
  late List<Project> achievedProjects;

  @override
  void initState() {
    super.initState();
    intitialData();
  }

  Future<void> intitialData() async {
    List<Project> tmp = await fetchDataProjectsByID('8');
    setState(() {
      onBoardingProjects = tmp;
      workingProjects = tmp;
      achievedProjects = tmp;
    });
  }

  Widget build(BuildContext context) {
    _updateProjectsList();

    return _buildDefaultTabController();
  }

  DefaultTabController _buildDefaultTabController() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Your projects',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            _buildPostJobButton(),
          ],
          bottom: TabBar(
            indicatorColor: Colors.blue,
            tabs: [
              _buildTab('All Projects'),
              _buildTab('Working'),
              _buildTab('Achieved'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildProjectsList(onBoardingProjects),
            buildProjectsList(workingProjects),
            buildProjectsList(achievedProjects),
          ],
        ),
      ),
    );
  }

  Widget _buildPostJobButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextButton(
        onPressed: () => _addProject(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'Post a job',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  void _addProject() {
    moveToPage(ProjectPost1(), context);
  }

  Widget _buildTab(String title) {
    return Tab(
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Colors.blue,
        ),
      ),
    );
  }

  void _updateProjectsList() {
    onBoardingProjects = Project.projects
        .where((project) => project.typeFlag == 0 || project.typeFlag == 1)
        .toList();
    workingProjects =
        Project.projects.where((project) => project.typeFlag == 0).toList();
    achievedProjects =
        Project.projects.where((project) => project.typeFlag == 1).toList();
  }

  Widget buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildProjectsList(List<Project> projects) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        // Calculate days since creation
        final daysSinceCreation =
            DateTime.now().difference(projects[index].createdAt!).inDays;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  projects[index].title!,
                  style: TextStyle(color: Colors.green),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Created $daysSinceCreation days ago'),
                    Text(
                      'Students are looking for:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(projects[index]
                          .description!), // Assuming description is a non-null field
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('${projects[index].countProposals ?? 0}'),
                            Text('Proposals'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('0'), // Placeholder for Messages
                            Text('Messages'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('0'), // Placeholder for Hired
                            Text('Hired'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {
                    _showBottomSheet(context, projects[index]);
                  },
                ),
                onTap: () {
                  moveToPage(ProposalsPage(project: projects[index]), context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeProject(Project project) {
    setState(() {
      Project.removeProject(project);
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Posting",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("Are you sure you want to delete this posting?"),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                _removeProject(project);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editPosting(BuildContext context, Project project) {
    TextEditingController titleController =
        TextEditingController(text: project.title!);
    int selectedDurationIndex = project.projectScopeFlag!;
    int studentsNeeded = project.numberOfStudents!;
    TextEditingController descriptionController =
        TextEditingController(text: project.description!);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "Edit Posting",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: "Title"),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Duration: "),
                        RadioListTile(
                          title: Text("Less than 1 month"),
                          value: 0,
                          groupValue: selectedDurationIndex,
                          onChanged: (value) {
                            setState(() {
                              selectedDurationIndex = value!;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile(
                          title: Text("1 to 3 months"),
                          value: 1,
                          groupValue: selectedDurationIndex,
                          onChanged: (value) {
                            setState(() {
                              selectedDurationIndex = value!;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile(
                          title: Text("3 to 6 months"),
                          value: 2,
                          groupValue: selectedDurationIndex,
                          onChanged: (value) {
                            setState(() {
                              selectedDurationIndex = value!;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile(
                          title: Text("More than 6 months"),
                          value: 3,
                          groupValue: selectedDurationIndex,
                          onChanged: (value) {
                            setState(() {
                              selectedDurationIndex = value!;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Students Needed: "),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.0, vertical: 1.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (studentsNeeded > 0) {
                                setState(() {
                                  studentsNeeded--;
                                });
                              }
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                int updatedStudentsNeeded = studentsNeeded;
                                return AlertDialog(
                                  title: Text(
                                    "Edit Students Needed",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: TextFormField(
                                    initialValue: studentsNeeded.toString(),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      updatedStudentsNeeded =
                                          int.tryParse(value) ?? 0;
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          studentsNeeded =
                                              updatedStudentsNeeded;
                                        });
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.black),
                                bottom: BorderSide(color: Colors.black),
                              ),
                            ),
                            child: Text(studentsNeeded.toString()),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.0, vertical: 1.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                studentsNeeded++;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: "Description"),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      project.title = titleController.text;
                      project.projectScopeFlag = selectedDurationIndex;
                      project.numberOfStudents = studentsNeeded;
                      project.description = descriptionController.text;
                    });
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, Project project) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 430,
          child: Column(
            children: [
              ListTile(
                title: Text('View Proposals',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {
                  Navigator.of(context).pop();
                  moveToPage(
                      ProposalsPage(project: project, initialTabIndex: 0),
                      context);
                },
              ),
              ListTile(
                title: Text('View Messages',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {
                  Navigator.of(context).pop();
                  moveToPage(
                      ProposalsPage(project: project, initialTabIndex: 2),
                      context);
                },
              ),
              ListTile(
                title: Text('View Hired',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {
                  Navigator.of(context).pop();
                  moveToPage(
                      ProposalsPage(project: project, initialTabIndex: 3),
                      context);
                },
              ),
              Divider(height: 17, color: Colors.grey),
              ListTile(
                title: Text('View job posting',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {},
              ),
              ListTile(
                title: Text('Edit posting',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {
                  _editPosting(context, project);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("You have edited the posting."),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Remove posting',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {
                  _showDeleteConfirmationDialog(context, project);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("You have removed the posting."),
                    ),
                  );
                },
              ),
              Divider(height: 17, color: Colors.grey),
              ListTile(
                title: Text('Start working this project',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {
                  setState(() {
                    project.projectScopeFlag =
                        1; // Set project scope flag to working
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("You have started working on this project."),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void fetchProjectsByCompanyId(String companyId) async {
    try {
      List<Project> projects = await Project.getProjectsByCompanyId(companyId);
      setState(() {
        onBoardingProjects = projects;
        workingProjects =
            projects.where((project) => project.typeFlag == 0).toList();
        achievedProjects =
            projects.where((project) => project.typeFlag == 1).toList();
      });
    } catch (e) {
      print('Error fetching projects by company id: $e');
    }
  }

  Future<List<Project>> fetchDataProjectsByID(String companyId) async {
    return await Project.getProjectsByCompanyId(companyId);
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}
