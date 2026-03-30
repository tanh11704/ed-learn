import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}
class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Task> tasks;
  final int dailyProgress; // 0-100
  final int daysRemaining;
  final int streak;
  final String? userName;
  final String? userEmail;
  final String? userAvatar;

  const HomeLoaded({
    required this.tasks,
    required this.dailyProgress,
    required this.daysRemaining,
    required this.streak,
    this.userName,
    this.userEmail,
    this.userAvatar,
  });

  @override
  List<Object?> get props => [tasks, dailyProgress, daysRemaining, streak, userName, userEmail, userAvatar];
}

class HomeEmpty extends HomeState {
  const HomeEmpty();
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime dueDate;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [id, title, description, isCompleted, dueDate];
}
