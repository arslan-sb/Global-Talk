import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'components/body.dart';

class MessagesScreen extends StatelessWidget {
  final types.Room room;

  const MessagesScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(room: room), // Pass the room to Body
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Row(
        children: [
          BackButton(),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          SizedBox(width: 10), // Adjusted size
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chat Room", // You can replace this with dynamic room/user names
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Active now", // Dynamic status can be handled
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        const SizedBox(width: 10),
      ],
    );
  }
}
