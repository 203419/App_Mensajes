import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MessageEntity {
  final String text;
  LatLng? location;
  final File? imageFile;
  final File? videoFile;
  final File? audioFile;
  final File? pdfFile;

  MessageEntity({
    required this.text,
    this.location,
    this.imageFile,
    this.videoFile,
    this.audioFile,
    this.pdfFile,
  });
}
