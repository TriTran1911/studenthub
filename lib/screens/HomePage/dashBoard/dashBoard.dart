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
            Project.buildProjectsList(Project.projects),
            Project.buildProjectsList(workingProjects),
            Project.buildProjectsList(achievedProjects),
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

  void _addProject(BuildContext context) {
    
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
}
