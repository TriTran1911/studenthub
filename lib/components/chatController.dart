import 'package:flutter/material.dart';

class Schedule extends ChangeNotifier {
  static String title = 'Catch up meeting';
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

  void rescheduleMeeting() {
    isCancel = false;
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
class Message {
  final String content;
  final MessageType type;

  Message({required this.content, required this.type});
}
