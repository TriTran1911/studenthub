import 'package:flutter/material.dart';

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
  static List<Project> favoriteProjects = [];

  // Add a project to the list of projects
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
}

