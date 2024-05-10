import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/chatController.dart';
import 'package:studenthub/connection/server.dart';
import 'package:studenthub/screens/HomePage/message/widgets/ChatReceivedMessage.dart';
import 'package:studenthub/screens/HomePage/message/widgets/ChatSentMessage.dart';

class ChatSentScheduleBox extends StatefulWidget {
  final String content;
  final bool isSender;
  final int idInterview;
  final int disableFlag;

  const ChatSentScheduleBox(
      {Key? key,
      required this.content,
      required this.isSender,
      required this.idInterview,
      required this.disableFlag})
      : super(key: key);

  @override
  State<ChatSentScheduleBox> createState() => _ChatSentScheduleBoxState();
}

class _ChatSentScheduleBoxState extends State<ChatSentScheduleBox> {
  late Interview interview;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  Future<Interview> getInterview() async {
    var response = await Connection.getRequest(
        '/api/interview/${widget.idInterview.toString()}', {});
    var responseDecoded = jsonDecode(response);

    if (responseDecoded['result'] != null) {
      interview = Interview.fromJson(responseDecoded['result']);
      print('Success to get interview');
    } else {
      throw Exception('Failed to get interview');
    }
    return interview;
  }

  Future<void> editInterview() async {
    var data = {
      'title': Schedule.title,
      'startTime':
          '${Schedule.startDateText.toString()}T${Schedule.startTimeText.toString()}Z',
      'endTime':
          '${Schedule.endDateText.toString()}T${Schedule.endTimeText.toString()}Z',
    };

    var response = await Connection.patchRequest(
        '/api/interview/${widget.idInterview}', data);
    var responseDecoded = response;
    if (responseDecoded != null) {
      print('Success to edit interview');
    } else {
      throw Exception('Failed to edit interview');
    }
  }

  @override
  void initState() {
    super.initState();
    interview = Interview(
        id: 0,
        title: '',
        startTime: '',
        endTime: '',
        disableFlag: 0,
        meetingRoomId: 0,
        createdAt: '',
        updatedAt: '',
        deletedAt: '');
  }

  @override
  Widget build(BuildContext context) {
    String firstElement = widget.content.split('\n').first;
    String remainingElements = widget.content.split('\n').skip(1).join('\n');

    print(widget.idInterview.toString() +
        '   disable: ' +
        widget.disableFlag.toString());

    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: widget.isSender == true
            ? ChatSentMessage(message: firstElement)
            : ChatReceivedMessage(message: firstElement),
      ),
      Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              remainingElements,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 150),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.disableFlag == 0) ...[
                    ElevatedButton(
                      onPressed: () {},
                      child:
                          Text('Join', style: TextStyle(color: Colors.white)),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Select an option"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // ListTile(
                                  //   title: Text("Reschedule the meeting"),
                                  //   onTap: () {
                                  //     getInterview().then((value) {
                                  //       setState(() {
                                  //         interview = value;
                                  //       });
                                  //     });

                                  //     Navigator.pop(context);
                                  //   },
                                  // ),
                                  ListTile(
                                    title: Text("Cancel"),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ] else
                    Text('The meeting is canceled',
                        style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
