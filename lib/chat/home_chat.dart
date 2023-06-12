import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'services/file_management.dart';
import 'services/video_message.dart';
import 'services/audio_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  final _messageController = TextEditingController();
  File? _selectedImage;
  File? _selectedVideo;
  File? _selectedAudio;
  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> _pickAudio() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      _selectedAudio = File(result.files.single.path!);
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      _selectedImage = File(result.files.single.path!);
    }
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      _selectedVideo = File(result.files.single.path!);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty ||
        _selectedImage != null ||
        _selectedVideo != null ||
        _selectedAudio != null) {
      await saveMessage(
        text: _messageController.text,
        imageFile: _selectedImage,
        videoFile: _selectedVideo,
        audioFile: _selectedAudio,
      );
      _messageController.clear();
      _selectedImage = null;
      _selectedVideo = null;
      _selectedAudio = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(currentUser!.uid)
                  .collection('mensajes')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Text('No hay mensajes');
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (ctx, i) {
                    return MessageBubble(
                      text: messages[i]['text'],
                      imageUrl: messages[i]['imageUrl'],
                      videoUrl: messages[i]['videoUrl'],
                      audioUrl: messages[i]['audioUrl'],
                      isCurrentUser:
                          currentUser!.uid == messages[i].get('userId')
                              ? true
                              : false,
                    );
                  },
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(Icons.video_call),
                  onPressed: _pickVideo,
                ),
                IconButton(
                  icon: Icon(Icons.music_note),
                  onPressed: _pickAudio,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String? imageUrl;
  final String? videoUrl;
  final String? audioUrl;
  final bool isCurrentUser;

  MessageBubble(
      {required this.text,
      this.imageUrl,
      this.videoUrl,
      this.audioUrl,
      required this.isCurrentUser});

  final player = AudioPlayer();
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 5),
                if (text.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.blue,
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(height: 5),
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      width: 180,
                      height: 140,
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (videoUrl != null)
                  VideoMessage(
                    videoUrl: videoUrl!,
                  ),
                if (audioUrl != null)
                  AudioMessage(
                    audioUrl: audioUrl!,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
