import 'package:flutter/material.dart';

class User {
  static int id = 0;
  static String email = '';
  static String password = '';
  static String fullname = '';
  static List<int> roles = [];
  static Company company = Company();
  static Student student = Student();
}

class Company {
  static int? id;
  static String? companyName;
  static int? size;
  static String? website;
  static String? description;
}

class Project {
  static int? companyId;
  static int? proprojectScopeFlag;
  static String? title;
  static int? numberOfStudents;
  static String? description;
  static int? typeFlag;
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
  String? languageName;
  String? level;

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
  final int? id;
  final DateTime? createAt;
  final DateTime? updateAt;
  final DateTime? deleteAt;
  String? schoolName;
  DateTime? startYear;
  DateTime? endYear;

  Education(
      {this.id,
      this.createAt,
      this.updateAt,
      this.deleteAt,
      this.schoolName,
      this.startYear,
      this.endYear});
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
