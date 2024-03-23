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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 300,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.search,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
        RecentChats(),
      ]),
    );
  }
}
