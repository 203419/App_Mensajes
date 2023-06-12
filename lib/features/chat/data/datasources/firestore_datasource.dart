import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirestoreDataSource {
  Future<void> saveMessage(Map<String, dynamic> messageData);
  Stream<List<Map<String, dynamic>>> getMessages();
}

class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  FirestoreDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  @override
  Future<void> saveMessage(Map<String, dynamic> messageData) async {
    final user = firebaseAuth.currentUser;
    final collection = firebaseFirestore.collection('messages');
    await collection.add({
      ...messageData,
      'userId': user?.uid,
      'userName': user?.displayName,
      'userPhotoUrl': user?.photoURL,
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> getMessages() {
    final collection = firebaseFirestore.collection('messages');
    return collection.orderBy('timestamp', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      },
    );
  }
}
