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
  late List<Project> projects = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    intitialData();
    _searchController = TextEditingController();
  }

  Future<void> intitialData() async {
    List<Project> tmp = await fetchDataProjects();
    setState(() {
      projects = tmp;
    });
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
                    // _showFilterOptions(context);
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
        final createdAt = projects[index].createdAt;
        final daysSinceCreation = createdAt != null
            ? DateTime.now().difference(createdAt).inDays
            : 0; // Default value if createdAt is null

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Column(
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
                      'Time: ${projects[index].getProjectScopeAsString()}, ${projects[index].numberOfStudents} students needed',
                    ),
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
            ],
          ),
        );
      },
    );
  }

  void _filterProjects(String query) {
    setState(() {
      projects = Project.projects
          .where((project) =>
              project.title?.toLowerCase()?.contains(query.toLowerCase()) ??
              false)
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

  // void _applyFilters(
  //   int? projectScopeFlag,
  //   int? studentsNeeded,
  //   int? proposalsLessThan,
  // ) {
  //   setState(() {
  //     projects = Project.projects.where((project) {
  //       bool passFilter = true;
  //       if (projectScopeFlag != null) {
  //         switch (projectScopeFlag) {
  //           case 0:
  //             passFilter = passFilter && project.projectScopeFlag == 0;
  //             break;
  //           case 1:
  //             passFilter = passFilter && project.projectScopeFlag == 1;
  //             break;
  //           case 2:
  //             passFilter = passFilter && project.projectScopeFlag == 2;
  //             break;
  //           case 3:
  //             passFilter = passFilter && project.projectScopeFlag == 3;
  //             break;
  //           default:
  //             passFilter = false; // Assuming other cases should be filtered out
  //             break;
  //         }
  //       }
  //       if (studentsNeeded != null) {
  //         passFilter = passFilter && project.numberOfStudents! >= studentsNeeded;
  //       }
  //       if (proposalsLessThan != null) {
  //         passFilter = passFilter && project.countProposals! < proposalsLessThan;
  //       }
  //       return passFilter;
  //     }).toList();
  //   });
  // }

  // void _showFilterOptions(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return FilterProjectsPage(
  //         applyFilters: _applyFilters,
  //       );
  //     },
  //   );
  // }

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

  Future<List<Project>> fetchDataProjects() async {
    return await Project.getAllProjectsData();
  }
}
