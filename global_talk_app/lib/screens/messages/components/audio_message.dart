// import '../../../models/chat_message.dart';
// import 'package:flutter/material.dart';
//
// import '../../../constants.dart';
//
// class AudioMessage extends StatelessWidget {
//   final ChatMessage? message;
//
//   const AudioMessage({super.key, this.message});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.55,
//       padding: const EdgeInsets.symmetric(
//         horizontal: kDefaultPadding * 0.75,
//         vertical: kDefaultPadding / 2.5,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//         color: kPrimaryColor.withOpacity(message!.isSender ? 1 : 0.1),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.play_arrow,
//             color: message!.isSender ? Colors.white : kPrimaryColor,
//           ),
//           Expanded(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: 2,
//                     color: message!.isSender
//                         ? Colors.white
//                         : kPrimaryColor.withOpacity(0.4),
//                   ),
//                   Positioned(
//                     left: 0,
//                     child: Container(
//                       height: 8,
//                       width: 8,
//                       decoration: BoxDecoration(
//                         color: message!.isSender ? Colors.white : kPrimaryColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Text(
//             "0.37",
//             style: TextStyle(
//                 fontSize: 12, color: message!.isSender ? Colors.white : null),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:audioplayers/audioplayers.dart';
//
// class AudioMessage extends StatelessWidget {
//   final types.FileMessage message;
//
//
//   AudioMessage({super.key, required this.message});
//   final AudioPlayer player = AudioPlayer();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.55,
//       padding: const EdgeInsets.symmetric(
//         horizontal: 16.0,
//         vertical: 8.0,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//         color: Colors.blue.withOpacity(0.1),
//       ),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.play_arrow),
//             color: Colors.blue,
//             onPressed: () {
//               _playAudio(message.uri); // Play the audio when pressed
//             },
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: 2,
//                     color: Colors.blue.withOpacity(0.4),
//                   ),
//                   Positioned(
//                     left: 0,
//                     child: Container(
//                       height: 8,
//                       width: 8,
//                       decoration: const BoxDecoration(
//                         color: Colors.blue,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Text(
//             message.metadata?['duration'] ?? '0:10', // Display duration from metadata
//             style: const TextStyle(fontSize: 12, color: Colors.black),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Function to play audio
//   void _playAudio(String url) async {
//
//
//     try {
//       print("playeing");
//       await player.setSourceUrl(url); // Use the actual audio URL
//       await player.resume();
//       print("stop");
//     } catch (e) {
//       print("Error playing audio: $e");
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:voice_message_package/voice_message_package.dart'; // Make sure to import the necessary package for VoiceMessageView

class AudioMessage extends StatelessWidget {
  final types.FileMessage message;
  final Color colors;

  AudioMessage({super.key, required this.message,required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue.withOpacity(0.1),
      ),
      child: VoiceMessageView(
        controller: VoiceController(
          audioSrc: message.uri, // Use the message URI as the audio source
          onComplete: () {
            // Handle completion of audio playback
            print("Audio playback complete");
          },
          onPause: () {
            // Handle pause event
            print("Audio paused");
          },
          onPlaying: () {
            // Handle playing event

            print("Audio is playing");
          },
          onError: (err) {
            // Handle error during playback
            print("Error during playback: $err");
          },
          maxDuration: const Duration(seconds: 3),
          isFile: false, // Set to true if you are using a local file
        ),


        innerPadding: 12,
        cornerRadius: 20,
        circlesColor: colors,
        activeSliderColor: colors,

      ),
    );
  }
}

