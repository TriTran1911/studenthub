import 'dart:convert';
import '/connection/http.dart';

enum ProjectTool { Edit, Remove }

class SubmittedProject {
  Project project;
  DateTime sentTime;
  String messageStatus; 

  SubmittedProject(this.project, this.sentTime, this.messageStatus);
}

class SubmittedProjects {
  static final SubmittedProjects _instance = SubmittedProjects._internal();

  factory SubmittedProjects() {
    return _instance;
  }

  SubmittedProjects._internal();

  List<SubmittedProject> submittedProjects = [];

  void addSubmittedProject(Project project, DateTime sentTime, String messageStatus) {
    submittedProjects.add(SubmittedProject(project, sentTime, messageStatus));
  }

  bool isProjectSubmitted(Project project) {
    return submittedProjects.any((submittedProject) => submittedProject.project == project);
  }
}
class Project {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  String? companyId;
  int? projectScopeFlag;
  String? title;
  String? description;
  int? numberOfStudents;
  int? typeFlag;
  int? countProposals;

  Project({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.companyId,
    this.projectScopeFlag,
    this.title,
    this.description,
    this.numberOfStudents,
    this.typeFlag,
    this.countProposals,
  });

 factory Project.fromMap(Map<String, dynamic> map) {
  return Project(
    id: map['projectId'] as int?,
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : DateTime.now(),
    updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    deletedAt: map['deletedAt'] != null ? DateTime.parse(map['deletedAt'] as String) : null,
    companyId: map['companyId'] as String?,
    projectScopeFlag: map['projectScopeFlag'] as int?,
    title: map['title'] as String,
    description: map['description'] as String,
    numberOfStudents: map['numberOfStudents'] as int?,
    typeFlag: map['typeFlag'] as int?,
    countProposals: map['countProposals'] as int?,
  );
}



  String getProjectScopeAsString() {
    switch (projectScopeFlag) {
      case 0:
        return "Less than 1 month";
      case 1:
        return "1 to 3 months";
      case 2:
        return "3 to 6 months";
      case 3:
        return "More than 6 months";
      default:
        return "Unknown";
    }
  }

  String getProjectTypeFlagAsString() {
    switch (typeFlag) {
      case 0:
        return "Working";
      case 1:
        return "Archieved";
      default:
        return "Unknown";
    }
  }

  static List<Project> projects = [];
  static List<Project> favoriteProjects = [];

  static void addProject(Project project) {
    projects.add(project);
  }

  static void removeProject(Project project) {
    projects.remove(project);
  }

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

  static List<Project> fromListMapAllProject(List<dynamic> list) {
    List<Project> result = list.map((map) => Project.fromMap(map)).toList();
    print(result.length);
    return list.map((map) => Project.fromMap(map)).toList();
  }

  static Future<List<Project>> getAllProjectsData() async {
    print('Get All Projects Data');
    try {
      var response = await Connection.getRequest('/api/project', {});
      var responseDecode = jsonDecode(response);
      if (responseDecode['result'] != null) {
        print("Connected to the server successfully");
        print("Connect server successful");
        print(responseDecode['result']);
        List<Project> projectList =
            Project.fromListMapAllProject(responseDecode['result']);
        for (Project project in projectList){
          print(project.id);
        }
        return projectList;
      } else {
        print("Failed");
        print(responseDecode);
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  void initialProjects() async {
    try {
      List<Project> projects = await getAllProjectsData();
      Project.projects.addAll(projects);
    } catch (e) {
      print('Error initializing projects: $e');
    }
  }
}


// initial submitted projects
void initialSubmittedProjects() {
  // SubmittedProjects().addSubmittedProject(Project.projects[0], DateTime.now().subtract(Duration(days: 1)), 'unread');
  // SubmittedProjects().addSubmittedProject(Project.projects[3], DateTime.now().subtract(Duration(days: 4)), 'unread');
}
