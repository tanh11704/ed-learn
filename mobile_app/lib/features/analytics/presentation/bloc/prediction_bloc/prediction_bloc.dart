import 'package:flutter_bloc/flutter_bloc.dart';
import 'prediction_event.dart';
import 'prediction_state.dart';

class PredictionBloc extends Bloc<PredictionEvent, PredictionState> {
  PredictionBloc()
    : super(
        PredictionState(
          isLoading: true,
          prediction: _mockPrediction(),
          stages: _mockStages(),
        ),
      ) {
    on<LoadPredictionData>((event, emit) async {
      emit(
        PredictionState(
          isLoading: true,
          prediction: state.prediction,
          stages: state.stages,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 300));
      emit(
        PredictionState(
          isLoading: false,
          prediction: _mockPrediction(),
          stages: _mockStages(),
        ),
      );
    });
    add(const LoadPredictionData());
  }

  static ScorePrediction _mockPrediction() {
    return const ScorePrediction(
      score: 26.5,
      accuracy: 0.92,
      targetLabel: 'Mục tiêu: ĐH Bách Khoa Hà Nội',
      targetDescription: 'Cần thêm 1.5 điểm',
      remainingScore: 1.5,
    );
  }

  static List<LearningStage> _mockStages() {
    return const [
      LearningStage(
        index: 1,
        title: 'Giai đoạn 1: Lộ trình Vật Lý',
        description:
            'Ai phân tích điểm trung bình để đưa ra lộ trình phù hợp cho bạn.',
        isLocked: false,
        actionLabel: 'Bắt đầu học (0/3)',
      ),
      LearningStage(
        index: 2,
        title: 'Giai đoạn 2: Tăng tốc giải đề Hóa Học',
        description: 'Làm 5 đề thi Hóa học để bám sát cấu trúc đề minh hoạ.',
        isLocked: true,
        actionLabel: 'Chưa mở',
      ),
      LearningStage(
        index: 3,
        title: 'Giai đoạn 3: Tối ưu thời gian làm bài Toán',
        description:
            'Tập trung kỹ năng sử dụng máy tính cầm tay và các mẹo giải nhanh.',
        isLocked: true,
        actionLabel: 'Chưa mở',
      ),
    ];
  }
}
