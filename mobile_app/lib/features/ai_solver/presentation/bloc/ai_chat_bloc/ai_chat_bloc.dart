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
    final answer = event.solution?.answer.trim();
    final intro = answer == null || answer.isEmpty
        ? 'Em chưa hiểu bước nào, hãy hỏi thêm ở đây nhé.'
        : 'Mình đang xem lời giải vừa rồi. Em muốn hỏi rõ bước nào?';

    emit(
      AiChatLoaded(
        messages: [
          ChatMessage(message: intro, isUser: false, timeLabel: '10:02 AM'),
          if (answer != null && answer.isNotEmpty)
            ChatMessage(
              message: 'Đáp án hiện tại là: $answer',
              isUser: false,
              timeLabel: '10:03 AM',
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
      ChatMessage(message: event.message, isUser: true, timeLabel: _nowLabel()),
    );

    emit(AiChatLoaded(messages: currentMessages));

    add(ReceiveChatMessage(_buildTutorReply(event.message)));
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

  String _buildTutorReply(String question) {
    final lower = question.toLowerCase();
    if (lower.contains('bước') || lower.contains('buoc')) {
      return 'Em hãy nhìn lại bước được hỏi, xác định công thức đã dùng, rồi thay từng giá trị vào. Nếu em gửi tên bước cụ thể, mình sẽ giải thích chậm hơn theo từng dòng.';
    }
    if (lower.contains('đạo hàm') || lower.contains('dao ham')) {
      return 'Với dạng đạo hàm, em cần tìm y\', xét nghiệm của y\' = 0, rồi lập bảng dấu để kết luận hàm đồng biến hoặc nghịch biến.';
    }
    if (lower.contains('đáp án') || lower.contains('dap an')) {
      return 'Đáp án được chọn dựa trên kết quả so sánh cuối cùng. Nếu em chưa rõ vì sao loại các đáp án còn lại, hãy hỏi theo mẫu: "Vì sao không chọn A?".';
    }
    return 'Mình đã ghi nhận câu hỏi. Em có thể hỏi rõ hơn theo một bước, một công thức, hoặc một đáp án để mình giải thích chính xác hơn.';
  }
}
