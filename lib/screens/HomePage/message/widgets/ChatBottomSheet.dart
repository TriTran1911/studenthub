import 'package:flutter/material.dart';

class ChatBottomSheet extends StatefulWidget {
  final Function(String)
      onMessageSent; // Callback function to handle sending messages

  ChatBottomSheet({required this.onMessageSent}); // Constructor

  @override
  _ChatBottomSheetState createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  TextEditingController _textEditingController = TextEditingController();

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
                controller: _textEditingController,
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
            child: GestureDetector(
              onTap: () {
                String message = _textEditingController.text.trim();
                if (message.isNotEmpty) {
                  widget.onMessageSent(message);
                  _textEditingController.clear();
                }
              },
              child: Icon(
                Icons.send,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
