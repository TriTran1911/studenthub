import 'dart:convert';
import 'dart:io';
import 'dart:math';
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
import 'package:studenthub/screens/HomePage/message/widgets/createSchedule.dart';

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
  late MessageNotification messageNotification;
  late Interview interview;
  late List<bool> listSender;
  late List<int> listDisableFlag;
  List<int> idInterview = [];
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
        listSender
            .add(message['sender']['id'] == widget.senderId ? true : false);
        idInterview.add(message['interview'] != null
            ? message['interview']['id'] as int
            : 0);
        listDisableFlag.add(message['interview'] != null
            ? message['interview']['disableFlag'] as int
            : 3);
        return MessageDetail(
          content: message['interview'] != null
              ? '${message['content']}\n${message['interview']['title']}\nStart time:    ${DateFormat('yyyy-MM-dd    HH:mm').format(DateTime.parse(message['interview']['startTime']))}\nEnd time:    ${DateFormat('yyyy-MM-dd    HH:mm').format(DateTime.parse(message['interview']['endTime']))}\nDuration: ${DateTime.parse(message['interview']['endTime']).difference(DateTime.parse(message['interview']['startTime'])).inMinutes.toString()} minutes'
              : message['content'],
          type: message['interview'] != null
              ? MessageType.scheduler
              : message['sender']['id'] == widget.senderId
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

    socket.onConnectError((data) => print('$data'));
    socket.onError((data) => print(data));

    socket.on('RECEIVE_MESSAGE', (data) {
      print("Chat detail: $data");
      messageNotification = MessageNotification.fromJson(data['notification']);
      if (mounted) {
        setState(() {
          _messages.add(MessageDetail(
            content: messageNotification.content,
            type: messageNotification.senderId == widget.senderId
                ? MessageType.send
                : MessageType.receive,
          ));
        });
        listSender.add(
            messageNotification.senderId == widget.senderId ? true : false);
        idInterview.add(messageNotification.interview?.id ?? 0);
        listDisableFlag.add(messageNotification.interview?.disableFlag ?? 3);
        _scrollToBottom();
      }
      print('Message Receive: ${messageNotification.content}');
    });

    socket.on('RECEIVE_INTERVIEW', (data) {
      print("Interview: $data");
      messageNotification = MessageNotification.fromJson(data['notification']);
      if (mounted) {
        setState(() {
          _messages.add(MessageDetail(
            content:
                '${messageNotification.content}\n${messageNotification.interview?.title}\nStart time:    ${DateFormat('yyyy-MM-dd    HH:mm').format(DateTime.parse(messageNotification.interview?.startTime ?? ''))}\nEnd time:    ${DateFormat('yyyy-MM-dd    HH:mm').format(DateTime.parse(messageNotification.interview?.endTime ?? ''))}\nDuration: ${DateTime.parse(messageNotification.interview?.endTime ?? '').difference(DateTime.parse(messageNotification.interview?.startTime ?? '')).inMinutes.toString()} minutes',
            type: MessageType.scheduler,
          ));
        });
        listSender.add(
            messageNotification.senderId == widget.senderId ? true : false);
        // bool exists = idInterview.contains(messageNotification.interview?.id);
        // if (exists) {
        //   print('Update interview');
        // } else {
        //   idInterview.add(messageNotification.interview?.id ?? 0);
        // }
        idInterview.add(messageNotification.interview?.id ?? 0);
        listDisableFlag.add(messageNotification.interview?.disableFlag ?? 3);

        _scrollToBottom();
      }
      print('Hanlde receive interview');
    });

    socket.on('NOTI_${widget.senderId}', (data) {
      print('Notification 123: $data');
    });
    socket.on('ERROR', (data) {
      print(data);
    });
  }

  @override
  void initState() {
    super.initState();
    listSender = [];
    listDisableFlag = [];
    listMessage = getDetailMessage();
    listMessage.then((messageDetails) {
      setState(() {
        this._messages = messageDetails;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });
    print('Sender: ${widget.senderId}');
    print('Receiver: ${widget.receiverId}');
    print('Project: ${widget.projectId}');

    connect();
    print('Handle receive message');
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CreateSchedule(
                            messages: _messages,
                            projectId: widget.projectId,
                            senderId: widget.senderId,
                            receiverId: widget.receiverId);
                      },
                    );
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
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                if (message.type == MessageType.send) {
                  return ChatSentMessage(message: message.content);
                } else if (message.type == MessageType.receive) {
                  return ChatReceivedMessage(message: message.content);
                } else if (message.type == MessageType.scheduler) {
                  return ChatSentScheduleBox(
                      content: message.content,
                      isSender: listSender[index],
                      idInterview: idInterview[index],
                      disableFlag: listDisableFlag[index]);
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
    listSender.add(true);
  }
}
