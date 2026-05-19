import 'package:equatable/equatable.dart';

import '../../data/models/top_course_model.dart';

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
  final List<TopCourseModel> topCourses;
  final int dailyProgress;
  final int daysRemaining;
  final int streak;
  final int longestStreak;
  final String? lastActivityDay;
  final int streakFreezeCount;
  final String? streakStatus;
  final String? userName;
  final String? userEmail;
  final String? userAvatar;
  final bool tasksFromApi;
  final bool topCoursesFromApi;

  const HomeLoaded({
    required this.tasks,
    this.topCourses = const [],
    required this.dailyProgress,
    required this.daysRemaining,
    required this.streak,
    this.longestStreak = 0,
    this.lastActivityDay,
    this.streakFreezeCount = 0,
    this.streakStatus,
    this.userName,
    this.userEmail,
    this.userAvatar,
    this.tasksFromApi = false,
    this.topCoursesFromApi = false,
  });

  @override
  List<Object?> get props => [
        tasks,
        topCourses,
        dailyProgress,
        daysRemaining,
        streak,
        longestStreak,
        lastActivityDay,
        streakFreezeCount,
        streakStatus,
        userName,
        userEmail,
        userAvatar,
        tasksFromApi,
        topCoursesFromApi,
      ];
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
