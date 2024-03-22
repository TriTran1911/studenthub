import 'package:flutter/material.dart';
import '/components/project.dart';
import 'projectDetail.dart';
import 'favoriteList.dart';
import 'filterProject.dart';

import '/components/proposer.dart';
import '/screens/Action/home.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late List<Project> projects;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    projects = Project.projects;
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildSearchBar(),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterOptions(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildProjectsListWithoutMessagesHired(),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: FloatingActionButton(
          onPressed: () {
            _showFavoriteProjects(context);
          },
          child: Icon(Icons.favorite, color: Color.fromARGB(255, 250, 24, 24)),
          elevation: 0,
          mini: true,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
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
    );
  }

  Widget _buildProjectsListWithoutMessagesHired() {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
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
                children:
                  [
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
                  color:
                      Project.isFavorite(projects[index]) ? Colors.red : null,
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

  void _filterProjects(String query) {
    setState(() {
      projects = Project.projects
          .where((project) =>
              project.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectProject(Project project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailPage(project: project),
      ),
    ).then((value) {
      setState(() {
        // Check if the project is now favorite or not
        if (Project.isFavorite(project)) {
          // If the project is now favorite, refresh the list of projects
          projects = Project.projects.map((p) {
            if (p == project) return project;
            return p;
          }).toList();
        }
      });
    });
  }

  void _toggleFavorite(Project project) {
    setState(() {
      Project.toggleFavorite(project);
    });
  }

  void _showFavoriteProjects(BuildContext context) {
    List<Project> favoriteProjects = Project.projects
        .where((project) => Project.isFavorite(project))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoriteProjectsPage(
          projects: favoriteProjects,
          handleProjectTool: _handleProjectTool,
          selectProject: _selectProject,
        ),
      ),
    ).then((value) {
      // Update the list of favorite projects when returning from FavoriteProjectsPage
      setState(() {
        favoriteProjects = Project.projects
            .where((project) => Project.isFavorite(project))
            .toList();
      });
    });
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterProjectsPage(
          applyFilters: _applyFilters,
        );
      },
    );
  }

  void _applyFilters(
      Duration? projectDuration, int? studentsNeeded, int? proposalsLessThan) {
    setState(() {
      projects = Project.projects.where((project) {
        bool passFilter = true;
        if (projectDuration != null) {
          switch (project.duration) {
            case ProjectDuration.oneToThreeMonths:
              passFilter = passFilter && projectDuration.inDays <= 90;
              break;
            case ProjectDuration.threeToSixMonths:
              passFilter= passFilter &&
                  projectDuration.inDays > 90 &&
                  projectDuration.inDays <= 180;
              break;
          }
        }
        if (studentsNeeded != null) {
          passFilter = passFilter && project.studentsNeeded >= studentsNeeded;
        }
        if (proposalsLessThan != null) {
          passFilter = passFilter && project.proposals < proposalsLessThan;
        }
        return passFilter;
      }).toList();
    });
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
}

void main() {
  initialProposers();
  initialProjects();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
