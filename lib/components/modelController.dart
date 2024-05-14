import 'package:flutter/material.dart';
import 'package:studenthub/components/chatController.dart';

class User {
  int id;
  String email;
  String password;
  String fullname;
  List<int> roles;
  Company company;
  Student student;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.fullname,
    required this.roles,
    required this.company,
    required this.student,
  });

  User.fromMessage(Map<String, dynamic> json)
      : id = json['id'],
        fullname = json['fullname'],
        email =
            '', // You'll need to update these with actual values from the json map
        password = '',
        roles = [],
        company =
            Company(), // You'll need to update these with actual values from the json map
        student =
            Student(); // You'll need to update these with actual values from the json map

  User.fromNotification(Map<String, dynamic> json)
      : id = json['id'],
        fullname = '',
        email = '',
        password = '',
        roles = [],
        company =
            Company(), // You'll need to update these with actual values from the json map
        student =
            Student(); // You'll need to update these with actual values from the json map
}

class ModelController {
  late User user;
  static final ModelController _instance = ModelController._internal();

  factory ModelController() {
    return _instance;
  }

  ModelController._internal() {
    user = User(
      id: 0,
      email: '',
      password: '',
      fullname: '',
      roles: [],
      company: Company(),
      student: Student(),
    );
  }
}

ModelController modelController = ModelController();

class Company {
  static int? id;
  static String? companyName;
  static int? size;
  static String? website;
  static String? description;
}

class Proposal {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final int? projectId;
  final int? studentId;
  final String? coverLetter;
  int? statusFlag;
  int? disableFlag;
  Project? project;
  Student? student;

  Proposal(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.projectId,
      this.studentId,
      this.coverLetter,
      this.statusFlag,
      this.disableFlag,
      this.project,
      this.student});

  factory Proposal.formAllProposal(Map<String, dynamic> json) {
    return Proposal(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      projectId: json['projectId'],
      studentId: json['studentId'],
      coverLetter: json['coverLetter'],
      statusFlag: json['statusFlag'],
      disableFlag: json['disableFlag'],
      project: Project.formProject(json['project']),
    );
  }

  factory Proposal.formGetByProjectId(Map<String, dynamic> json) {
    return Proposal(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      projectId: json['projectId'],
      studentId: json['studentId'],
      coverLetter: json['coverLetter'],
      statusFlag: json['statusFlag'],
      disableFlag: json['disableFlag'],
      student: Student.fromJson(json['student']),
    );
  }

  static List<Proposal> buildListGetByProjectId(List<dynamic> list) {
    List<Proposal> proposalList = [];
    for (var proposal in list) {
      proposalList.add(Proposal.formGetByProjectId(proposal));
    }
    return proposalList;
  }

  static List<Proposal> buildListProposal(List<dynamic> list) {
    List<Proposal> proposalList = [];
    for (var proposal in list) {
      proposalList.add(Proposal.formAllProposal(proposal));
    }
    return proposalList;
  }
}

class Project {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? companyId;
  int? projectScopeFlag;
  String? title;
  String? description;
  int? numberOfStudents;
  int? typeFlag;
  int? countProposals;
  List<Proposal>? proposals;
  int? countMessages;
  int? countHired;
  bool? isFavorite;
  int? status;

  Project(
      {this.id,
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
      this.proposals,
      this.countMessages,
      this.countHired,
      this.isFavorite,
      this.status});

  factory Project.formAllProject(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      projectScopeFlag: json['projectScopeFlag'],
      title: json['title'],
      description: json['description'],
      numberOfStudents: json['numberOfStudents'],
      typeFlag: json['typeFlag'],
      countProposals: json['countProposals'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      status: json['status'] ?? 0,
    );
  }

  factory Project.formProject(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      companyId: json['companyId'],
      projectScopeFlag: json['projectScopeFlag'],
      title: json['title'],
      description: json['description'],
      numberOfStudents: json['numberOfStudents'],
      typeFlag: json['typeFlag'],
      status: json['status'],
    );
  }

  static List<Project> buildListProject(List<dynamic> list) {
    List<Project> projectList = [];
    for (var project in list) {
      projectList.add(Project.formAllProject(project));
    }
    return projectList;
  }
}

