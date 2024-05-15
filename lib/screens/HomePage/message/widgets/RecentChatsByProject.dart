import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:studenthub/components/chatController.dart';
import 'package:studenthub/components/decoration.dart';
import 'package:studenthub/components/modelController.dart';
import 'package:studenthub/connection/server.dart';
import 'package:studenthub/connection/socket.dart';
import 'package:studenthub/screens/HomePage/message/pages/ChatDetailPage.dart';

class RecentChatsByProject extends StatefulWidget {
  final Project project;

  RecentChatsByProject({super.key, required this.project});
  @override
  State<RecentChatsByProject> createState() => _RecentChatsByProjectState();
}

class _RecentChatsByProjectState extends State<RecentChatsByProject> {
  List<Message> messages = [];
  late Future<List<Message>> listMessage;
  late IO.Socket socket;
  late MessageNotification messageNotification;
  Timer? timer;

  Future<List<Message>> getRecentChats() async {
    var response =
        await Connection.getRequest('/api/message/${widget.project.id}', {});
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
            print(
                'New message: ${messages[i].content} and ${messages[i].createdAt}');
            // sort messages by time
            messages.sort((a, b) {
              return DateTime.parse(b.createdAt!)
                  .compareTo(DateTime.parse(a.createdAt!));
            });
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
    print('projectID: $listMessage');

    connect();
    timer = Timer.periodic(Duration(seconds: 5), (timer) => connect());

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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: messages.length == 0
          ? buildCenterText('No message', 20, FontWeight.bold, Colors.black)
          : Column(
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
                              senderId: messages[i].sender!.id ==
                                      modelController.user.id
                                  ? messages[i].sender!.id
                                  : messages[i].receiver!.id,
                              receiverId: messages[i].receiver!.id ==
                                      modelController.user.id
                                  ? messages[i].sender!.id
                                  : messages[i].receiver!.id,
                              projectId: widget.project.id!,
                              senderName: modelController.user.fullname,
                              receiverName: messages[i].receiver!.id ==
                                      modelController.user.id
                                  ? messages[i].sender!.fullname
                                  : messages[i].receiver!.fullname,
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
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: Text(
                                        messages[i].sender!.id ==
                                                modelController.user.id
                                            ? 'You: ' +
                                                (messages[i].content ?? '')
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
                            // Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                timeDif(DateTime.parse(messages[i].createdAt!)),
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
