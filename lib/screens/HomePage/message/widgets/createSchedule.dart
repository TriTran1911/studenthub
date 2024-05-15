import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/components/chatController.dart';
import 'package:studenthub/connection/server.dart';

class CreateSchedule extends StatefulWidget {
  final List<MessageDetail> messages;
  final int projectId;
  final int receiverId;
  final int senderId;

  const CreateSchedule(
      {Key? key,
      required this.messages,
      required this.projectId,
      required this.senderId,
      required this.receiverId})
      : super(key: key);

  @override
  _CreateSchedulePageState createState() => _CreateSchedulePageState();
}

class _CreateSchedulePageState extends State<CreateSchedule> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  Future<void> postInterview() async {
    var data = {
      'title': Schedule.title,
      'content': Schedule.content,
      'startTime':
          '${Schedule.startDateText.toString()}T${Schedule.startTimeText.toString()}Z',
      'endTime':
          '${Schedule.endDateText.toString()}T${Schedule.endTimeText.toString()}Z',
      'projectId': widget.projectId,
      'senderId': widget.senderId,
      'receiverId': widget.receiverId,
      'meeting_room_code': generateRandomString(11),
      'meeting_room_id': generateRandomString(11),
      'expired_at':
          '${Schedule.endDateText.toString()}T${Schedule.endTimeText.toString()}Z',
    };
    var response = await Connection.postRequest('/api/interview', data);
    var responseDecoded = jsonDecode(response);

    if (responseDecoded != null) {
      print('Success to post interview');
    } else {
      throw Exception('Failed to post interview');
    }
  }

  String generateRandomString(int length) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Schedule a interview",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Content'),
              onChanged: (value) {
                Schedule.content = value;
              },
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                Schedule.title = value;
              },
            ),
            SizedBox(height: 10),
            Text("Start time"),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final pickedStartDate = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedStartDate != null &&
                          pickedStartDate != startDate) {
                        setState(() {
                          startDate = pickedStartDate;
                          Schedule.startDateText =
                              DateFormat('yyyy-MM-dd').format(startDate);
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 10),
                        Text(
                          DateFormat('dd/MM/yyyy').format(startDate.toLocal()),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () async {
                    final pickedStartTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(startDate),
                    );
                    if (pickedStartTime != null) {
                      setState(() {
                        startDate = DateTime(
                          startDate.year,
                          startDate.month,
                          startDate.day,
                          pickedStartTime.hour,
                          pickedStartTime.minute,
                        );
                        Schedule.startTimeText =
                            DateFormat('HH:mm:ss').format(startDate);
                      });
                    }
                  },
                ),
                Text(
                  '${DateFormat('HH:mm').format(startDate)}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("End time"),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final pickedEndDate = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedEndDate != null && pickedEndDate != endDate) {
                        setState(() {
                          endDate = pickedEndDate;
                          Schedule.endDateText =
                              DateFormat('yyyy-MM-dd').format(endDate);
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 10),
                        Text(
                          DateFormat('dd/MM/yyyy').format(endDate.toLocal()),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () async {
                    final pickedEndTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(endDate),
                    );
                    if (pickedEndTime != null) {
                      setState(() {
                        endDate = DateTime(
                          endDate.year,
                          endDate.month,
                          endDate.day,
                          pickedEndTime.hour,
                          pickedEndTime.minute,
                        );
                        Schedule.endTimeText =
                            DateFormat('HH:mm:ss').format(endDate);
                      });
                    }
                  },
                ),
                Text(
                  '${DateFormat('HH:mm').format(endDate)}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
                "Duration: ${endDate.difference(startDate).inMinutes} minutes"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel", style: TextStyle(color: Colors.blue)),
        ),
        ElevatedButton(
          onPressed: () {
            postInterview();
            Navigator.pop(context);
          },
          child: Text("Send Invite", style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
