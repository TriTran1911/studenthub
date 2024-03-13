import 'package:flutter/material.dart';
import '/components/project.dart';
import 'projectDetail.dart';
import 'favoriteList.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late List<Project> projects;

  @override
  void initState() {
    super.initState();

    // Initialize the projects list
    projects = Project.projects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSearchBar(),
              ),
        
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              _showFavoriteProjects(context);
            },
          ),
        ],
          ),
          Expanded(
            child: Project.buildProjectsListWithoutMessagesHired(
              projects,
              _handleProjectTool,
              _selectProject,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search projects...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: (query) {
          _filterProjects(query);
        },
      ),
    );
  }

  void _filterProjects(String query) {
    setState(() {
      // Filter the projects list based on the query
      projects = Project.projects
          .where((project) =>
              project.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectProject(Project project) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProjectDetailPage(project: project)),
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

  void _editProject(Project project) {
    // Your implementation to edit a project goes here
  }

  void _removeProject(Project project) {
    // Your implementation to remove a project goes here
  }

  void _showFavoriteProjects(BuildContext context) {
  // Filter projects to show only favorite projects
  List<Project> favoriteProjects =
      projects.where((project) => project.isFavorite).toList();

  // Navigate to a new page to display favorite projects
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FavoriteProjectsPage(
        projects: favoriteProjects,
        handleProjectTool: _handleProjectTool, // Pass the handleProjectTool function
        selectProject: _selectProject, // Pass the selectProject function
      ),
    ),
  );
}


}
