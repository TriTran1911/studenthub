import 'package:flutter/material.dart';

List<String> noti = [
  'You have submitted to join project "Javis - AI Copilot"',
  'You have invited to interview for project "Javis - AI Copilot" at 14:00 March 20, Thursday',
  'You have offered to join project "Javis - AI Copilot"',
  'Alex Jor\nHow are you doing?',
];

List<Map<String, dynamic>> notifications = [];

// initial notifications

void initialNotifications() {
  notifications = [
    {
      'type': noti[0],
      'icon': Icons.assignment_turned_in,
      'date': '20/03/2022'
    },
    {
      'type': noti[1],
      'icon': Icons.settings,
      'date': '20/03/2022'
    },
    {
      'type': noti[2],
      'icon': Icons.settings,
      'date': '20/03/2022'
    },
    {
      'type': noti[3],
      'icon': Icons.chat_bubble,
      'date': '20/03/2022'
    },
  ];
}