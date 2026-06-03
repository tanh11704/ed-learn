import 'package:equatable/equatable.dart';

class MistakeBankState extends Equatable {
  final bool isLoading;
  final List<MistakeItem> items;
  final List<String> subjects;
  final String selectedSubject;

  const MistakeBankState({
    required this.isLoading,
    required this.items,
    required this.subjects,
    required this.selectedSubject,
  });

  @override
  List<Object?> get props => [isLoading, items, subjects, selectedSubject];
}

class MistakeItem extends Equatable {
  final String id;
  final String subject;
  final String tag;
  final String title;
  final String question;
  final String dateLabel;
  final String attemptsLabel;
  final String hint;
  final String wrongAnswer;
  final String correctAnswer;

  const MistakeItem({
    required this.id,
    required this.subject,
    required this.tag,
    required this.title,
    required this.question,
    required this.dateLabel,
    required this.attemptsLabel,
    required this.hint,
    required this.wrongAnswer,
    required this.correctAnswer,
  });

  @override
  List<Object?> get props => [
    id,
    subject,
    tag,
    title,
    question,
    dateLabel,
    attemptsLabel,
    hint,
    wrongAnswer,
    correctAnswer,
  ];
}
