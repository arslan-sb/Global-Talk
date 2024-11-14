import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants.dart';
import 'audio_message.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

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
    else if (message is types.FileMessage ) {
      // Check if it's an audio file (you can use metadata to ensure it's an audio file)
      // return _buildAudioMessage(message as types.FileMessage); correct
      // return AudioMessage(message: message as types.FileMessage);

      final fileMessage = message as types.FileMessage;
      // Check if the file is a PDF
      if (fileMessage.name.endsWith('.pdf')) {
        return _buildPdfMessage(fileMessage);
      } else {
        return _buildAudioMessage(fileMessage);
      }

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
             CircleAvatar(
              backgroundImage: message.author.imageUrl != null && message.author.imageUrl!.isNotEmpty
                  ? NetworkImage(message.author.imageUrl!)
                  : const AssetImage("assets/images/user_2.png") as ImageProvider, // Fallback to asset if no image URL
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
              backgroundImage: AssetImage("assets/images/user_2.png"),
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
  Widget _buildAudioMessage(types.FileMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: Row(
        mainAxisAlignment: message.author.id == FirebaseChatCore.instance.firebaseUser?.uid
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (message.author.id != FirebaseChatCore.instance.firebaseUser?.uid)
            CircleAvatar(
              backgroundImage: message.author.imageUrl != null && message.author.imageUrl!.isNotEmpty
                  ? NetworkImage(message.author.imageUrl!)
                  : const AssetImage("assets/images/user_2.png") as ImageProvider, // Fallback to asset if no image URL
              radius: 12,
            ),
          const SizedBox(width: kDefaultPadding / 2),
          // Using the existing AudioMessage widget
          Container(
            decoration: BoxDecoration(
              color: message.author.id == FirebaseChatCore.instance.firebaseUser?.uid
                  ? Colors.green
                  : Colors.green.withOpacity(0.1), // Custom colors for the bubble
              borderRadius: BorderRadius.circular(30),
            ),
            child: AudioMessage(message: message,
              colors: message.author.id == FirebaseChatCore.instance.firebaseUser?.uid
                  ? Colors.green
                  : Colors.blueAccent ,), // AudioMessage widget
          ),
        ],
      ),
    );
  }

  Future<void> downloadAndOpenPdf(String url, String fileName) async {
    try {
      // Get application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Download PDF file
      final response = await Dio().download(url, filePath);
      print("downloaded");
      if (response.statusCode == 200) {
        // Open the file with an external PDF viewer
        await OpenFilex.open(filePath);
      } else {
        print('Failed to download PDF');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildPdfMessage(types.FileMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: Row(
        mainAxisAlignment: message.author.id == FirebaseChatCore.instance.firebaseUser?.uid
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (message.author.id != FirebaseChatCore.instance.firebaseUser?.uid)
            CircleAvatar(
              backgroundImage: message.author.imageUrl != null && message.author.imageUrl!.isNotEmpty
                  ? NetworkImage(message.author.imageUrl!)
                  : const AssetImage("assets/images/user_2.png") as ImageProvider,
              radius: 12,
            ),
          const SizedBox(width: kDefaultPadding / 2),
          GestureDetector(
            onTap: () async {
              // Moeez needs to replace this with message.uri from database after he has implemented it corectly
              downloadAndOpenPdf("https://s28.q4cdn.com/392171258/files/doc_downloads/test.pdf", "sample.pdf");

            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 0.75,
                vertical: kDefaultPadding / 2,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    message.name.length>20? message.name.substring(0,20):message.name,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
