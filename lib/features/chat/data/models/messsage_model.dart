import 'dart:io';
import 'package:app_auth/features/chat/domain/entities/message_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required String text,
    LatLng? location,
    File? imageFile,
    File? videoFile,
    File? audioFile,
    File? pdfFile,
  }) : super(
          text: text,
          location: location,
          imageFile: imageFile,
          videoFile: videoFile,
          audioFile: audioFile,
          pdfFile: pdfFile,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['text'],
      location: json['location'] != null
          ? LatLng(json['location']['latitude'], json['location']['longitude'])
          : null,
      imageFile: json['imageFile'],
      videoFile: json['videoFile'],
      audioFile: json['audioFile'],
      pdfFile: json['pdfFile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'location': location,
      'imageFile': imageFile,
      'videoFile': videoFile,
      'audioFile': audioFile,
      'pdfFile': pdfFile,
    };
  }
}
