import 'package:flutter_bloc/flutter_bloc.dart';
import 'performance_event.dart';
import 'performance_state.dart';

class PerformanceBloc extends Bloc<PerformanceEvent, PerformanceState> {
  PerformanceBloc()
    : super(
        PerformanceState(
          isLoading: true,
          capability: _mockCapability(),
          progress: _mockProgress(),
          timeManagement: _mockTimeManagement(),
        ),
      ) {
    on<LoadPerformanceData>((event, emit) async {
      emit(
        PerformanceState(
          isLoading: true,
          capability: state.capability,
          progress: state.progress,
          timeManagement: state.timeManagement,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));
      emit(
        PerformanceState(
          isLoading: false,
          capability: _mockCapability(),
          progress: _mockProgress(),
          timeManagement: _mockTimeManagement(),
        ),
      );
    });
    add(const LoadPerformanceData());
  }

  static CapabilityStats _mockCapability() {
    return const CapabilityStats(
      overallScore: 85,
      improvementPercent: 8.5,
      skills: [
        RadarSkill(label: 'Đại số', value: 90),
        RadarSkill(label: 'Hình học', value: 70),
        RadarSkill(label: 'Lượng giác', value: 60),
        RadarSkill(label: 'Xác suất', value: 75),
        RadarSkill(label: 'Tư duy', value: 82),
      ],
      strengths: [
        SkillInsight(
          title: 'Đại số',
          subtitle: 'Tỉ lệ hoàn thành 92%',
          progressPercent: 0.92,
        ),
      ],
      weaknesses: [
        SkillInsight(
          title: 'Hình học',
          subtitle: 'Cần ôn tập thêm Vector',
          progressPercent: 0.64,
        ),
      ],
    );
  }

  static LearningProgress _mockProgress() {
    return const LearningProgress(
      averageScore: 8.5,
      growthPercent: 12,
      weeklyScore: 85,
      weeklyGrowth: 15,
      chartPoints: [
        ChartPoint(label: 'T2', value: 62),
        ChartPoint(label: 'T3', value: 70),
        ChartPoint(label: 'T4', value: 68),
        ChartPoint(label: 'T5', value: 78),
        ChartPoint(label: 'T6', value: 74),
        ChartPoint(label: 'T7', value: 80),
        ChartPoint(label: 'CN', value: 85),
      ],
      history: [
        TestHistoryItem(
          title: 'Toán cao cấp A1',
          dateLabel: '15 thg 10, 2023',
          score: 9.0,
          status: 'ĐẠT',
        ),
        TestHistoryItem(
          title: 'Tiếng Anh Giao tiếp',
          dateLabel: '12 thg 10, 2023',
          score: 8.5,
          status: 'ĐẠT',
        ),
        TestHistoryItem(
          title: 'Cấu trúc dữ liệu',
          dateLabel: '08 thg 10, 2023',
          score: 7.5,
          status: 'ĐẠT',
        ),
      ],
    );
  }

  static TimeManagementStats _mockTimeManagement() {
    return const TimeManagementStats(
      weeklyMinutes: 45.5,
      deltaPercent: -5,
      categories: [
        TimeCategory(label: 'Ngữ pháp', average: 28, userValue: 30),
        TimeCategory(label: 'Từ vựng', average: 22, userValue: 20),
        TimeCategory(label: 'Đọc', average: 30, userValue: 38),
        TimeCategory(label: 'Nghe', average: 26, userValue: 24),
        TimeCategory(label: 'Viết', average: 24, userValue: 25),
      ],
    );
  }
}
