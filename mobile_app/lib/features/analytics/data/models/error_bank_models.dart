import 'package:equatable/equatable.dart';

class ErrorBankCard extends Equatable {
  final String id;
  final String questionContent;
  final String wrongAnswer;
  final String correctAnswer;
  final int repetitionCount;
  final double easeFactor;
  final int intervalDays;
  final DateTime? nextReviewDate;

  const ErrorBankCard({
    required this.id,
    required this.questionContent,
    required this.wrongAnswer,
    required this.correctAnswer,
    required this.repetitionCount,
    required this.easeFactor,
    required this.intervalDays,
    required this.nextReviewDate,
  });

  factory ErrorBankCard.fromJson(Map<String, dynamic> json) {
    return ErrorBankCard(
      id: json['id']?.toString() ?? '',
      questionContent: json['questionContent'] ?? '',
      wrongAnswer: json['wrongAnswer'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      repetitionCount: json['repetitionCount'] ?? 0,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 0,
      intervalDays: json['intervalDays'] ?? 0,
      nextReviewDate: json['nextReviewDate'] != null
          ? DateTime.tryParse(json['nextReviewDate'])
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        questionContent,
        wrongAnswer,
        correctAnswer,
        repetitionCount,
        easeFactor,
        intervalDays,
        nextReviewDate,
      ];
}
