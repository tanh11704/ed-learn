import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/error_bank_repository.dart';
import '../../../data/models/error_bank_models.dart';
import 'mistake_bank_event.dart';
import 'mistake_bank_state.dart';

class MistakeBankBloc extends Bloc<MistakeBankEvent, MistakeBankState> {
  final ErrorBankRepository repository;
  List<MistakeItem> _allItems = const [];

  MistakeBankBloc({required this.repository})
    : super(
        MistakeBankState(
          isLoading: true,
          items: _mockItems(),
          subjects: const ['Tất cả', 'Toán học', 'Vật lý', 'Hóa học'],
          selectedSubject: 'Tất cả',
        ),
      ) {
    on<LoadMistakeBank>((event, emit) async {
      emit(
        MistakeBankState(
          isLoading: true,
          items: state.items,
          subjects: state.subjects,
          selectedSubject: state.selectedSubject,
        ),
      );
      try {
        final cards = await repository.getDueCards(limit: 50);
        _allItems = cards.map(_mapCardToItem).toList();
        final subjects = _buildSubjects(_allItems);
        emit(
          MistakeBankState(
            isLoading: false,
            items: _applyFilter(_allItems, state.selectedSubject),
            subjects: subjects,
            selectedSubject: state.selectedSubject,
          ),
        );
      } catch (_) {
        _allItems = _mockItems();
        emit(
          MistakeBankState(
            isLoading: false,
            items: _applyFilter(_allItems, state.selectedSubject),
            subjects: _buildSubjects(_allItems),
            selectedSubject: state.selectedSubject,
          ),
        );
      }
    });

    on<FilterMistakesBySubject>((event, emit) {
      final filtered = _applyFilter(_allItems, event.subject);
      emit(
        MistakeBankState(
          isLoading: false,
          items: filtered,
          subjects: state.subjects,
          selectedSubject: event.subject,
        ),
      );
    });

    add(const LoadMistakeBank());
  }

  static List<MistakeItem> _mockItems() {
    return const [
      MistakeItem(
        id: '1',
        subject: 'Toán học',
        tag: 'Hệ thức lượng trong tam giác',
        title:
            'Cho tam giác ABC có a=5, b=7, c=8. Tính diện tích tam giác ABC... ',
        question:
            'Tính diện tích tam giác ABC và bán kính đường tròn ngoại tiếp R.',
        dateLabel: '20/10/2023',
        attemptsLabel: 'Sai 2 lần',
        hint: 'Xem lại công thức Heron và hệ thức lượng trong tam giác.',
        wrongAnswer: '5.5 cm',
        correctAnswer: '5 cm',
      ),
      MistakeItem(
        id: '2',
        subject: 'Toán học',
        tag: 'Lượng giác',
        title: 'Trong tam giác ABC, chứng minh rằng sin A = sin B cos C + ...',
        question: 'Áp dụng công thức cộng để chứng minh đẳng thức lượng giác.',
        dateLabel: '18/10/2023',
        attemptsLabel: 'Sai 2 lần',
        hint: 'Sử dụng công thức cộng sin và liên hệ với tam giác vuông.',
        wrongAnswer: 'sin B',
        correctAnswer: 'sin A',
      ),
      MistakeItem(
        id: '3',
        subject: 'Vật lý',
        tag: 'Dao động & ứng dụng',
        title:
            'Tìm giá trị lớn nhất và nhỏ nhất của hàm số y = x^3 - 3x + 1...',
        question: 'Tìm max/min của hàm số và xét điều kiện xác định.',
        dateLabel: '15/10/2023',
        attemptsLabel: 'Sai 1 lần',
        hint: 'Tính đạo hàm và xét dấu trên đoạn.',
        wrongAnswer: 'x = 1',
        correctAnswer: 'x = -1',
      ),
    ];
  }

  static List<MistakeItem> _applyFilter(
    List<MistakeItem> source,
    String subject,
  ) {
    if (subject == 'Tất cả') {
      return source;
    }
    return source.where((item) => item.subject == subject).toList();
  }

  static List<String> _buildSubjects(List<MistakeItem> items) {
    final unique = items.map((item) => item.subject).toSet().toList();
    unique.sort();
    return ['Tất cả', ...unique];
  }

  static MistakeItem _mapCardToItem(ErrorBankCard card) {
    final dateLabel = _formatDate(card.nextReviewDate);
    final title = card.questionContent.isEmpty
        ? 'Câu hỏi lỗi sai'
        : card.questionContent;
    return MistakeItem(
      id: card.id,
      subject: 'Lỗi sai',
      tag: 'Ôn tập đến hạn',
      title: title,
      question: card.questionContent,
      dateLabel: dateLabel,
      attemptsLabel: 'Lặp lại ${card.repetitionCount} lần',
      hint: 'Đáp án đúng: ${card.correctAnswer}',
      wrongAnswer: card.wrongAnswer,
      correctAnswer: card.correctAnswer,
    );
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '—';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
