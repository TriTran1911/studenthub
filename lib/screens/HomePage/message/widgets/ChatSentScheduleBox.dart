import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/chatController.dart';

class ChatSentScheduleBox extends StatelessWidget {
  final String content;

  const ChatSentScheduleBox({Key? key, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final schedule = Provider.of<Schedule>(context);

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!Schedule.isCancel) ...[
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Join', style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                                ListTile(
                                  title: Text("Reschedule the meeting"),
                                  onTap: () {
                                    schedule.rescheduleMeeting();
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: Text("Cancel the meeting"),
                                  onTap: () {
                                    schedule.cancelMeeting();
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
                ] else ...[
                  Text('The meeting is canceled',
                      style: TextStyle(color: Colors.red)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
