import 'package:flutter/material.dart';
import '/components/project.dart';

class FavoriteProjectsPage extends StatelessWidget {
  final List<Project> projects;
  final Function(ProjectTool, Project) handleProjectTool;
  final Function(Project) selectProject;

  FavoriteProjectsPage({
    required this.projects,
    required this.handleProjectTool,
    required this.selectProject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Projects'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Project.buildProjectsListWithoutMessagesHired(
              projects,
              handleProjectTool,
              selectProject,
            ),
          ),
        ],
      ),
    );
  }
}
