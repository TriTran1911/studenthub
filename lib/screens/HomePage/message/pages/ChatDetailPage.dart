import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/chatController.dart';
import 'package:studenthub/components/modelController.dart';
import 'package:studenthub/connection/server.dart';
import 'package:studenthub/connection/socket.dart';
import 'package:studenthub/screens/HomePage/message/widgets/ChatBottomSheet.dart';
import 'package:studenthub/screens/HomePage/message/widgets/ChatReceivedMessage.dart';
import 'package:studenthub/screens/HomePage/message/widgets/ChatSentMessage.dart';
import 'package:studenthub/screens/HomePage/message/widgets/ChatSentScheduleBox.dart';

class ChatDetailPage extends StatefulWidget {
  final int senderId;
  final int receiverId;
  final int projectId;
  final String senderName;
  final String receiverName;
  const ChatDetailPage({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.projectId,
    required this.senderName,
    required this.receiverName,
  });
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final ScrollController _scrollController = ScrollController();
  late IO.Socket socket;

  List<MessageDetail> _messages = [];
  List<Message> messages = [];
  late Future<List<MessageDetail>> listMessage;

  Future<List<MessageDetail>> getDetailMessage() async {
    var response = await Connection.getRequest(
        '/api/message/${widget.projectId}/user/${widget.receiverId}', {});
    var responseDecoded = jsonDecode(response);

    if (responseDecoded['result'] != null) {
      print('Success to load message');
      List<MessageDetail> messageDetails =
          responseDecoded['result'].map<MessageDetail>((message) {
        messages.add(Message.fromJson(message));
        return MessageDetail(
          content: message['content'],
          type: message['sender']['id'] == modelController.user.id
              ? MessageType.send
              : MessageType.receive,
        );
      }).toList();
      return messageDetails;
    } else {
      throw Exception('Failed to load message');
    }
  }

  void connect() {
    socket = SocketService().connectSocket();

    socket.io.options?['query'] = {'project_id': widget.projectId};
    socket.connect();

    socket.onConnect((data) => {
          print('Connected'),
        });

    // socket.onDisconnect((data) => {
    //       print('Disconnected'),
    //     });

    socket.onConnectError((data) => print('$data'));
    socket.onError((data) => print(data));

    socket.on('RECEIIVE_MESSAGE', (data) {
      print("Chat detail: $data");
      // print("Chat content: ${data['notification']['message']['content']}");
      // print("Id sender: ${data['notification']['message']['sender']['id']}");
      // setState(() {
      //   _messages.add(MessageDetail(
      //     content: data['notification']['message']['content'],
      //     type: data['notification']['message']['sender']['id'] ==
      //             modelController.user.id
      //         ? MessageType.send
      //         : MessageType.receive,
      //   ));
      //   _scrollToBottom();
      // });
    });
    socket.on('NOTI_${modelController.user.id}', (data) {
      print(data);
    });
    socket.on('ERROR', (data) {
      print(data);
    });
  }

  @override
  void initState() {
    super.initState();
    listMessage = getDetailMessage();
    listMessage.then((messageDetails) {
      setState(() {
        this._messages = messageDetails;
        _scrollToBottom();
      });
    });
    print('Sender: ${widget.senderId}');
    print('Receiver: ${widget.receiverId}');

    connect();
    print('Handle receive message');
    socket.on('RECEIIVE_MESSAGE', (data) {
      print("Chat content: ${data['notification']['message']['content']}");
      print("Id sender: ${data['notification']['message']['sender']['id']}");
      setState(() {
        _messages.add(MessageDetail(
          content: data['notification']['message']['content'],
          type: data['notification']['message']['sender']['id'] ==
                  modelController.user.id
              ? MessageType.send
              : MessageType.receive,
        ));
        _scrollToBottom();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Padding(
          padding: EdgeInsets.only(top: 5),
          child: AppBar(
            leadingWidth: 30,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.asset(
                    'images/siu.jpg',
                    width: 45,
                    height: 45,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.receiverName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Active 3m ago',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 25),
                child: IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {
                    _showVideoCallDialog(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                if (message.type == MessageType.send) {
                  return ChatSentMessage(message: message.content);
                } else if (message.type == MessageType.receive) {
                  return ChatReceivedMessage(message: message.content);
                } else if (message.type == MessageType.scheduler) {
                  return ChatSentScheduleBox(content: message.content);
                }
              },
            ),
          ),
          ChatBottomSheet(
            onMessageSent: _addMessage,
          ),
        ],
      ),
    );
  }

  // Method to add a message to the chat
  void _addMessage(String message) async {
    var data = {
      'projectId': widget.projectId,
      'receiverId': widget.receiverId,
      'senderId': widget.senderId,
      'content': message,
      'messageFlag': 0,
    };

    var response =
        await Connection.postRequest('/api/message/sendMessage', data);
    var responseDecoded = jsonDecode(response);
    if (responseDecoded != null) {
      print('Sent message successful');
    } else {
      print('Sent message failed');
    }

    setState(() {
      print('Message length: ${_messages.length}');
      _messages.add(MessageDetail(content: "$message", type: MessageType.send));
      print('Message sent: $message');
      print('Message length: ${_messages.length}');
    });
    _scrollToBottom();
  }

  // Method to show video call dialog
  void _showVideoCallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                "Schedule a video call interview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                    DateFormat('dd/MM/yyyy').format(startDate);
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(width: 10),
                              Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(startDate.toLocal()),
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
                                  DateFormat('HH:mm').format(startDate);
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
                            if (pickedEndDate != null &&
                                pickedEndDate != endDate) {
                              setState(() {
                                endDate = pickedEndDate;
                                Schedule.endDateText =
                                    DateFormat('dd/MM/yyyy').format(endDate);
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(width: 10),
                              Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(endDate.toLocal()),
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
                                  DateFormat('HH:mm').format(endDate);
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
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.blue)),
                ),
                ElevatedButton(
                  onPressed: () {
                    String content = "Fan A7 wants to schedule a meeting\n";
                    setState(() {
                      _messages.add(
                        MessageDetail(
                          content: content,
                          type: MessageType.send,
                        ),
                      );
                    });
                    // Prepare schedule information
                    Schedule.duration =
                        endDate.difference(startDate).inMinutes.toString();
                    content =
                        "${Schedule.title}        ${Schedule.duration} minutes\n";
                    content +=
                        "Start time:    ${Schedule.startDateText}  ${Schedule.startTimeText}\n";
                    content +=
                        "End time:      ${Schedule.endDateText}  ${Schedule.endTimeText}";
                    setState(() {
                      _messages.add(
                        MessageDetail(
                          content: content,
                          type: MessageType.scheduler,
                        ),
                      );
                    });
                    print(content);
                    Schedule.isCancel = false;
                    Navigator.pop(context);
                  },
                  child: Text("Send Invite",
                      style: TextStyle(color: Colors.white)),
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
              ],
            );
          },
        );
      },
    );
  }
}
