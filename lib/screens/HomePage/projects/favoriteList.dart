import 'package:flutter/material.dart';
import '/components/project.dart';

class FavoriteProjectsPage extends StatefulWidget {
  final List<Project> projects;
  final Function(ProjectTool, Project) handleProjectTool;
  final Function(Project) selectProject;

  FavoriteProjectsPage({
    required this.projects,
    required this.handleProjectTool,
    required this.selectProject,
  });

  @override
  _FavoriteProjectsPageState createState() => _FavoriteProjectsPageState();
}

class _FavoriteProjectsPageState extends State<FavoriteProjectsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Projects'),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildProjectsListWithoutMessagesHired(
              widget.projects,
              widget.handleProjectTool,
              widget.selectProject,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProjectsListWithoutMessagesHired(List<Project> projects,
      Function handleProjectTool, Function selectProject) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final daysSinceCreation =
            DateTime.now().difference(projects[index].createdAt ?? DateTime.now()).inDays;
        return Column(
          children: [
            ListTile(
              title: Text(
                projects[index].title ?? "No title",
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
                  Text(
                      'Time: ${projects[index].getProjectScopeAsString()}, ${projects[index].numberOfStudents} students needed'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (projects[index].description ?? '')
                      .split('\n') 
                      .map(
                          (descriptionItem) => Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text('• $descriptionItem'),
                          ),
                      )
                      .toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                              'Proposals: less than ${projects[index].countProposals}'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  Project.isFavorite(projects[index])
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Project.isFavorite(projects[index]) ? Colors.red : null,
                ),
                onPressed: () {
                  _toggleFavorite(projects[index]);
                  // Remove the project from the list of favorites
                  setState(() {
                    projects.remove(projects[index]);
                  });
                },
              ),
              onTap: () {
                selectProject(projects[index]);
              },
            ),
            Divider(
              height: 17,
              color: Colors.grey,
            ), // Add a divider between projects
          ],
        );
      },
    );
  }

  void _toggleFavorite(Project project) {
    Project.toggleFavorite(project);
  }
}
