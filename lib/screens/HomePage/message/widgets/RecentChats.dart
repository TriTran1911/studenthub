import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/modelController.dart';
import 'package:studenthub/connection/server.dart';
import 'package:studenthub/screens/HomePage/message/pages/ChatDetailPage.dart';

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
      print('model id: ' + modelController.user.id.toString());
      for (var message in responseDecoded['result']) {
        messages.add(Message.fromJson(message));
        if (message['createAt'] != null) {
          print("CreatAt: " + message['createAt']);
        } else {
          print("CreatAt: Value is null");
        }
        print("Sender: " + message['sender']['id'].toString());
        print("Receiver: " + message['project']['id'].toString());
      }
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailPage(
                        senderId:
                            messages[i].sender!.id! == modelController.user.id
                                ? messages[i].sender!.id!
                                : messages[i].receiver!.id!,
                        receiverId:
                            messages[i].receiver!.id! == modelController.user.id
                                ? messages[i].sender!.id!
                                : messages[i].receiver!.id!,
                        projectId: messages[i].project!.id!,
                        senderName: modelController.user.fullname!,
                        receiverName:
                            messages[i].receiver!.id! == modelController.user.id
                                ? messages[i].sender!.fullname!
                                : messages[i].receiver!.fullname!,
                      ),
                    ),
                  );
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
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                messages[i].sender!.id ==
                                        modelController.user.id
                                    ? messages[i].receiver!.fullname
                                    : messages[i].sender!.fullname,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                messages[i].project?.title ?? 'Project Name',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 5),
                              Expanded(
                                child: Text(
                                  messages[i].sender!.id ==
                                          modelController.user.id
                                      ? 'You: ' + (messages[i].content ?? '')
                                      : (messages[i].content ?? ''),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          messages[i].createAt ?? 'Time',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
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
