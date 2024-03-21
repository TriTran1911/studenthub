import 'package:flutter/material.dart';

class ChatBottomSheet extends StatefulWidget {
  @override
  _ChatBottomSheetState createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(
              Icons.camera_alt,
              color: Colors.blue,
              size: 30,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Icon(
              Icons.emoji_emotions_outlined,
              color: Colors.blue,
              size: 30,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Container(
              alignment: Alignment.center,
              width: 270,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.send,
              color: Colors.blue,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
