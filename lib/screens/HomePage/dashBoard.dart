import 'package:flutter/material.dart';
import '/components/project.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // count number of time open the page
  late List<Project> workingProjects;
  late List<Project> achievedProjects;

  @override
  void initState() {
    super.initState();

    _updateProjectsList();
  }

  void _updateProjectsList() {
    workingProjects = Project.projects
        .where((project) => project.status == 'Working')
        .toList();
    achievedProjects = Project.projects
        .where((project) => project.status == 'Achieved')
        .toList();
  }

  void _selectProject(Project project) {
    setState(() {
    });
  }

  void _addProject() {
    TextEditingController titleController = TextEditingController();
    ProjectDuration selectedDuration = ProjectDuration.oneToThreeMonths;
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Add Project',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButtonFormField<ProjectDuration>(
                    value: selectedDuration,
                    onChanged: (ProjectDuration? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedDuration = newValue;
                        });
                      }
                    },
                    items:
                        ProjectDuration.values.map((ProjectDuration duration) {
                      return DropdownMenuItem<ProjectDuration>(
                        value: duration,
                        child: Text(
                          duration == ProjectDuration.oneToThreeMonths
                              ? '1 to 3 months'
                              : '3 to 6 months',
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Duration',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        String newTitle = titleController.text;
                        String newDescription = descriptionController.text;

                        setState(() {
                          Project.addProject(
                            newTitle,
                            selectedDuration,
                            newDescription,
                            'Working',
                          );
                        });

                        Navigator.of(context).pop();
                      },
                      child: Text('Save'),
                    ),
                    SizedBox(width: 20.0),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editProject(Project project) {
    TextEditingController titleController =
        TextEditingController(text: project.title);
    ProjectDuration selectedDuration = project.duration;
    TextEditingController descriptionController =
        TextEditingController(text: project.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Edit Project',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                DropdownButtonFormField<ProjectDuration>(
                  value: selectedDuration,
                  onChanged: (ProjectDuration? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedDuration = newValue;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Duration',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  items: ProjectDuration.values.map((ProjectDuration duration) {
                    return DropdownMenuItem<ProjectDuration>(
                      value: duration,
                      child: Text(
                        duration == ProjectDuration.oneToThreeMonths
                            ? '1 to 3 months'
                            : '3 to 6 months',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        String newTitle = titleController.text;
                        String newDescription = descriptionController.text;

                        setState(() {
                          project.title = newTitle;
                          project.duration = selectedDuration;
                          project.description = newDescription;
                        });

                        Navigator.of(context).pop();
                      },
                      child: Text('Save'),
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

  void _removeProject(Project project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Confirm Removal',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Are you sure you want to remove this project?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          Project.removeProject(project);
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('Remove'),
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

  void _handleProjectTool(ProjectTool result, Project project) {
    switch (result) {
      case ProjectTool.Edit:
        _editProject(project);
        break;
      case ProjectTool.Remove:
        _removeProject(project);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateProjectsList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your projects',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: TextButton(
                onPressed: () {
                  _addProject();
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Post a job',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'All Projects',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Working',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Achieved',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProjectsList(Project.projects),
            _buildProjectsList(workingProjects),
            _buildProjectsList(achievedProjects),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsList(List<Project> projects) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        String durationText;
        if (projects[index].duration == ProjectDuration.oneToThreeMonths) {
          durationText = '1 to 3 months';
        } else {
          durationText = '3 to 6 months';
        }

        return ListTile(
          title: Text(
            projects[index].title,
            style: TextStyle(color: const Color.fromARGB(255, 25, 99, 28)),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$durationText\n'),
              Text(
                  'Student looking for: \n\t\t\t ${projects[index].description}\n'),
            ],
          ),
          trailing: PopupMenuButton<ProjectTool>(
            onSelected: (ProjectTool result) {
              _handleProjectTool(result, projects[index]);
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<ProjectTool>>[
              PopupMenuItem<ProjectTool>(
                value: ProjectTool.Edit,
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                ),
              ),
              PopupMenuItem<ProjectTool>(
                value: ProjectTool.Remove,
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Remove'),
                ),
              ),
            ],
          ),
          onTap: () {
            _selectProject(projects[index]);
          },
        );
      },
    );
  }
}
