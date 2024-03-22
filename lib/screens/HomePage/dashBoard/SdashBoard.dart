import 'package:flutter/material.dart';
import '/components/project.dart';
import '/screens/Action/projectTab.dart';

class StudentDashboardPage extends StatefulWidget {
  @override
  _StudentDashboardPageState createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  late List<Project> workingProjects;
  late List<Project> achievedProjects;
  final submittedProjects = SubmittedProjects().submittedProjects;

  @override
  Widget build(BuildContext context) {
    _updateProjectsList();

    return _buildDefaultTabController();
  }

  DefaultTabController _buildDefaultTabController() {
    final activeProposals = submittedProjects.where((submitted) => submitted.messageStatus == 'Active').map((submitted) => submitted.project).toList();
    final submittedProposals = submittedProjects;

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
            buildAllProjectsList(activeProposals, submittedProposals.map((submitted) => submitted.project).toList()),
            buildProjectsList(workingProjects),
            buildProjectsList(achievedProjects),
          ],
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
        final project = projects[index];
        final submittedProject = SubmittedProjects().submittedProjects.firstWhere((submitted) => submitted.project == project);
        final daysSinceSubmit = DateTime.now().difference(submittedProject.sentTime).inDays;
        return Column(
          children: [
            ListTile(
              title: Text(
                project.title,
                style: TextStyle(color: Colors.green),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Submitted $daysSinceSubmit days ago'),
                  Text(
                    'Students are looking for:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: project
                          .description
                          .map((descriptionItem) => Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      descriptionItem.isEmpty ? '• No description' : '• ',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(descriptionItem,
                                          style: TextStyle(fontSize: 16)),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProposalsPage(project: project),
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

  Widget buildAllProjectsList(List<Project> activeProposals, List<Project> submittedProposals) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('Active proposal (${activeProposals.length})'),
          children: activeProposals.map((project) => buildProjectTile(project)).toList(),
        ),
        ExpansionTile(
          title: Text('Submitted proposal (${submittedProposals.length})'),
          children: submittedProposals.map((project) => buildProjectTile(project)).toList(),
        ),
      ],
    );
  }

  Widget buildProjectTile(Project project) {
    final daysSinceCreation = DateTime.now().difference(project.creationDate).inDays;
    return ListTile(
      title: Text(
        project.title,
        style: TextStyle(color: Colors.green),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Created ${daysSinceCreation} days ago'),
          Text(
            'Students are looking for:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: project.description.map((descriptionItem) => Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      descriptionItem.isEmpty ? '• No description' : '• ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(descriptionItem, style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProposalsPage(project: project),
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
}