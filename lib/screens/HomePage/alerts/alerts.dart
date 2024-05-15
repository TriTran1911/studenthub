import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:studenthub/components/controller.dart';
import 'package:studenthub/components/modelController.dart';
import 'package:studenthub/connection/server.dart';
import 'package:studenthub/components/modelController.dart' as modelCtrl;
import 'package:studenthub/connection/socket.dart';
import 'package:studenthub/screens/HomePage/message/pages/VideoCallPage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AlertsPage extends StatefulWidget {
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  List<modelCtrl.Notification> notifications = [];
  late modelCtrl.Notification notification;
  late Future<List<modelCtrl.Notification>> listNotification;
  late List<int> listMeetingId;
  late IO.Socket socket;

  Future<List<modelCtrl.Notification>> getNotifications() async {
    var response = await Connection.getRequest(
        '/api/notification/getByReceiverId/${modelController.user.id}', {});
    var responseDecoded = jsonDecode(response);

    if (responseDecoded['result'] != null) {
      print('Success to load notification');
      for (var notification in responseDecoded['result']) {
        notifications
            .add(modelCtrl.Notification.fromNotification(notification));
        // listMeetingId.add(notification['meetingId']);
        if (notification['typeNotifyFlag'] == '1') {
          listMeetingId
              .add(notification['message']['interview']['meetingRoom']['id']);
        } else {
          listMeetingId.add(0);
        }
      }
      notifications.sort((a, b) {
        return DateTime.parse(b.createdAt!)
            .compareTo(DateTime.parse(a.createdAt!));
      });
      return notifications;
    } else {
      throw Exception('Failed to load notification');
    }
  }

  void acceptOffer(int proposalId, int statusFlag, int disableFlag) async {
    try {
      var response = await Connection.patchRequest('/api/proposal/$proposalId',
          {"statusFlag": statusFlag, "disableFlag": disableFlag});
      jsonDecode(response);
    } catch (e) {
      print(e);
    }
  }

  void connect() {
    socket = SocketService().connectSocket();

    socket.connect();

    socket.onConnect((data) => {
          print('Connected'),
        });

    socket.onConnectError((data) => print('$data'));
    socket.onError((data) => print(data));

    socket.on('NOTI_${modelController.user.id}', (data) {
      if (mounted) {
        setState(() {
          notifications.add(
              modelCtrl.Notification.fromNotification(data['notification']));
          print('Add noti success');
        });
        notifications.sort((a, b) {
          return DateTime.parse(b.createdAt!)
              .compareTo(DateTime.parse(a.createdAt!));
        });

        print('Notification TEST: ${data['notification']}');
        if (data['notification'] != null &&
            data['notification']['message'] != null &&
            data['notification']['message']['interview'] != null) {
          listMeetingId.add(data['notification']['message']['interview']
                  ['meetingRoomId'] ??
              0);
        } else {
          listMeetingId.add(0);
        }
      }
      print('Notification 777: $data');
    });

    socket.on('ERROR', (data) {
      print(data);
    });
  }

  @override
  void initState() {
    super.initState();
    listMeetingId = [];
    listNotification = getNotifications();
    listNotification.then((value) {
      setState(() {
        notifications = value;
      });
    });

    print('Big user id: ${modelController.user.id}');

    connect();
    print('Handle notification');
  }

  @override
  void dispose() {
    // socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildColumn(),
    );
  }

  Column _buildColumn() {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.2),
                  ),
                  child: Icon(
                    _handleIconNotification(
                        notifications[index].typeNotifyFlag!),
                    size: 30.0,
                    color: Colors.blue,
                  ),
                ),
                title: Text(
                  notifications[index].typeNotifyFlag == '1'
                      ? notifications[index].content!
                      : notifications[index].title!,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      timeDif(DateTime.parse(notifications[index].createdAt!)),
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (notifications[index].typeNotifyFlag == '0' ||
                        (notifications[index].typeNotifyFlag == '1' &&
                            notifications[index]
                                    .message!
                                    .interview!
                                    .disableFlag
                                    .toString() ==
                                '0'))
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (notifications[index].proposal!.statusFlag != 3 &&
                              notifications[index].proposal!.disableFlag !=
                                  1) ...[
                            ElevatedButton(
                              onPressed: () {
                                if (notifications[index].typeNotifyFlag ==
                                    '0') {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Accept offer'),
                                          content: Text(
                                              'Do you want to accept the offer from ${notifications[index].sender?.fullname}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                acceptOffer(
                                                    notifications[index]
                                                        .proposal!
                                                        .id!,
                                                    2,
                                                    1);
                                                setState(() {
                                                  notifications[index]
                                                      .proposal!
                                                      .disableFlag = 1;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Decline'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                acceptOffer(
                                                    notifications[index]
                                                        .proposal!
                                                        .id!,
                                                    3,
                                                    0);
                                                setState(() {
                                                  notifications[index]
                                                      .proposal!
                                                      .statusFlag = 3;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Accept'),
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  moveToPage(
                                      VideoCallPage(
                                          meetingId: listMeetingId[index]),
                                      context);
                                }
                              },
                              child:
                                  (notifications[index].typeNotifyFlag == '1')
                                      ? Text('John')
                                      : Text('View offer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            )
                          ] else if (notifications[index]
                                  .proposal!
                                  .statusFlag ==
                              3) ...[
                            Text(
                              'You have accepted the offer',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ] else ...[
                            Text(
                              'You have declined the offer',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

IconData? _handleIconNotification(String s) {
  switch (s) {
    case '0':
      return Icons.handshake;
    case '1':
      return Icons.calendar_today;
    case '2':
      return Icons.check;
    case '3':
      return Icons.chat_bubble;
    case '4':
      return Icons.notifications_active;
    default:
      return Icons.notifications;
  }
}
