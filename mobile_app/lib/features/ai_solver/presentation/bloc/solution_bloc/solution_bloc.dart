import 'package:flutter_bloc/flutter_bloc.dart';
import 'solution_event.dart';
import 'solution_state.dart';

class SolutionBloc extends Bloc<SolutionEvent, SolutionState> {
  SolutionBloc() : super(const SolutionInitial()) {
    on<LoadSolution>(_onLoadSolution);
  }

  void _onLoadSolution(LoadSolution event, Emitter<SolutionState> emit) {
    try {
      emit(
        SolutionLoaded(
          question:
              r'\text{Cho tam giác ABC vuông tại A, có AB = 9cm, AC = 12cm. Tính độ dài cạnh huyền BC?}',
          answer: r'\text{Đáp án: D. 15}',
          steps: const [
            SolutionStep(
              stepNumber: 1,
              title: 'Xác định định lý áp dụng',
              description:
                  'Vì tam giác ABC vuông tại A, ta sử dụng định lý Pythagoras để tính độ dài cạnh huyền.',
              formula: r'BC^2 = AB^2 + AC^2',
            ),
            SolutionStep(
              stepNumber: 2,
              title: 'Thay số vào công thức',
              description: 'Thay giá trị AB = 9 và AC = 12 vào công thức.',
              formula: r'BC^2 = 9^2 + 12^2 = 81 + 144 = 225',
            ),
            SolutionStep(
              stepNumber: 3,
              title: 'Tính kết quả cuối cùng',
              description: 'Lấy căn bậc hai của 225 để tìm độ dài cạnh BC.',
              formula: r'BC = \sqrt{225} = 15',
            ),
          ],
        ),
      );
    } catch (e) {
      emit(SolutionError('Không thể tải lời giải: $e'));
    }
  }
}
