enum ProjectTool { Edit, Remove }
enum ProjectDuration {
  oneToThreeMonths,
  threeToSixMonths,
}

class Project {
  String title;
  ProjectDuration duration;
  String description;
  String status;

  Project(this.title, this.duration, this.description, this.status);

  static List<Project> projects = [];

  static void addProject(String title, ProjectDuration duration, String description, String status) {
    projects.add(Project(title, duration, description, status));
  }

  static void removeProject(Project project) {
    projects.remove(project);
  }
}
