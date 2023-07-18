import 'dart:io';
import 'dart:math';
import 'package:app_auth/features/chat/presentation/usecase_config.dart';
import 'package:flutter/material.dart';
import 'package:app_auth/features/chat/domain/entities/message_entity.dart';
import 'package:app_auth/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:app_auth/features/chat/domain/usecases/get_message_usecase.dart';
import 'package:file_picker/file_picker.dart';
import '../../../profile/domain/entities/user.dart';
import '../../data/repositories/message_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import '../components/video_message.dart';
import '../components/audio_message.dart';
import 'pdf_screen.dart';

// import 'package:app_auth/features/profile/domain/usecases/get_user_usecase.dart';
import 'package:app_auth/features/profile/domain/usecases/get_user_usecase.dart';
import 'package:provider/provider.dart';
import 'package:app_auth/features/profile/domain/entities/user.dart'
    as userProfile;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ChatScreen extends StatefulWidget {
  final UseCaseConfigChat useCaseConfig;

  ChatScreen({required this.useCaseConfig});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _textController = TextEditingController();
  File? _selectedImage;
  File? _selectedVideo;
  File? _selectedAudio;
  File? _selectedFile;
  LatLng? _selectedLocation;

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

  Future<void> _selectFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      _selectedFile = File(result.files.single.path!);
    }
  }

  Future<void> _selectLocation() async {
    final location = await Location().getLocation();
    _selectedLocation = LatLng(location.latitude!, location.longitude!);
  }

  Future<void> _sendMessage() async {
    final text = _textController.text;
    final message = MessageEntity(
      text: text,
      location: _selectedLocation,
      imageFile: _selectedImage,
      videoFile: _selectedVideo,
      audioFile: _selectedAudio,
      pdfFile: _selectedFile,
    );

    await widget.useCaseConfig.sendMessageUseCase!(message);

    _textController.clear();
    setState(() {
      _selectedImage = null;
      _selectedVideo = null;
      _selectedAudio = null;
      _selectedFile = null;
      _selectedLocation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat hot'),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF3A4E62),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: Container(
        // color 2C3C4D
        color: Color(0xFF2C3C4D),
        child: Column(
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
                          pdfUrl: messages[i]['pdfUrl'],
                          location: messages[i]['location'] != null
                              ? LatLng(messages[i]['location']['latitude'],
                                  messages[i]['location']['longitude'])
                              : null,
                          isCurrentUser:
                              currentUser!.uid == messages[i]['userId'],
                          userId: messages[i]['userId'],
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
              padding: EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Escribe un post',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 1.5),
                  GestureDetector(
                    onTap: () {
                      _selectImage();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9BBF9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.photo_camera),
                    ),
                  ),
                  const SizedBox(width: 1.5),
                  // GestureDetector(
                  //   onTap: () {
                  //     _selectVideo();
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFFD9BBF9),
                  //       borderRadius: BorderRadius.circular(15),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey.withOpacity(0.5),
                  //           spreadRadius: 1,
                  //           blurRadius: 6,
                  //           offset: const Offset(0, 3),
                  //         ),
                  //       ],
                  //     ),
                  //     child: const Icon(Icons.video_call),
                  //   ),
                  // ),
                  // const SizedBox(width: 1.5),
                  // GestureDetector(
                  //   onTap: () {
                  //     _selectAudio();
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFFD9BBF9),
                  //       borderRadius: BorderRadius.circular(15),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey.withOpacity(0.5),
                  //           spreadRadius: 1,
                  //           blurRadius: 6,
                  //           offset: const Offset(0, 3),
                  //         ),
                  //       ],
                  //     ),
                  //     child: const Icon(Icons.mic),
                  //   ),
                  // ),
                  // const SizedBox(width: 1.5),
                  GestureDetector(
                    onTap: () {
                      _selectFile();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9BBF9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.attach_file),
                    ),
                  ),
                  const SizedBox(width: 1.5),
                  GestureDetector(
                    onTap: () {
                      _selectLocation();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9BBF9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(width: 1.5),
                  GestureDetector(
                    onTap: () {
                      _sendMessage();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9BBF9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final LatLng? location;
  final String? imageUrl;
  final String? videoUrl;
  final String? audioUrl;
  final String? pdfUrl;
  final bool isCurrentUser;
  final String userId;

  MessageBubble(
      {required this.text,
      this.location,
      this.imageUrl,
      this.videoUrl,
      this.audioUrl,
      this.pdfUrl,
      required this.isCurrentUser,
      required this.userId});

  final player = AudioPlayer();
  bool isPlaying = false;

  Widget build(BuildContext context) {
    final getUserUseCase = Provider.of<GetUserUseCase>(context);

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: isCurrentUser ? 9.0 : 0.0,
            left: isCurrentUser ? 0.0 : 9.0,
            top: 9.0,
          ),
          child: StreamBuilder<UserProfile>(
            stream: getUserUseCase.call(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Row(
                  mainAxisAlignment: isCurrentUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      // tamaño de la imagen de perfil
                      radius: 15,
                      backgroundImage:
                          NetworkImage(snapshot.data!.imageProfileUrl),
                    ),
                    const SizedBox(width: 5),
                    Text(snapshot.data!.username,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        )),
                  ],
                );
              }
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            right: isCurrentUser ? 9.0 : 0.0,
            left: isCurrentUser ? 0.0 : 9.0,
          ),
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (text.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: isCurrentUser ? Colors.blue : Colors.grey,
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
              if (pdfUrl != null)
                // redirigir al pdf_screen
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfMessage(
                          pdfUrl: pdfUrl!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 55, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.0),
                      color: isCurrentUser ? Colors.blue : Colors.grey,
                    ),
                    child: Text(
                      'PDF',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              if (location != null)
                Container(
                  width: 190,
                  height: 140,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(location!.latitude, location!.longitude),
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('location'),
                        position:
                            LatLng(location!.latitude, location!.longitude),
                      ),
                    },
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
