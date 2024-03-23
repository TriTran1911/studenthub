import 'package:flutter/material.dart';
import 'package:custom_clippers/custom_clippers.dart';

class ChatReceivedMessage extends StatelessWidget {
  final String message;

  const ChatReceivedMessage({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 80),
      child: ClipPath(
        clipper: UpperNipMessageClipper(MessageType.receive),
        child: Container(
          // margin: const EdgeInsets.only(right: 100),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFFE1E1E2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
