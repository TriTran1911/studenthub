import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// string list of notifications
List<String> noti = [
  'You have submitted to join project "Javis - AI Copilot"',
  'You have invited to interview for project "Javis - AI Copilot" at 14:00 March 20, Thursday',
  'You have offered to join project "Javis - AI Copilot"',
  'Alex Jor\nHow are you doing?',
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AlertsPage(),
    );
  }
}

class AlertsPage extends StatefulWidget {
  AlertsPage();

  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  List<Map<String, dynamic>> notifications = [];

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
      appBar: AppBar(
        title: Text('Notification Page'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => addNotification(noti[0],
                    Icons.assignment_turned_in,
                    DateTime.now()),
                child: Text('Type 1 Notification'),
              ),
              ElevatedButton(
                onPressed: () => addNotification(noti[1],
                    Icons.settings,
                    DateTime.now()),
                child: Text('Type 2 Notification'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => addNotification(noti[2],
                    Icons.settings,
                    DateTime.now()),
                child: Text('Type 3 Notification'),
              ),
              ElevatedButton(
                onPressed: () => addNotification(noti[3],
                    Icons.chat_bubble, DateTime.now()),
                child: Text('Type 4 Notification'),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => print('Notification ${index + 1} tapped'),
                  leading: Icon(notifications[index]['icon']),
                  title: Text(
                    notifications[index]['type'],
                    style: TextStyle(
                      // Add spacing to title
                      fontSize: 14.0, // Adjust font size as needed
                      fontWeight: FontWeight.bold, // Adjust font weight as needed
                    ),
                  ),
                  subtitle: Text(
                    notifications[index]['date'],
                    style: TextStyle(
                      // Add spacing to subtitle
                      fontSize: 12.0, // Adjust font size as needed
                    ),
                  ),
                  trailing: (notifications[index]['type'] == noti[1] ||
                          notifications[index]['type'] == noti[2])
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [ 
                            ElevatedButton(
                              onPressed: () {
                                // Handle button press action here (optional)
                              },
                              child: (notifications[index]['type'] == noti[1])
                                  ? Text('John') // Replace with your desired button text
                                  : Text('View offer'), // Replace with your desired button text
                            ),
                          ],
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
