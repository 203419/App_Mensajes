import 'package:app_auth/features/chat/domain/entities/message_entity.dart';
import 'package:app_auth/features/chat/domain/repositories/message_repository.dart';

class SendMessageUseCase {
  final MessageRepository repository;

  SendMessageUseCase({required this.repository});

  Future<String> call(MessageEntity message) {
    return repository.sendMessage(message);
  }
}
