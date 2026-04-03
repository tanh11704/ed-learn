import 'package:equatable/equatable.dart';

abstract class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatHistory extends AiChatEvent {
  const LoadChatHistory();
}

class SendChatMessage extends AiChatEvent {
  final String message;

  const SendChatMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class ReceiveChatMessage extends AiChatEvent {
  final String message;

  const ReceiveChatMessage(this.message);

  @override
  List<Object?> get props => [message];
}
