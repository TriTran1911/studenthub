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
          title: Text(
            'Your projects',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            _buildPostJobButton(),
          ],
          bottom: TabBar(
            tabs: [
              _buildTab('All Projects'),
              _buildTab('Working'),
              _buildTab('Achieved'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Project.buildProjectsList(
                Project.projects, _handleProjectTool, _selectProject),
            Project.buildProjectsList(
                workingProjects, _handleProjectTool, _selectProject),
            Project.buildProjectsList(
                achievedProjects, _handleProjectTool, _selectProject),
          ],
        ),
      ),
    );
  }

  Widget _buildPostJobButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextButton(
        onPressed: () => _addProject(context),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
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
    );
  }

  Widget _buildTab(String title) {
    return Tab(
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
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

  void _selectProject(Project project) {
    setState(() {});
  }

  void _addProject(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    ProjectDuration selectedDuration = ProjectDuration.oneToThreeMonths;
    TextEditingController descriptionController =
        TextEditingController(text: "");

    _showAddProjectDialog(
      context: context,
      titleController: titleController,
      selectedDuration: selectedDuration,
      descriptionController: descriptionController,
      onProjectAdded: (title, duration, description) {
        setState(() {
          
        });
      },
    );
  }

  void _editProject(Project project) {
    TextEditingController titleController =
        TextEditingController(text: project.title);
    ProjectDuration selectedDuration = project.duration;
    TextEditingController descriptionController =
        TextEditingController(text: project.description.join('\n'));

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
                buildDialogTitle('Edit Project'),
                SizedBox(height: 20.0),
                buildTextField(titleController, 'Title'),
                SizedBox(height: 20.0),
                buildDropdown(selectedDuration),
                SizedBox(height: 20.0),
                buildTextField(descriptionController, 'Description'),
                SizedBox(height: 20.0),
                buildActionButtons(
                  context,
                  project,
                  titleController,
                  selectedDuration,
                  descriptionController,
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
                buildDialogTitle('Confirm Removal'),
                SizedBox(height: 20.0),
                buildDialogText(
                    'Are you sure you want to remove this project?'),
                SizedBox(height: 20.0),
                buildRemoveActionButtons(project),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddProjectDialog({
    required BuildContext context,
    required TextEditingController titleController,
    required ProjectDuration selectedDuration,
    required TextEditingController descriptionController,
    required Function(String, ProjectDuration, String) onProjectAdded,
  }) {
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
                        selectedDuration = newValue;
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
                    maxLines: null, // Allow for multiple lines
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

                        onProjectAdded(
                            newTitle, selectedDuration, newDescription);

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

  Widget buildDialogTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
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

  Widget buildDropdown(ProjectDuration selectedDuration) {
    return DropdownButtonFormField<ProjectDuration>(
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
    );
  }

  Widget buildActionButtons(
    BuildContext context,
    Project project,
    TextEditingController titleController,
    ProjectDuration selectedDuration,
    TextEditingController descriptionController,
  ) {
    return Row(
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
            List<String> newDescription = descriptionController.text.split(
                '\n'); // Split the multiline description into a list of lines

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
    );
  }

  Widget buildDialogText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16.0,
      ),
    );
  }

  Widget buildRemoveActionButtons(Project project) {
    return Row(
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
}
