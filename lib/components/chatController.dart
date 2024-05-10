import 'package:flutter/material.dart';
import 'package:studenthub/components/modelController.dart';

class Schedule extends ChangeNotifier {
  static String title = 'Schedule a video call interview';
  static String content = '';
  static String startDateText = '';
  static String endDateText = '';
  static String startTimeText = '';
  static String endTimeText = '';
  static String duration = '';
  static bool isCancel = false;

  void cancelMeeting() {
    isCancel = true;
    notifyListeners();
  }
}

// Define a message type enumeration
enum MessageType {
  send,
  receive,
  scheduler,
}

// Define a message model to represent different types of messages
class MessageDetail {
  final String content;
  final MessageType type;

  MessageDetail({required this.content, required this.type});
}

// Define a message notification class
class MessageNotification {
  int id;
  String createdAt;
  String updatedAt;
  String? deletedAt;
  int senderId;
  int receiverId;
  int projectId;
  int? interviewId;
  String content;
  int messageFlag;
  Interview? interview;

  MessageNotification(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.deletedAt,
      required this.senderId,
      required this.receiverId,
      required this.projectId,
      required this.interviewId,
      required this.content,
      required this.messageFlag,
      required this.interview});

  factory MessageNotification.fromJson(Map<String, dynamic> json) {
    return MessageNotification(
        id: json['message']['id'],
        createdAt: json['message']['createdAt'],
        updatedAt: json['message']['updatedAt'],
        deletedAt: json['message']['deletedAt'],
        senderId: json['message']['senderId'],
        receiverId: json['message']['receiverId'],
        projectId: json['message']['projectId'],
        interviewId: json['message']['interviewId'],
        content: json['message']['content'],
        messageFlag: json['message']['messageFlag'],
        interview: json['message']['interview'] != null
            ? Interview.fromJson(json['message']['interview'])
            : null);
  }
}

// Define a interview class
class Interview {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? title;
  String? startTime;
  String? endTime;
  int? disableFlag;
  int? meetingRoomId;
  MeetingRoom? meetingRoom;
  int? senderId;
  int? receiverId;
  int? projectId;
  int? interviewId;
  String? content;
  int? messageFlag;
  String? interview;

  Interview(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.title,
      this.startTime,
      this.endTime,
      this.disableFlag,
      this.meetingRoomId,
      this.meetingRoom,
      this.senderId,
      this.receiverId,
      this.projectId,
      this.interviewId,
      this.content,
      this.messageFlag,
      this.interview});

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'] ?? null,
      createdAt: json['createdAt'] ?? null,
      updatedAt: json['updatedAt'] ?? null,
      deletedAt: json['deletedAt'] ?? null,
      title: json['title'] ?? null,
      startTime: json['startTime'] ?? null,
      endTime: json['endTime'] ?? null,
      disableFlag: json['disableFlag'] ?? null,
      meetingRoomId: json['meetingRoomId'] ?? null,
      meetingRoom: json['meetingRoom'] != null
          ? MeetingRoom.fromJson(json['meetingRoom'])
          : null,
      senderId: json['senderId'] ?? null,
      receiverId: json['receiverId'] ?? null,
      projectId: json['projectId'] ?? null,
      interviewId: json['interviewId'] ?? null,
      content: json['content'] ?? null,
      messageFlag: json['messageFlag'] ?? null,
      interview: json['interview'] ?? null,
    );
  }
}

class MeetingRoom {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? meeting_room_code;
  String? meeting_room_id;
  String? expired_at;

  MeetingRoom(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.meeting_room_code,
      this.meeting_room_id,
      this.expired_at});

  factory MeetingRoom.fromJson(Map<String, dynamic> json) {
    return MeetingRoom(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'] ?? null,
      meeting_room_code: json['meeting_room_code'],
      meeting_room_id: json['meeting_room_id'],
      expired_at: json['expired_at'],
    );
  }
}
