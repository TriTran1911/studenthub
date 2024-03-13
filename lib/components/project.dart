import 'package:flutter/material.dart';

enum ProjectTool { Edit, Remove }

enum ProjectDuration {
  oneToThreeMonths,
  threeToSixMonths,
}

class Project {
  late final String title;
  late final ProjectDuration duration;
  late final String description;
  final String status;
  final DateTime creationDate;
  final int proposals; // Integer representing the number of proposals
  final int messages; // Integer representing the number of messages
  final int hiredCount; // Integer representing the number of times hired

  Project(this.title, this.duration, this.description, this.status,
      this.creationDate,
      {this.proposals = 0, this.messages = 0, this.hiredCount = 0});

  static List<Project> projects = [];

  static void addProject(String title, ProjectDuration duration,
      String description, String status, DateTime creationDate,
      {int proposals = 0, int messages = 0, int hiredCount = 0}) {
    projects.add(Project(title, duration, description, status, creationDate,
        proposals: proposals, messages: messages, hiredCount: hiredCount));
  }

  static void removeProject(Project project) {
    projects.remove(project);
  }

  static Widget buildProjectsList(List<Project> projects,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0), // Add vertical padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: projects[index]
                          .description
                          .split('\n')
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
                          Text('Proposals'),
                          Text('${projects[index].proposals}'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Messages'),
                          Text('${projects[index].messages}'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Hired'),
                          Text('${projects[index].hiredCount}'),
                        ],
                      ),
                    ],
                  ),
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
            ),
            Divider(
                height: 17,
                color: Colors.grey), // Add a divider between projects
          ],
        );
      },
    );
  }
}
