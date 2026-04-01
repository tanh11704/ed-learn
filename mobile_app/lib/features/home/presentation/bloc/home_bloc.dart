import 'package:flutter_bloc/flutter_bloc.dart';
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
      // Fetch user info từ repository
      final userInfo = await repository.getUserInfo();
      
      // Mock tasks
      final mockTasks = [
        Task(
          id: '1',
          title: 'Học Toán',
          description: 'Ôn tập chương 5',
          isCompleted: false,
          dueDate: DateTime.now().add(const Duration(days: 2)),
        ),
        Task(
          id: '2',
          title: 'Làm bài tập Văn',
          description: 'Soạn bài 15',
          isCompleted: true,
          dueDate: DateTime.now(),
        ),
      ];

      if (mockTasks.isEmpty) {
        emit(const HomeEmpty());
      } else {
        emit(HomeLoaded(
          tasks: mockTasks,
          dailyProgress: 65,
          daysRemaining: 120,
          streak: 7,
          userName: userInfo.name,
          userEmail: userInfo.email,
          userAvatar: userInfo.avatar,
        ));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onMarkTaskCompleted(
    MarkTaskCompleted event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      try {
        // TODO: Gọi repository để update task
        await Future.delayed(const Duration(milliseconds: 300));

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
          dailyProgress: (currentState.dailyProgress + 10).clamp(0, 100).toInt(),
          daysRemaining: currentState.daysRemaining,
          streak: currentState.streak,
          userName: currentState.userName,
          userEmail: currentState.userEmail,
          userAvatar: currentState.userAvatar,
        ));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<HomeState> emit,
  ) async {
    add(const LoadDashboardData());
  }
}
