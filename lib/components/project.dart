import 'package:flutter/material.dart';
import '/screens/Action/projectTab.dart';

enum ProjectTool { Edit, Remove }

enum ProjectDuration {
  oneToThreeMonths,
  threeToSixMonths,
}

final views = [
  'View proposals',
  'View messages',
  'View hired',
  'View job posting',
  'Edit posting',
  'Remove posting',
  'Start working this project',
];

class Project {
  String title;
  ProjectDuration duration;
  List<String> description;
  String status;
  DateTime creationDate;
  int proposals; // Integer representing the number of proposals
  int messages; // Integer representing the number of messages
  int hiredCount; // Integer representing the number of times hired
  int studentsNeeded; // Number of students needed for the project
  String timeNeeded; // Time needed for the project

  Project(
    this.title,
    this.duration,
    this.description,
    this.status,
    this.creationDate, {
    this.proposals = 0,
    this.messages = 0,
    this.hiredCount = 0,
    this.studentsNeeded = 0,
    this.timeNeeded = '',
  });

  static List<Project> projects = [];

  // Add a project to the list of projects
  static void addProject(Project project) {
    projects.add(project);
  }

  static void removeProject(Project project) {
    projects.remove(project);
  }


  static Widget buildProjectsListWithoutMessagesHired(List<Project> projects,
      Function _handleProjectTool, Function _selectProject) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        String durationText;
        if (projects[index].duration == ProjectDuration.oneToThreeMonths) {
          durationText = '1 to 3 months';
        } else {
          durationText = '3 to 6 months';
        }

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
                  Text(
                      'Time: ${projects[index].timeNeeded}, ${projects[index].studentsNeeded} students needed'),
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
                          Text(
                              'Proposals: less than ${projects[index].proposals}'),
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
  },
),

              onTap: () {
                _selectProject(projects[index]);
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
  static List<Project> favoriteProjects = [];

  static bool isFavorite(Project project) {
    return favoriteProjects.contains(project);
  }

  static void toggleFavorite(Project project) {
    if (isFavorite(project)) {
      favoriteProjects.remove(project);
    } else {
      favoriteProjects.add(project);
    }
  }

  static void _toggleFavorite(Project project) {
    Project.toggleFavorite(project);
  }

}
