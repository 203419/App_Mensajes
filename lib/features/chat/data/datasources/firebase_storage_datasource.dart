import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseStorageDataSource {
  Future<String> uploadFile(String path, File file);
}

class FirebaseStorageDataSourceImpl implements FirebaseStorageDataSource {
  final FirebaseStorage firebaseStorage;

  FirebaseStorageDataSourceImpl({required this.firebaseStorage});

  @override
  Future<String> uploadFile(String path, File file) async {
    final storageRef = firebaseStorage.ref().child(path);
    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
