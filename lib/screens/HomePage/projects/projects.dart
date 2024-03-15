import 'package:flutter/material.dart';
import '/components/project.dart';
import 'projectDetail.dart';
import 'favoriteList.dart';
import 'filterProject.dart';

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

    // Initialize the projects list
    projects = Project.projects;

    // Initialize the search controller
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
            child: Project.buildProjectsListWithoutMessagesHired(
              projects,
              _handleProjectTool,
              _selectProject,
            ),
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
      MaterialPageRoute(
          builder: (context) => ProjectDetailPage(project: project)),
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
      Project.projects.where((project) => Project.isFavorite(project)).toList();

  // Navigate to a new page to display favorite projects
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FavoriteProjectsPage(
        projects: favoriteProjects,
        handleProjectTool: _handleProjectTool,
        selectProject: _selectProject,
      ),
    ),
  );
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
      // Apply filters to the projects list
      // Update the projects list based on the selected filters
      projects = Project.projects.where((project) {
        bool passFilter = true;
        if (projectDuration != null) {
          switch (project.duration) {
            case ProjectDuration.oneToThreeMonths:
              passFilter = passFilter && projectDuration.inDays <= 90;
              break;
            case ProjectDuration.threeToSixMonths:
              passFilter = passFilter &&
                  projectDuration.inDays > 90 &&
                  projectDuration.inDays <= 180;
              break;
            // Add cases for other project durations as needed
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
}
