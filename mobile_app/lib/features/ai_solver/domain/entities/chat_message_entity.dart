import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String message;
  final bool isUser;
  final String timeLabel;

  const ChatMessageEntity({
    required this.message,
    required this.isUser,
    required this.timeLabel,
  });

  @override
  List<Object?> get props => [message, isUser, timeLabel];
}
