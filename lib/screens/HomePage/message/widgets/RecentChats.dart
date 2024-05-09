import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:studenthub/components/chatController.dart';
import 'package:studenthub/components/modelController.dart';
import 'package:studenthub/connection/server.dart';
import 'package:studenthub/connection/socket.dart';
import 'package:studenthub/screens/HomePage/message/pages/ChatDetailPage.dart';

class RecentChats extends StatefulWidget {
  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  List<Message> messages = [];
  late Future<List<Message>> listMessage;
  late IO.Socket socket;
  late MessageNotification messageNotification;

  Future<List<Message>> getRecentChats() async {
    var response = await Connection.getRequest('/api/message', {});
    var responseDecoded = jsonDecode(response);

    if (responseDecoded['result'] != null) {
      print('Success to load message');
      for (var message in responseDecoded['result']) {
        messages.add(Message.fromJson(message));
      }
      return messages;
    } else {
      throw Exception('Failed to load message');
    }
  }

  void connect() {
    socket = SocketService().connectSocket();

    socket.connect();

    socket.onConnect((data) => {
          print('Connected'),
        });

    socket.on('RECEIVE_MESSAGE', (data) {
      print("New chat: $data");
      messageNotification = MessageNotification.fromJson(data['notification']);
      print('Sender: ${messageNotification.senderId}');
      print('Receiver: ${messageNotification.receiverId}');
      // check who is the sender in list of users in messages
      for (int i = 0; i < messages.length; i++) {
        if ((messageNotification.senderId == modelController.user.id &&
                messageNotification.receiverId == messages[i].receiver!.id) ||
            (messageNotification.senderId == messages[i].receiver!.id &&
                messageNotification.receiverId == modelController.user.id)) {
          setState(() {
            messages[i].content = messageNotification.content;
            messages[i].createdAt = messageNotification.createdAt;
            messages[i].sender =
                messageNotification.senderId == modelController.user.id
                    ? modelController.user
                    : messages[i].receiver;
            messages[i].receiver =
                messageNotification.receiverId == modelController.user.id
                    ? modelController.user
                    : messages[i].receiver;
          });
          break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    listMessage = getRecentChats();
    listMessage.then((messages) {
      setState(() {
        this.messages = messages;
      });
    });

    connect();
    print('Hanlde new message');
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
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
                          isSameTime(DateTime.parse(messages[i].createdAt!)) ==
                                  1
                              ? "${DateFormat('HH:mm').format(DateTime.parse(messages[i].createdAt!))} "
                              : (isSameTime(DateTime.parse(
                                          messages[i].createdAt!)) ==
                                      2
                                  ? "${DateFormat('dd/MM').format(DateTime.parse(messages[i].createdAt!))} "
                                  : "${DateFormat('dd/MM/yyyy').format(DateTime.parse(messages[i].createdAt!))} "),
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

int isSameTime(DateTime s) {
  if (DateTime.now().year == s.year &&
      DateTime.now().month == s.month &&
      DateTime.now().day == s.day) {
    return 1;
  } else if (DateTime.now().year == s.year && DateTime.now().day != s.day) {
    return 2;
  }
  return 0;
}
