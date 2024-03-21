import 'package:flutter/material.dart';

class ActiveChats extends StatefulWidget {
  @override
  State<ActiveChats> createState() => _ActiveChatsState();
}

class _ActiveChatsState extends State<ActiveChats> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 25),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0;
                  i < 10;
                  i++) // Replace 10 with the number of active chats
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Image.asset(
                        'images/siu.jpg',
                        width: 65,
                        height: 65,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
