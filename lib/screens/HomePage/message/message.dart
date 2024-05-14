import 'package:flutter/material.dart';
import 'package:studenthub/screens/HomePage/message/widgets/RecentChats.dart';

class MessagePage extends StatefulWidget {
  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: ListView(children: [
        SizedBox(height: 25),
        RecentChats(),
      ]),
    );
  }
}
