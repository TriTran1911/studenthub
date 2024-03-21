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

// initial projects
void initialProjects() {
  Project.projects = [
    Project(
      'Javis - AI Copilot',
      ProjectDuration.oneToThreeMonths,
      [
        'A.I. Copilot for software development',
        'A.I. pair programming',
        'A.I. code review',
      ],
      'Open',
      DateTime.now().subtract(Duration(days: 1)),
      proposals: 3,
      messages: 2,
      hiredCount: 1,
      studentsNeeded: 2,
      timeNeeded: '1-3 months',
    ),
    // different project name
    Project(
      'Senior frontend developer (Fintech)',
      ProjectDuration.threeToSixMonths,
      [
        'We are looking for a senior frontend developer to join our team',
        'You will be responsible for building the client-side of our web applications',
        'You should be able to translate our company and customer needs into functional and appealing interactive applications',
      ],
      'Open',
      DateTime.now().subtract(Duration(days: 2)),
      proposals: 5,
      messages: 3,
      hiredCount: 2,
      studentsNeeded: 3,
      timeNeeded: '3-6 months',
    ),
    Project(
      'Senior backend developer (Fintech)',
      ProjectDuration.threeToSixMonths,
      [
        'We are looking for a senior backend developer to join our team',
        'You will be responsible for building the server-side of our web applications',
        'You should be able to translate our company and customer needs into functional and appealing interactive applications',
      ],
      'Open',
      DateTime.now().subtract(Duration(days: 3)),
      proposals: 4,
      messages: 4,
      hiredCount: 3,
      studentsNeeded: 4,
      timeNeeded: '3-6 months',
    ),
    Project(
      'Senior fullstack developer (Fintech)',
      ProjectDuration.threeToSixMonths,
      [
        'We are looking for a senior fullstack developer to join our team',
        'You will be responsible for building the client-side and server-side of our web applications',
        'You should be able to translate our company and customer needs into functional and appealing interactive applications',
      ],
      'Open',
      DateTime.now().subtract(Duration(days: 4)),
      proposals: 6,
      messages: 5,
      hiredCount: 4,
      studentsNeeded: 5,
      timeNeeded: '3-6 months',
    ),
  ];
}
