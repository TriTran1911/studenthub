import 'package:flutter/material.dart';
import '/components/project.dart';
import '/screens/Action/projectTab.dart';
import '/screens/HomePage/dashBoard/Function/projectPost1.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<Project> workingProjects;
  late List<Project> achievedProjects;
  

  @override
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
            buildProjectsList(Project.projects),
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectPost1(),
      ),
    );
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
    workingProjects = Project.projects
        .where((project) => project.status == 'Working')
        .toList();
    achievedProjects = Project.projects
        .where((project) => project.status == 'Achieved')
        .toList();
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
            DateTime.now().difference(projects[index].creationDate).inDays;

        return Column(
          children: [
            ListTile(
              title: Text(
                projects[index].title,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: projects[index]
                          .description
                          .map((descriptionItem) => Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text('• $descriptionItem'),
                              ))
                          .toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('${projects[index].proposals}'),
                          Text('Proposals'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('${projects[index].messages}'),
                          Text('Messages'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('${projects[index].hiredCount}'),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProposalsPage(project: projects[index]),
                  ),
                );
              },
            ),
            Divider(
              height: 17,
              color: Colors.grey,
            ),
          ],
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
        TextEditingController(text: project.title);
    int selectedDurationIndex =
        project.duration == ProjectDuration.oneToThreeMonths ? 0 : 1;
    int studentsNeeded = project.studentsNeeded;
    TextEditingController descriptionController =
        TextEditingController(text: project.description.join('\n'));

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
                          title: Text("1 to 3 months"),
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
                          title: Text("4 to 6 months"),
                          value: 1,
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
                      project.duration = selectedDurationIndex == 0
                          ? ProjectDuration.oneToThreeMonths
                          : ProjectDuration.threeToSixMonths;
                      project.studentsNeeded = studentsNeeded;
                      project.description =
                          descriptionController.text.split('\n');
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProposalsPage(project: project, initialTabIndex: 0),
                    ),
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProposalsPage(
                          project: project,
                          initialTabIndex: 2), // Pass initialTabIndex as 2
                    ),
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProposalsPage(
                          project: project,
                          initialTabIndex: 3), // Pass initialTabIndex as 3
                    ),
                  );
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
                    project.status = 'Working';
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
}
