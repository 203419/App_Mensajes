import 'package:app_auth/features/chat/domain/entities/message_entity.dart';

abstract class MessageRepository {
  Future<String> sendMessage(MessageEntity message);
  Stream<List<Map<String, dynamic>>> getMessages();
}
