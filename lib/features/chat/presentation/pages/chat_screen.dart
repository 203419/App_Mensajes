import 'dart:io';
import 'package:app_auth/features/chat/presentation/usecase_config.dart';
import 'package:flutter/material.dart';
import 'package:app_auth/features/chat/domain/entities/message_entity.dart';
import 'package:app_auth/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:app_auth/features/chat/domain/usecases/get_message_usecase.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/repositories/message_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import '../components/video_message.dart';
import '../components/audio_message.dart';

class ChatScreen extends StatefulWidget {
  final UseCaseConfigChat useCaseConfig;

  ChatScreen({required this.useCaseConfig});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  // final SendMessageUseCase _sendMessageUseCase = SendMessageUseCase();
  // final GetMessagesUseCase _getMessagesUseCase = GetMessagesUseCase();
  final TextEditingController _textController = TextEditingController();
  File? _selectedImage;
  File? _selectedVideo;
  File? _selectedAudio;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      _selectedImage = File(result.files.single.path!);
    }
  }

  Future<void> _selectVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      _selectedVideo = File(result.files.single.path!);
    }
  }

  Future<void> _selectAudio() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      _selectedAudio = File(result.files.single.path!);
    }
  }

  Future<void> _sendMessage() async {
    final text = _textController.text;
    final message = MessageEntity(
      text: text,
      imageFile: _selectedImage,
      videoFile: _selectedVideo,
      audioFile: _selectedAudio,
    );

    await widget.useCaseConfig.sendMessageUseCase!(message);

    _textController.clear();
    setState(() {
      _selectedImage = null;
      _selectedVideo = null;
      _selectedAudio = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat hot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: widget.useCaseConfig.getMessagesUseCase!(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (ctx, i) {
                      return MessageBubble(
                        text: messages[i]['text'],
                        imageUrl: messages[i]['imageUrl'],
                        videoUrl: messages[i]['videoUrl'],
                        audioUrl: messages[i]['audioUrl'],
                        isCurrentUser:
                            currentUser!.uid == messages[i].values.first,
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar los mensajes');
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _selectImage,
                  icon: Icon(Icons.image),
                ),
                IconButton(
                  onPressed: _selectVideo,
                  icon: Icon(Icons.video_library),
                ),
                IconButton(
                  onPressed: _selectAudio,
                  icon: Icon(Icons.music_note),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
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
