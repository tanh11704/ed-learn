import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardData extends HomeEvent {
  const LoadDashboardData();
}

class MarkTaskCompleted extends HomeEvent {
  final String taskId;

  const MarkTaskCompleted(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class RefreshDashboard extends HomeEvent {
  const RefreshDashboard();
}

class LoadUserInfo extends HomeEvent {
  const LoadUserInfo();
}