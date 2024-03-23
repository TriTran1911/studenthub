import 'package:flutter/material.dart';
import 'package:custom_clippers/custom_clippers.dart';

class ChatSentMessage extends StatelessWidget {
  final String message;

  const ChatSentMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 80),
        child: ClipPath(
          clipper: LowerNipMessageClipper(MessageType.send),
          child: Container(
            padding:
                const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
