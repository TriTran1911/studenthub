import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/modelController.dart';
import 'package:studenthub/connection/server.dart';

class RecentChats extends StatefulWidget {
  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  List<Message> messages = [];
  late Future<List<Message>> listMessage;

  Future<List<Message>> getRecentChats() async {
    var response = await Connection.getRequest('/api/message', {});
    var responseDecoded = jsonDecode(response);

    List<Message> messages = [];
    if (responseDecoded['result'] != null) {
      print('Success to load message');
      for (var message in responseDecoded['result']) {
        messages.add(Message.fromJson(message));
      }
      print("Messages:");
      print(messages);
      return messages;
    } else {
      throw Exception('Failed to load message');
    }
  }

  @override
  void initState() {
    super.initState();
    listMessage = getRecentChats();
    listMessage.then((messages) {
      setState(() {
        this.messages = messages;
      });
      print('list mess: ${messages[0].id}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 10,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < messages.length; i++)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "chatDetailPage");
                },
                child: Container(
                  height: 65,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Image.asset(
                            'images/siu.jpg',
                            width: 55,
                            height: 55,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3),
                            Text(
                              messages[i].sender!.id == modelController.user.id
                                  ? messages[i].receiver!.fullname
                                  : messages[i].sender!.fullname,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              messages[i].sender!.id == modelController.user.id
                                  ? 'You: ' + (messages[i].content ?? '')
                                  : (messages[i].content ?? ''),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '10:00',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 23,
                              height: 23,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
