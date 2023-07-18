import 'dart:io';
import 'package:app_auth/features/chat/data/datasources/firebase_storage_datasource.dart';
import 'package:app_auth/features/chat/data/datasources/firestore_datasource.dart';
import 'package:app_auth/features/chat/domain/entities/message_entity.dart';
import 'package:app_auth/features/chat/domain/repositories/message_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MessageRepositoryImpl implements MessageRepository {
  final FirebaseStorageDataSource firebaseStorageDataSource;
  final FirestoreDataSource firestoreDataSource;

  MessageRepositoryImpl({
    required this.firebaseStorageDataSource,
    required this.firestoreDataSource,
  });

  @override
  Future<String> sendMessage(MessageEntity message) async {
    final String? imageUrl = await _uploadFile(message.imageFile);
    final String? videoUrl = await _uploadFile(message.videoFile);
    final String? audioUrl = await _uploadFile(message.audioFile);
    final String? pdfUrl = await _uploadFile(message.pdfFile);

    final messageData = {
      'text': message.text,
      'location': message.location != null
          ? {
              'latitude': message.location!.latitude,
              'longitude': message.location!.longitude
            }
          : null,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'pdfUrl': pdfUrl,
      'timestamp': DateTime.now(),
    };

    await firestoreDataSource.saveMessage(messageData);

    return 'Mensaje enviado exitosamente';
  }

  Future<String?> _uploadFile(File? file) async {
    if (file != null) {
      final path =
          'messages/${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}';
      return firebaseStorageDataSource.uploadFile(path, file);
    }
    return null;
  }

  @override
  Stream<List<Map<String, dynamic>>> getMessages() {
    return firestoreDataSource.getMessages();
  }
}
