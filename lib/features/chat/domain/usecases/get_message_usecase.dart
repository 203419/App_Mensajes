import 'package:app_auth/features/chat/domain/repositories/message_repository.dart';

class GetMessagesUseCase {
  final MessageRepository repository;

  GetMessagesUseCase({required this.repository});

  Stream<List<Map<String, dynamic>>> call() {
    return repository.getMessages();
  }
}
