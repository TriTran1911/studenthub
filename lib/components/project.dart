import 'package:flutter/material.dart';
import '/screens/Action/projectTab.dart';

enum ProjectTool { Edit, Remove }

enum ProjectDuration {
  oneToThreeMonths,
  threeToSixMonths,
}

class Project {
  String title;
  ProjectDuration duration;
  List<String> description;
  String status;
  int members;
  DateTime creationDate;
  int proposals; // Integer representing the number of proposals
  int messages; // Integer representing the number of messages
  int hiredCount; // Integer representing the number of times hired

  Project(this.title, this.duration, this.description, this.status, this.creationDate, 
      {this.members = 0, this.proposals = 0, this.messages = 0, this.hiredCount = 0});

  void setTitle(String newTitle) {
    title = newTitle;
  }

  void setDuration(ProjectDuration newDuration) {
    duration = newDuration;
  }

  void setDescription(List<String> newDescription) {
    description = newDescription;
  }

  void setStatus(String newStatus) {
    status = newStatus;
  }

  void setMembers(int newMembers) {
    members = newMembers;
  }

  void setCreationDate(DateTime newCreationDate) {
    creationDate = newCreationDate;
  }

  void setProposals(int newProposals) {
    proposals = newProposals;
  }

  void setMessages(int newMessages) {
    messages = newMessages;
  }

  void setHiredCount(int newHiredCount) {
    hiredCount = newHiredCount;
  }

  static List<Project> projects = [];

  static void addProject(Project project) {
    projects.add(project);
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
                color: Colors.grey), // Add a divider between projects
          ],
        );
      },
    );
  }
}
