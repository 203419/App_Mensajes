import 'dart:io';
import 'package:app_auth/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required String text,
    File? imageFile,
    File? videoFile,
    File? audioFile,
  }) : super(
          text: text,
          imageFile: imageFile,
          videoFile: videoFile,
          audioFile: audioFile,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['text'],
      imageFile: json['imageFile'],
      videoFile: json['videoFile'],
      audioFile: json['audioFile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'imageFile': imageFile,
      'videoFile': videoFile,
      'audioFile': audioFile,
    };
  }
}
