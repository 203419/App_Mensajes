import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';

Future<void> saveMessage({
  required String text,
  File? imageFile,
  File? videoFile,
  File? audioFile,
}) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    throw Exception('Debe iniciar sesión para enviar un mensaje');
  }

  if (imageFile != null) {
    String imageFilePath =
        'messages/${DateTime.now().millisecondsSinceEpoch}.jpg';
    TaskSnapshot imageSnapshot =
        await _storage.ref(imageFilePath).putFile(imageFile);
    imageUrl = await imageSnapshot.ref.getDownloadURL();
  }

  if (videoFile != null) {
    String videoFilePath =
        'messages/${DateTime.now().millisecondsSinceEpoch}.mp4';
    TaskSnapshot videoSnapshot =
        await _storage.ref(videoFilePath).putFile(videoFile);
    videoUrl = await videoSnapshot.ref.getDownloadURL();
  }

  if (audioFile != null) {
    String audioFilePath =
        'messages/${DateTime.now().millisecondsSinceEpoch}.mp3';
    TaskSnapshot audioSnapshot =
        await _storage.ref(audioFilePath).putFile(audioFile);
    audioUrl = await audioSnapshot.ref.getDownloadURL();
  }

  await _firestore
      .collection('users')
      .doc(currentUser.uid)
      .collection('mensajes')
      .add({
    'userId': currentUser.uid,
    'text': text,
    'imageUrl': imageUrl,
    'videoUrl': videoUrl,
    'audioUrl': audioUrl,
    'timestamp': FieldValue.serverTimestamp(),
  });
}

Future<void> getMessages() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    throw Exception('Debe iniciar sesión para enviar un mensaje');
  }

  final messages = await _firestore
      .collection('users')
      .doc(currentUser.uid)
      .collection('mensajes')
      .orderBy('timestamp', descending: true)
      .get();

  messages.docs.forEach((message) {
    print(message.data());
  });
}
