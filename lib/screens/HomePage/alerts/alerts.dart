import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/components/notifications.dart';

// string list of notifications
class AlertsPage extends StatefulWidget {
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  void addNotification(String type, IconData icon, DateTime date) {
    setState(() {
      notifications.add({
        'type': type,
        'icon': icon,
        'date': DateFormat('dd/MM/yyyy').format(date)
      });
    });
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () =>
                  addNotification(noti[1], Icons.settings, DateTime.now()),
              child: Text('Interview Notification'),
            ),
            ElevatedButton(
              onPressed: () =>
                  addNotification(noti[3], Icons.chat_bubble, DateTime.now()),
              child: Text('Message Notification'),
            ),
          ],
        ),
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
                    notifications[index]['icon'] as IconData,
                    size: 30.0,
                    color: Colors.blue,
                  ),
                ),
                title: Text(
                  notifications[index]['type'],
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
                      notifications[index]['date'],
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (notifications[index]['type'] == noti[1] ||
                        notifications[index]['type'] == noti[2])
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle button press action here (optional)
                            },
                            child: (notifications[index]['type'] == noti[1])
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
                          ),
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
