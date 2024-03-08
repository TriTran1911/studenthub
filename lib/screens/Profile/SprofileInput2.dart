import 'package:flutter/material.dart';
import '../../components/appbar.dart';
import 'package:intl/intl.dart';
import './SprofileInput3.dart';

class StudentInfoScreen2 extends StatefulWidget {
  final GlobalKey<_ProjectListState> projectListKey =
      GlobalKey<_ProjectListState>();

  @override
  _StudentInfoScreen2State createState() => _StudentInfoScreen2State();
}

class _StudentInfoScreen2State extends State<StudentInfoScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Experiences',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Tell us about yourself and you will be on your way to connect with real-world projects',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 16), // Adjust the padding as needed
              child: Row(
                children: [
                  Text(
                    'Project',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      showAddProjectModal(context, onSave: (newProject) {
                        widget.projectListKey.currentState
                            ?.addProject(newProject);
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            // List of projects
            Expanded(
              child: ProjectList(key: widget.projectListKey),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => StudentProfile()),
                  );
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProjectList extends StatefulWidget {
  ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  List<ProjectListItem> projects = [
    ProjectListItem(
      name: 'Project 1',
      startDate: DateTime.utc(2022, 1),
      endDate: DateTime.utc(2022, 3),
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      skillSet: 'Flutter, Dart, UI/UX',
    ),
    ProjectListItem(
      name: 'Project 2',
      startDate: DateTime.utc(2022, 4),
      endDate: DateTime.utc(2022, 6),
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      skillSet: 'React, JavaScript, API Integration',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return ProjectListItem(
          name: projects[index].name,
          startDate: projects[index].startDate,
          endDate: projects[index].endDate,
          description: projects[index].description,
          skillSet: projects[index].skillSet,
          onEditPressed: () {
            showEditProjectModal(
              context,
              initialProject: projects[index],
              onSave: (updatedProject) {
                updateProject(index, updatedProject);
              },
            );
          },
          onRemovePressed: () {
            removeProject(index);
          },
        );
      },
    );
  }

  void addProject(ProjectListItem newProject) {
    setState(() {
      projects.add(newProject);
    });
  }

  void updateProject(int index, ProjectListItem updatedProject) {
    setState(() {
      projects[index] = updatedProject;
    });
  }

  void removeProject(int index) {
    setState(() {
      projects.removeAt(index);
    });
  }
}

class ProjectListItem extends StatelessWidget {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String skillSet;
  final Function()? onEditPressed;
  final Function()? onRemovePressed;

  const ProjectListItem({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.skillSet,
    this.onEditPressed,
    this.onRemovePressed,
  });

  @override
  Widget build(BuildContext context) {
    int months = ((endDate.year - startDate.year) * 12 +
        endDate.month -
        startDate.month);
    String formattedStartDate =
        DateFormat('MM/yyyy').format(startDate.toLocal());
    String formattedEndDate = DateFormat('MM/yyyy').format(endDate.toLocal());

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEditPressed,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onRemovePressed,
                ),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.0),
            Text('$formattedStartDate - $formattedEndDate, $months months'),
            SizedBox(height: 16.0),
            Text('$description', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Skill Set: $skillSet'),
          ],
        ),
      ),
    );
  }
}

void showAddProjectModal(
  BuildContext context, {
  required Function(ProjectListItem) onSave,
}) {
  TextEditingController nameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController skillSetController = TextEditingController();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Project',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Project Name'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: startDateController,
                decoration: InputDecoration(labelText: 'Start Date'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: endDateController,
                decoration: InputDecoration(labelText: 'End Date'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: durationController,
                decoration: InputDecoration(labelText: 'Duration'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: skillSetController,
                decoration: InputDecoration(labelText: 'Skill Set'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  onSave(
                    ProjectListItem(
                      name: nameController.text,
                      startDate: DateTime.tryParse(startDateController.text) ??
                          DateTime.now(),
                      endDate: DateTime.tryParse(endDateController.text) ??
                          DateTime.now(),
                      description: descriptionController.text,
                      skillSet: skillSetController.text,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showEditProjectModal(
  BuildContext context, {
  required ProjectListItem initialProject,
  required Function(ProjectListItem) onSave,
}) {
  TextEditingController nameController =
      TextEditingController(text: initialProject.name);
  TextEditingController startDateController = TextEditingController(
      text: DateFormat('MM/yyyy').format(initialProject.startDate.toLocal()));
  TextEditingController endDateController = TextEditingController(
      text: DateFormat('MM/yyyy').format(initialProject.endDate.toLocal()));
  TextEditingController descriptionController =
      TextEditingController(text: initialProject.description);
  TextEditingController skillSetController =
      TextEditingController(text: initialProject.skillSet);

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Project',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Project Name'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: startDateController,
                decoration: InputDecoration(labelText: 'Start Date'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: endDateController,
                decoration: InputDecoration(labelText: 'End Date'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: skillSetController,
                decoration: InputDecoration(labelText: 'Skill Set'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  onSave(
                    ProjectListItem(
                      name: nameController.text,
                      startDate: DateTime.parse(startDateController.text),
                      endDate: DateTime.parse(endDateController.text),
                      description: descriptionController.text,
                      skillSet: skillSetController.text,
                      onEditPressed: initialProject.onEditPressed,
                      onRemovePressed: initialProject.onRemovePressed,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