class Student {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? email;
  String? fullname;
  int? userId;
  TechStack? techStack;
  List<SkillSet>? skillSets;
  List<dynamic>? proposals;
  List<Education>? educations;
  List<Language>? languages;
  List<Experience>? experiences;

  Student(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.techStack,
      this.email,
      this.skillSets,
      this.fullname,
      this.userId,
      this.proposals,
      this.educations,
      this.languages,
      this.experiences});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      fullname: json['user']['fullname'],
      userId: json['userId'],
      techStack: json['techStack'] != null
          ? TechStack.fromJson(json['techStack'])
          : null,
      skillSets: json['skillSets'] != null
          ? (json['skillSets'] as List)
              .map((e) => SkillSet.fromJson(e))
              .toList()
          : null,
      educations: json['educations'] != null
          ? (json['educations'] as List)
              .map((e) => Education.fromJson(e))
              .toList()
          : null,
    );
  }

  factory Student.formStudentInfo(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      email: json['email'],
      fullname: json['fullname'],
      techStack: json['techStack'] != null
          ? TechStack.fromJson(json['techStack'])
          : null,
      skillSets: json['skillSets'] != null
          ? (json['skillSets'] as List)
              .map((e) => SkillSet.fromJson(e))
              .toList()
          : null,
      educations: json['educations'] != null
          ? (json['educations'] as List)
              .map((e) => Education.fromJson(e))
              .toList()
          : null,
      languages: json['languages'] != null
          ? (json['languages'] as List)
              .map((e) => Language.fromJson(e))
              .toList()
          : null,
      experiences: json['experiences'] != null
          ? (json['experiences'] as List)
              .map((e) => Experience.fromJson(e))
              .toList()
          : null,
    );
  }

  static List<Student> buildListStudent(List<dynamic> list) {
    List<Student> studentList = [];
    for (var student in list) {
      studentList.add(Student.fromJson(student));
    }
    return studentList;
  }
}

class TechStack {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? name;

  TechStack(
      {this.id, this.createdAt, this.updatedAt, this.deletedAt, this.name});

  factory TechStack.fromJson(Map<String, dynamic> json) {
    return TechStack(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      name: json['name'],
    );
  }
}

class SkillSet {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? name;

  SkillSet(
      {this.id, this.createdAt, this.updatedAt, this.deletedAt, this.name});

  factory SkillSet.fromJson(Map<String, dynamic> json) {
    return SkillSet(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      name: json['name'],
    );
  }

  static List<SkillSet> buildListSkillSet(List<dynamic> list) {
    List<SkillSet> skillSetList = [];
    for (var skillSet in list) {
      skillSetList.add(SkillSet.fromJson(skillSet));
    }
    return skillSetList;
  }
}

class Language {
  final int? id;
  final String? createAt;
  final String? updateAt;
  final String? deleteAt;
  String? languageName;
  String? level;

  Language(
      {this.id,
      this.createAt,
      this.updateAt,
      this.deleteAt,
      this.languageName,
      this.level});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      deleteAt: json['deleteAt'],
      languageName: json['languageName'],
      level: json['level'],
    );
  }
}

