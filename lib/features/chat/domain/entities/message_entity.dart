import 'dart:io';

class MessageEntity {
  final String text;
  final File? imageFile;
  final File? videoFile;
  final File? audioFile;

  MessageEntity({
    required this.text,
    this.imageFile,
    this.videoFile,
    this.audioFile,
  });
}
