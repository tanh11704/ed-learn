import 'package:flutter_bloc/flutter_bloc.dart';
import 'mistake_bank_event.dart';
import 'mistake_bank_state.dart';

class MistakeBankBloc extends Bloc<MistakeBankEvent, MistakeBankState> {
  MistakeBankBloc()
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
      await Future<void>.delayed(const Duration(milliseconds: 300));
      emit(
        MistakeBankState(
          isLoading: false,
          items: _mockItems(),
          subjects: state.subjects,
          selectedSubject: state.selectedSubject,
        ),
      );
    });

    on<FilterMistakesBySubject>((event, emit) {
      final filtered = _mockItems()
          .where(
            (item) =>
                event.subject == 'Tất cả' || item.subject == event.subject,
          )
          .toList();
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
        title: 'Cho tam giác ABC có a=5, b=7, c=8. Tính diện tích tam giác ABC... ',
        question: 'Tính diện tích tam giác ABC và bán kính đường tròn ngoại tiếp R.',
        dateLabel: '20/10/2023',
        attemptsLabel: 'Sai 2 lần',
        hint: 'Xem lại công thức Heron và hệ thức lượng trong tam giác.',
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
      ),
      MistakeItem(
        id: '3',
        subject: 'Vật lý',
        tag: 'Dao động & ứng dụng',
        title: 'Tìm giá trị lớn nhất và nhỏ nhất của hàm số y = x^3 - 3x + 1...',
        question: 'Tìm max/min của hàm số và xét điều kiện xác định.',
        dateLabel: '15/10/2023',
        attemptsLabel: 'Sai 1 lần',
        hint: 'Tính đạo hàm và xét dấu trên đoạn.',
      ),
    ];
  }
}