// generate languageName and level
class LanguageList {
  static List<String> languageName = [
    'Afrikaans',
    'Albanian',
    'Arabic',
    'Armenian',
    'Basque',
    'Bengali',
    'Bulgarian',
    'Catalan',
    'Cambodian',
    'Chinese (Mandarin)',
    'Croatian',
    'Czech',
    'Danish',
    'Dutch',
    'English',
    'Estonian',
    'Fiji',
    'Finnish',
    'French',
    'Georgian',
    'German',
    'Greek',
    'Gujarati',
    'Hebrew',
    'Hindi',
    'Hungarian',
    'Icelandic',
    'Indonesian',
    'Irish',
    'Italian',
    'Japanese',
    'Javanese',
    'Korean',
    'Latin',
    'Latvian',
    'Lithuanian',
    'Macedonian',
    'Malay',
    'Malayalam',
    'Maltese',
    'Maori',
    'Marathi',
    'Mongolian',
    'Nepali',
    'Norwegian',
    'Persian',
    'Polish',
    'Portuguese',
    'Punjabi',
    'Quechua',
    'Romanian',
    'Russian',
    'Samoan',
    'Serbian',
    'Slovak',
    'Slovenian',
    'Spanish',
    'Swahili',
    'Swedish',
    'Tamil',
    'Tatar',
    'Telugu',
    'Thai',
    'Tibetan',
    'Tonga',
    'Turkish',
    'Ukrainian',
    'Urdu',
    'Uzbek',
    'Vietnamese',
    'Welsh',
    'Xhosa',
    'Yiddish',
    'Yoruba',
    'Zulu',
  ];
  static List<String> level = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Fluent',
  ];
}

List<String> get languages => LanguageList.languageName;
List<String> get levels => LanguageList.level;

class Education {
  final int? id;
  final String? createAt;
  final String? updateAt;
  final String? deleteAt;
  String? schoolName;
  int? startYear;
  int? endYear;

  Education(
      {this.id,
      this.createAt,
      this.updateAt,
      this.deleteAt,
      this.schoolName,
      this.startYear,
      this.endYear});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      deleteAt: json['deleteAt'],
      schoolName: json['schoolName'],
      startYear: json['startYear'],
      endYear: json['endYear'],
    );
  }
}

class Experience {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final int? studentId;
  String? title;
  String? startMonth;
  String? endMonth;
  String? description;
  List<SkillSet>? skillSets;

  Experience(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.studentId,
      this.title,
      this.startMonth,
      this.endMonth,
      this.description,
      this.skillSets});

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      studentId: json['studentId'],
      title: json['title'],
      startMonth: json['startMonth'],
      endMonth: json['endMonth'],
      description: json['description'],
      skillSets: json['skillSets'] != null
          ? (json['skillSest'] as List)
              .map((e) => SkillSet.fromJson(e))
              .toList()
          : null,
    );
  }
}

Widget loadingDialog() {
  return const AlertDialog(
    content: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    ),
  );
}

String timeDif(DateTime? createdAt) {
  final Duration difference = DateTime.now().difference(createdAt!);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    if (difference.inMinutes == 1) {
      return '${difference.inMinutes} minute ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  } else if (difference.inHours < 24) {
    if (difference.inHours == 1) {
      return '${difference.inHours} hour ago';
    } else {
      return '${difference.inHours} hours ago';
    }
  } else if (difference.inDays < 30) {
    if (difference.inDays == 1) {
      return '${difference.inDays} day ago';
    } else {
      return '${difference.inDays} days ago';
    }
  } else if (difference.inDays < 365) {
    final int months = difference.inDays ~/ 30;
    if (months == 1) {
      return '$months month ago';
    } else {
      return '$months months ago';
    }
  } else {
    final int years = difference.inDays ~/ 365;
    if (years == 1) {
      return '$years year ago';
    } else {
      return '$years years ago';
    }
  }
}

class Message {
  int? id;
  String? createdAt;
  String? content;
  User? sender;
  User? receiver;
  Interview? interview;
  Project? project;
  Notification? notifications;

  Message(
      {this.id,
      this.createdAt,
      this.content,
      this.sender,
      this.receiver,
      this.interview,
      this.project,
      this.notifications});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      createdAt: json['createdAt'],
      content: json['content'],
      sender: json['sender'] != null ? User.fromMessage(json['sender']) : null,
      receiver:
          json['receiver'] != null ? User.fromMessage(json['receiver']) : null,
      interview: json['interview'] != null
          ? Interview.fromJson(json['interview'])
          : null,
      project:
          json['project'] != null ? Project.formProject(json['project']) : null,
      notifications: json['notifications'] != null
          ? Notification.fromJson(json['notifications'])
          : null,
    );
  }
}

class Notification {
  int? id;
  String? notifyFlag;

  Notification({this.id, this.notifyFlag});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      notifyFlag: json['notifyFlag'],
    );
  }
}
