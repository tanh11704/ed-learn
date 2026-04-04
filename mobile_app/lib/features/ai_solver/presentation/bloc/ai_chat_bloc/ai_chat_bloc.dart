import 'package:flutter_bloc/flutter_bloc.dart';
import 'ai_chat_event.dart';
import 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  AiChatBloc() : super(const AiChatInitial()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SendChatMessage>(_onSendChatMessage);
    on<ReceiveChatMessage>(_onReceiveChatMessage);
  }

  void _onLoadChatHistory(LoadChatHistory event, Emitter<AiChatState> emit) {
    emit(
      const AiChatLoaded(
        messages: [
          ChatMessage(
            message: 'Em chưa hiểu bước nào, hãy muốn hỏi gì thêm?',
            isUser: false,
            timeLabel: '10:02 AM',
          ),
          ChatMessage(
            message: 'Làm sao từ Bước 1 sang Bước 2 được vậy ạ?',
            isUser: true,
            timeLabel: '10:05 AM',
          ),
          ChatMessage(
            message:
                'Để chuyển từ Bước 1 sang Bước 2, em cần áp dụng công thức đã nêu ở bước 1 và thay số vào.',
            isUser: false,
            timeLabel: '10:06 AM',
          ),
        ],
      ),
    );
  }

  void _onSendChatMessage(SendChatMessage event, Emitter<AiChatState> emit) {
    final currentMessages = state is AiChatLoaded
        ? List<ChatMessage>.from((state as AiChatLoaded).messages)
        : <ChatMessage>[];

    currentMessages.add(
      ChatMessage(
        message: event.message,
        isUser: true,
        timeLabel: _nowLabel(),
      ),
    );

    emit(AiChatLoaded(messages: currentMessages));

    add(const ReceiveChatMessage('Mình đã ghi nhận câu hỏi nhé!'));
  }

  void _onReceiveChatMessage(
    ReceiveChatMessage event,
    Emitter<AiChatState> emit,
  ) {
    final currentMessages = state is AiChatLoaded
        ? List<ChatMessage>.from((state as AiChatLoaded).messages)
        : <ChatMessage>[];

    currentMessages.add(
      ChatMessage(
        message: event.message,
        isUser: false,
        timeLabel: _nowLabel(),
      ),
    );

    emit(AiChatLoaded(messages: currentMessages));
  }

  String _nowLabel() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final suffix = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}
