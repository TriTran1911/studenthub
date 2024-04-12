import 'package:flutter/material.dart';

class User {
  static int? id;
  static String? email;
  static String? password;
  static String? fullname;
  static int? role;
  static Company? company;
  static Student? student;
}

class Company {
  static int? id;
  static String? companyName;
  static int? size;
  static String? website;
  static String? description;
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
  static int? id;
  static DateTime? createAt;
  static DateTime? updateAt;
  static DateTime? deleteAt;
  static String? languageName;
  static String? level;
}

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
