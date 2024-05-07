import 'package:flutter/material.dart';

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

class Project {
  int? id;
  DateTime? createAt;
  DateTime? updateAt;
  DateTime? deleteAt;
  String? companyId;
  int? proprojectScopeFlag;
  String? title;
  String? description;
  int? numberOfStudents;
  int? typeFlag;
  int? statusFlag;

  Project(
      {this.id,
      this.createAt,
      this.updateAt,
      this.deleteAt,
      this.companyId,
      this.proprojectScopeFlag,
      this.title,
      this.description,
      this.numberOfStudents,
      this.typeFlag,
      this.statusFlag});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      deleteAt: json['deleteAt'],
      companyId: json['companyId'],
      proprojectScopeFlag: json['proprojectScopeFlag'],
      title: json['title'],
      description: json['description'],
      numberOfStudents: json['numberOfStudents'],
      typeFlag: json['typeFlag'],
      statusFlag: json['statusFlag'],
    );
  }
}

class Student {
  static int? id;
  static DateTime? createAt;
  static DateTime? updateAt;
  static DateTime? deleteAt;
  static List<TechStack>? techStack;
  static List<SkillSet>? skillSet;
  static List<dynamic>? proposals;
  static List<Education>? educations;
  static List<Language>? languages;
  static List<Experience>? experiences;
}

class TechStack {
  int? id;
  DateTime? createAt;
  DateTime? updateAt;
  DateTime? deleteAt;
  String? name;

  TechStack({this.id, this.createAt, this.updateAt, this.deleteAt, this.name});

  factory TechStack.fromJson(Map<String, dynamic> json) {
    return TechStack(
      id: json['id'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      deleteAt: json['deleteAt'],
      name: json['name'],
    );
  }
}

class SkillSet {
  int? id;
  DateTime? createAt;
  DateTime? updateAt;
  DateTime? deleteAt;
  String? name;

  SkillSet({this.id, this.createAt, this.updateAt, this.deleteAt, this.name});

  factory SkillSet.fromJson(Map<String, dynamic> json) {
    return SkillSet(
      id: json['id'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      deleteAt: json['deleteAt'],
      name: json['name'],
    );
  }
}

class Language {
  final int? id;
  final DateTime? createAt;
  final DateTime? updateAt;
  final DateTime? deleteAt;
  final String? languageName;
  final String? level;

  Language(
      {this.id,
      this.createAt,
      this.updateAt,
      this.deleteAt,
      this.languageName,
      this.level});
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
  static int? id;
  static DateTime? createAt;
  static DateTime? updateAt;
  static DateTime? deleteAt;
  static String? schoolName;
  static int? startYear;
  static int? endYear;
}

class Experience {
  static int? id;
  static DateTime? createAt;
  static DateTime? updateAt;
  static DateTime? deleteAt;
  static int? studentId;
  static String? title;
  static String? startMonth;
  static String? endMonth;
  static String? description;
  static List<SkillSet>? skillSet;
}

Widget loadingDialog() {
  return const AlertDialog(
    content: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

class Message {
  int? id;
  String? createAt;
  String? content;
  User? sender;
  User? receiver;
  bool? interview;
  Project? project;

  Message(
      {this.id,
      this.createAt,
      this.content,
      this.sender,
      this.receiver,
      this.interview,
      this.project});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      createAt: json['createAt'],
      content: json['content'],
      sender: User.fromMessage(json['sender']),
      receiver: User.fromMessage(json['receiver']),
      interview: json['interview'],
      project:
          json['project'] != null ? Project.fromJson(json['project']) : null,
    );
  }
}
