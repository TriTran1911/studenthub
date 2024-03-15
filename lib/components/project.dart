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
  bool isFavorite; // Indicates whether the project is favorited

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
    this.isFavorite = false,
  });

  static List<Project> projects = [];

  static void addProject(String title, ProjectDuration duration,
      List<String> description, String status, DateTime creationDate,
      {int proposals = 0,
      int messages = 0,
      int hiredCount = 0,
      int studentsNeeded = 0,
      String timeNeeded = ''}) {
    projects.add(Project(title, duration, description, status, creationDate,
        proposals: proposals,
        messages: messages,
        hiredCount: hiredCount,
        studentsNeeded: studentsNeeded,
        timeNeeded: timeNeeded));
  }

  static void removeProject(Project project) {
    projects.remove(project);
  }

  static Widget buildProjectsList(List<Project> projects) {
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
                          Text('${projects[index].proposals}'),
                          Text('Proposals'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('${projects[index].messages}'),
                          Text('Messages'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('${projects[index].hiredCount}'),
                          Text('Hired'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {
                  _showBottomSheet(context);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProposalsPage(project: projects[index]),
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

  static void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 430,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'View Proposals', 
                  style: TextStyle(
                    color: Colors.blue, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,)),
                onTap: () {
                },
              ),
              ListTile(
                title: Text('View Messages', 
                  style: TextStyle(
                    color: Colors.blue, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,)),
                onTap: () {
                },
              ),
              ListTile(
                title: Text('View Hired', 
                  style: TextStyle(
                    color: Colors.blue, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,)),
                onTap: () {
                },
              ),
              Divider(height: 17, color: Colors.grey),
              ListTile(
                title: Text('View job posting', 
                  style: TextStyle(
                    color: Colors.blue, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,)),
                onTap: () {
                },
              ),
              ListTile(
                title: Text('Edit posting', 
                  style: TextStyle(
                    color: Colors.blue, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,)),
                onTap: () {
                },
              ),
              ListTile(
                title: Text('Remove posting', 
                  style: TextStyle(
                    color: Colors.blue, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,)),
                onTap: () {
                },
              ),
              Divider(height: 17, color: Colors.grey),
              ListTile(
                title: Text('Start working this project', 
                  style: TextStyle(
                    color: Colors.blue, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,)),
                onTap: () {
                },
              ),
            ],
          ),
        );
      },
    );
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
                  projects[index].isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: projects[index].isFavorite ? Colors.red : null,
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

  static void _toggleFavorite(Project project) {
    project.isFavorite = !project.isFavorite;
  }
}
