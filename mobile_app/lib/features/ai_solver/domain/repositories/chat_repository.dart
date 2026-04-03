import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<List<ChatMessageEntity>> loadHistory();
  Future<String> autoReply(String userMessage);
}
