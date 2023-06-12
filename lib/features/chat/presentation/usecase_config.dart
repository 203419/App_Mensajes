import 'package:app_auth/features/chat/domain/usecases/get_message_usecase.dart';
import 'package:app_auth/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:app_auth/features/chat/data/datasources/firebase_storage_datasource.dart';
import 'package:app_auth/features/chat/data/datasources/firebase_storage_datasource.dart';
import 'package:app_auth/features/chat/data/datasources/firestore_datasource.dart';
import 'package:app_auth/features/chat/data/repositories/message_repository_impl.dart';

class UseCaseConfigChat {
  SendMessageUseCase? sendMessageUseCase;
  GetMessagesUseCase? getMessagesUseCase;
  MessageRepositoryImpl? messageRepository;
  FirebaseStorageDataSource? firebaseStorageDataSource;
  FirestoreDataSource? firestoreDataSource;

  UseCaseConfigChat(this.firebaseStorageDataSource, this.firestoreDataSource) {
    messageRepository = MessageRepositoryImpl(
      firebaseStorageDataSource: firebaseStorageDataSource!,
      firestoreDataSource: firestoreDataSource!,
    );
    sendMessageUseCase = SendMessageUseCase(repository: messageRepository!);
    getMessagesUseCase = GetMessagesUseCase(repository: messageRepository!);
  }
}
