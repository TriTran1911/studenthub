import 'package:flutter/material.dart';
import 'package:studenthub/screens/HomePage/message/widgets/ChatBottomSheet.dart';
import 'package:studenthub/screens/HomePage/message/widgets/ChatSample.dart';

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
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
                        'Cristiano',
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
                child: Icon(
                  Icons.call,
                  color: Colors.blue,
                  size: 26,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 25),
                child: Icon(
                  Icons.videocam,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 25),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        children: [
          ChatSample(),
          ChatSample(),
          ChatSample(),
        ],
      ),
      bottomSheet: ChatBottomSheet(),
    );
  }
}
