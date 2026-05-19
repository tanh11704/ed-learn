import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/top_course_model.dart';
import '../../data/models/user_task_model.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(const HomeInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<MarkTaskCompleted>(_onMarkTaskCompleted);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      final userInfo = await repository.getUserInfo();

      int currentStreak = 0;
      int longestStreak = 0;
      String? lastActivityDay;
      int streakFreezeCount = 0;
      String streakStatus = 'ACTIVE';

      try {
        final streakInfo = await repository.getUserStreak();
        currentStreak = streakInfo.currentStreak;
        longestStreak = streakInfo.longestStreak;
        lastActivityDay = streakInfo.lastActivityDay;
        streakFreezeCount = streakInfo.streakFreezeCount;
        streakStatus = streakInfo.status;
      } catch (_) {
        // giữ giá trị mặc định khi API lỗi
      }

      List<Task> tasks = [];
      var tasksFromApi = false;
      try {
        final apiTasks = await repository.getTodayTasks();
        tasks = apiTasks.map(_mapTask).toList();
        tasksFromApi = true;
      } catch (_) {
        tasks = _fallbackTasks();
      }

      List<TopCourseModel> topCourses = [];
      var topCoursesFromApi = false;
      try {
        topCourses = await repository.getTopCourses();
        topCoursesFromApi = true;
      } catch (_) {
        topCourses = [];
      }

      final examDate = DateTime(2026, 6, 11);
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final daysRemaining =
          examDate.difference(todayDate).inDays.clamp(0, 9999);

      final dailyProgress = _calcDailyProgress(tasks);

      emit(HomeLoaded(
        tasks: tasks,
        topCourses: topCourses,
        dailyProgress: dailyProgress,
        daysRemaining: daysRemaining,
        streak: currentStreak,
        longestStreak: longestStreak,
        lastActivityDay: lastActivityDay,
        streakFreezeCount: streakFreezeCount,
        streakStatus: streakStatus,
        userName: userInfo.name,
        userEmail: userInfo.email,
        userAvatar: userInfo.avatar,
        tasksFromApi: tasksFromApi,
        topCoursesFromApi: topCoursesFromApi,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onMarkTaskCompleted(
    MarkTaskCompleted event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;

    try {
      if (currentState.tasksFromApi) {
        await repository.completeTask(event.taskId);
      }

      final updatedTasks = currentState.tasks.map((task) {
        return task.id == event.taskId
            ? Task(
                id: task.id,
                title: task.title,
                description: task.description,
                isCompleted: true,
                dueDate: task.dueDate,
              )
            : task;
      }).toList();

      emit(HomeLoaded(
        tasks: updatedTasks,
        topCourses: currentState.topCourses,
        dailyProgress: _calcDailyProgress(updatedTasks),
        daysRemaining: currentState.daysRemaining,
        streak: currentState.streak,
        longestStreak: currentState.longestStreak,
        lastActivityDay: currentState.lastActivityDay,
        streakFreezeCount: currentState.streakFreezeCount,
        streakStatus: currentState.streakStatus,
        userName: currentState.userName,
        userEmail: currentState.userEmail,
        userAvatar: currentState.userAvatar,
        tasksFromApi: currentState.tasksFromApi,
        topCoursesFromApi: currentState.topCoursesFromApi,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<HomeState> emit,
  ) async {
    add(const LoadDashboardData());
  }

  static int _calcDailyProgress(List<Task> tasks) {
    if (tasks.isEmpty) return 0;
    final done = tasks.where((t) => t.isCompleted).length;
    return ((done / tasks.length) * 100).round().clamp(0, 100);
  }

  static Task _mapTask(UserTaskModel m) => Task(
        id: m.id,
        title: m.title,
        description: m.description,
        isCompleted: m.isCompleted,
        dueDate: m.dueDate,
      );

  static List<Task> _fallbackTasks() {
    return [
      Task(
        id: 'fallback-1',
        title: 'Học Toán',
        description: 'Ôn tập chương 5',
        isCompleted: false,
        dueDate: DateTime.now(),
      ),
      Task(
        id: 'fallback-2',
        title: 'Làm bài tập Văn',
        description: 'Soạn bài 15',
        isCompleted: true,
        dueDate: DateTime.now(),
      ),
    ];
  }
}
