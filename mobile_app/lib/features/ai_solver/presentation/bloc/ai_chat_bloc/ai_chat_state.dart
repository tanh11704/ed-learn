import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String message;
  final bool isUser;
  final String timeLabel;

  const ChatMessage({
    required this.message,
    required this.isUser,
    required this.timeLabel,
  });

  @override
  List<Object?> get props => [message, isUser, timeLabel];
}

abstract class AiChatState extends Equatable {
  const AiChatState();

  @override
  List<Object?> get props => [];
}

class AiChatInitial extends AiChatState {
  const AiChatInitial();
}

class AiChatLoaded extends AiChatState {
  final List<ChatMessage> messages;

  const AiChatLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}
