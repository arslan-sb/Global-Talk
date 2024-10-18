import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants.dart';
import 'package:intl/intl.dart';


class ChatInputField extends StatefulWidget {
  final types.Room room;

  const ChatInputField({super.key, required this.room});

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  DateTime? _recordingStartTime;  // Variable to store the start time of the recording


  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Request permissions when the widget is initialized
  }




  Future<void> _requestPermissions() async {
    await [
      Permission.microphone,
      Permission.storage,
    ].request();
  }

  // Helper function to format the duration in minutes and seconds
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _sendMessage(BuildContext context) async {
    if (_controller.text.isNotEmpty) {
      final message = types.PartialText(text: _controller.text);

      // Send the message using Firebase Chat Core
      FirebaseChatCore.instance.sendMessage(message, widget.room.id);
      _controller.clear();
    }
  }



  Future<void> _sendVoiceMessage() async {
    if (_isRecording) {
      _recordingStartTime = DateTime.now();
      final path = await _recorder.stop();
      if (path != null) {
        final File audioFile = File(path);
        final recordingEndTime = DateTime.now();  // Capture the end time
        // Get the duration from the recording
        // _recordingDuration = await _recorder.getRecordDuration();
        final duration = recordingEndTime.difference(_recordingStartTime!).inSeconds;  // Calculate the duration in seconds

        if (await audioFile.exists()) {
          // print('Audio file exists at: ${audioFile.path}');
          // print('Recording duration: $duration seconds');
          // final message = types.PartialFile(
          //   name: 'voice_message.m4a',
          //   size: await audioFile.length(),
          //   uri: audioFile.uri.toString(),
          // );
          setState(() {
            _isRecording = false;
          });



          // Upload the audio file to Firebase Storage
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('audio_messages')
              .child('${DateTime.now().millisecondsSinceEpoch}.wav');

          final metadata = SettableMetadata(
            contentType: 'audio/wav', // Make sure the content type matches the file type
          );
          // Upload the file and get the download URL
          await storageRef.putFile(audioFile,metadata);
          final audioUrl = await storageRef.getDownloadURL();
          // Set metadata to avoid null issues

          // Format the duration in minutes and seconds
          // String formattedDuration = _formatDuration(_recordingDuration ?? Duration.zero);


          // Create an audio message with the download URL
          final message2 = types.PartialFile(
            name: 'voice_message.wav',
            size: await audioFile.length(),
            uri: audioUrl,  // Send the URL from Firebase Storage
            metadata: {
              // 'duration': formattedDuration,  // Store formatted duration in metadata
              'raw_duration': duration,  // Store raw duration in seconds
            },

          );


          // Send the message automatically
          try {
            FirebaseChatCore.instance.sendMessage(message2, widget.room.id);
            // print('Voice message sent successfully.');
          } catch (e) {
            // print('Error sending voice message: $e');
          }
        } else {
          // print('Audio file does not exist at: ${audioFile.path}');
        }
      } else {
        // print('Recording stopped without a valid path.');
      }
      setState(() {
        _isRecording = false;
      });
    } else {
      final directory = await getApplicationDocumentsDirectory();
      await _recorder.start(
        const RecordConfig(),
        path: '${directory.path}/voice_message.wav',
      );
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _sendPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final path = result.files.single.path;
      if (path != null) {
        final File pdfFile = File(path);

        final message = types.PartialFile(
          name: result.files.single.name,
          size: pdfFile.lengthSync(),
          uri: pdfFile.uri.toString(),
        );
        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
      }
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Type your message...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: kPrimaryColor),
            onPressed: () => _sendMessage(context),
          ),
          IconButton(
            icon: Icon(
              _isRecording ? Icons.stop : Icons.mic,
              color: kPrimaryColor,
            ),
            onPressed: _sendVoiceMessage,
          ),
          IconButton(
            icon: const Icon(Icons.attach_file, color: kPrimaryColor),
            onPressed: _sendPdfFile,
          ),
        ],
      ),
    );
  }
}

