import 'package:equatable/equatable.dart';

class UserStreakModel extends Equatable {
  final String id;
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final String? lastActivityDay;
  final int streakFreezeCount;
  final String status;

  const UserStreakModel({
    required this.id,
    required this.userId,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActivityDay,
    required this.streakFreezeCount,
    required this.status,
  });

  factory UserStreakModel.fromJson(Map<String, dynamic> json) {
    return UserStreakModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastActivityDay: json['lastActivityDay'],
      streakFreezeCount: json['streakFreezeCount'] ?? 0,
      status: json['status'] ?? 'ACTIVE',
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    currentStreak,
    longestStreak,
    lastActivityDay,
    streakFreezeCount,
    status,
  ];
}
