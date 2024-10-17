import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import '../../../constants.dart';

class Message extends StatelessWidget {
  final types.Message message;

  const Message({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Handle text message
    if (message is types.TextMessage) {
      return _buildTextMessage(message as types.TextMessage);
    }

    // Handle image message
    if (message is types.ImageMessage) {
      return _buildImageMessage(message as types.ImageMessage);
    }

    // Handle other message types
    // Add more cases for audio, video, etc., as needed
    return const SizedBox.shrink(); // Placeholder for unhandled message types
  }

  Widget _buildTextMessage(types.TextMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: Row(
        mainAxisAlignment: message.author.id == FirebaseChatCore.instance.firebaseUser?.uid
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (message.author.id != FirebaseChatCore.instance.firebaseUser?.uid)
            const CircleAvatar(
              backgroundImage: AssetImage("assets/images/user.png"),
              radius: 12,
            ),
          const SizedBox(width: kDefaultPadding / 2),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding * 0.75,
              vertical: kDefaultPadding / 2,
            ),
            decoration: BoxDecoration(
              color: message.author.id == FirebaseChatCore.instance.firebaseUser?.uid
                  ? kPrimaryColor
                  : kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.author.id == FirebaseChatCore.instance.firebaseUser?.uid
                    ? Colors.white
                    : Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessage(types.ImageMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: Row(
        mainAxisAlignment: message.author.id == FirebaseChatCore.instance.firebaseUser?.uid
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (message.author.id != FirebaseChatCore.instance.firebaseUser?.uid)
            const CircleAvatar(
              backgroundImage: AssetImage("assets/images/user.png"),
              radius: 12,
            ),
          const SizedBox(width: kDefaultPadding / 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              message.uri,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
