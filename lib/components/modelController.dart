import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
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
  bool? verified;
  bool? isConfirmed;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.fullname,
    required this.roles,
    required this.company,
    required this.student,
    required this.verified,
    required this.isConfirmed,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  User.fromMessage(Map<String, dynamic> json)
      : id = json['id'],
        fullname = json['fullname'],
        email = '',
        password = '',
        roles = [],
        company = Company(),
        student = Student();

  User.fromNotification(Map<String, dynamic> json)
      : id = json['id'],
        fullname = json['fullname'],
        email = json['email'],
        password = '',
        roles = [],
        company = Company(),
        student = Student(),
        verified = json['verified'] ?? true,
        isConfirmed = json['isConfirmed'] ?? true,
        createdAt = json['createdAt'] ?? '',
        updatedAt = json['updatedAt'] ?? '',
        deletedAt = json['deletedAt'] ?? '';
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
      verified: false,
      isConfirmed: false,
      createdAt: '',
      updatedAt: '',
      deletedAt: '',
    );
  }
}

ModelController modelController = ModelController();

class Company {
  int? id;
  int? userId;
  String? email;
  String? companyName;
  String? website;
  String? description;
  String? fullname;
  int? size;

  Company(
      {this.id,
      this.userId,
      this.email,
      this.companyName,
      this.website,
      this.description,
      this.fullname,
      this.size});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      userId: json['userId'],
      email: json['email'],
      companyName: json['companyName'],
      fullname: json['fullname'],
      website: json['website'],
      description: json['description'],
      size: json['size'],
    );
  }
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
      project:
          json['project'] != null ? Project.formProject(json['project']) : null,
      student: json['student'] != null
          ? Student.fromNotification(json['student'])
          : null,
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
  String? resume;
  String? transcript;
  TechStack? techStack;
  List<SkillSet>? skillSets;
  List<dynamic>? proposals;
  List<Education>? educations;
  List<Language>? languages;
  List<Experience>? experiences;
  int? techStackId;

  Student(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.techStack,
      this.email,
      this.resume,
      this.transcript,
      this.skillSets,
      this.fullname,
      this.userId,
      this.proposals,
      this.educations,
      this.languages,
      this.experiences,
      this.techStackId,});

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

  factory Student.fromNotification(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      userId: json['userId'],
      techStackId: json['techStackId'],
      resume: json['resume'],
      transcript: json['transcript'],
      techStack: json['techStack'] != null
          ? TechStack.fromJson(json['techStack'])
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
          ? (json['skillSets'] as List)
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
    return tr('modelControl_text1');
  } else if (difference.inMinutes < 60) {
    if (difference.inMinutes == 1) {
      return '${difference.inMinutes} ' + tr('modelControl_text2');
    } else {
      return '${difference.inMinutes} ' + tr('modelControl_text3');
    }
  } else if (difference.inHours < 24) {
    if (difference.inHours == 1) {
      return '${difference.inHours} ' + tr('modelControl_text4');
    } else {
      return '${difference.inHours} ' + tr('modelControl_text5');
    }
  } else if (difference.inDays < 30) {
    if (difference.inDays == 1) {
      return '${difference.inDays} ' + tr('modelControl_text6');
    } else {
      return '${difference.inDays} ' + tr('modelControl_text7');
    }
  } else if (difference.inDays < 365) {
    final int months = difference.inDays ~/ 30;
    if (months == 1) {
      return '$months ' + tr('modelControl_text8');
    } else {
      return '$months ' + tr('modelControl_text9');
    }
  } else {
    final int years = difference.inDays ~/ 365;
    if (years == 1) {
      return '$years ' + tr('modelControl_text10');
    } else {
      return '$years ' + tr('modelControl_text11');
    }
  }
}

class Message {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? content;
  User? sender;
  User? receiver;
  int? senderId;
  int? receiverId;
  int? projectId;
  Interview? interview;
  int? interviewId;
  int? messageFlag;
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
      this.notifications,
      this.updatedAt,
      this.deletedAt,
      this.senderId,
      this.receiverId,
      this.projectId,
      this.messageFlag,
      this.interviewId});

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

  factory Message.fromNotification(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      projectId: json['projectId'],
      interviewId: json['interviewId'],
      interview: json['interview'] != null
          ? Interview.fromJson(json['interview'])
          : null,
      content: json['content'],
      messageFlag: json['messageFlag'],
      project:
          json['project'] != null ? Project.formProject(json['project']) : null,
    );
  }
}

class Notification {
  int? id;
  String? notifyFlag;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? receiverId;
  int? senderId;
  int? messageId;
  String? title;
  String? typeNotifyFlag;
  int? proposalId;
  String? content;
  Message? message;
  User? sender;
  User? receiver;
  Proposal? proposal;

  Notification(
      {this.id,
      this.notifyFlag,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.receiverId,
      this.senderId,
      this.messageId,
      this.title,
      this.typeNotifyFlag,
      this.proposalId,
      this.content,
      this.message,
      this.sender,
      this.receiver,
      this.proposal});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      notifyFlag: json['notifyFlag'],
    );
  }

  factory Notification.fromNotification(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      receiverId: json['receiverId'],
      senderId: json['senderId'],
      messageId: json['messageId'],
      title: json['title'],
      notifyFlag: json['notifyFlag'],
      typeNotifyFlag: json['typeNotifyFlag'],
      proposalId: json['proposalId'],
      content: json['content'],
      message: json['message'] != null
          ? Message.fromNotification(json['message'])
          : null,
      sender:
          json['sender'] != null ? User.fromNotification(json['sender']) : null,
      receiver: json['receiver'] != null
          ? User.fromNotification(json['receiver'])
          : null,
      proposal: json['proposal'] != null
          ? Proposal.formAllProposal(json['proposal'])
          : null,
    );
  }
}
