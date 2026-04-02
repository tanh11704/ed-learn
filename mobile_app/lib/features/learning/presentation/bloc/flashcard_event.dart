import 'package:equatable/equatable.dart';

abstract class FlashcardEvent extends Equatable {
  const FlashcardEvent();

  @override
  List<Object?> get props => [];
}

/// Lấy danh sách flashcard từ lesson
class LoadFlashcards extends FlashcardEvent {
  final String lessonId;
  final String moduleName;

  const LoadFlashcards({
    required this.lessonId,
    required this.moduleName,
  });

  @override
  List<Object?> get props => [lessonId, moduleName];
}

/// Chuyển sang flashcard tiếp theo
class NextFlashcard extends FlashcardEvent {
  const NextFlashcard();
}

/// Chuyển sang flashcard trước đó
class PreviousFlashcard extends FlashcardEvent {
  const PreviousFlashcard();
}

/// Flip card (lật từ mặt trước sang mặt sau hoặc ngược lại)
class FlipCard extends FlashcardEvent {
  const FlipCard();
}

/// Đánh giá mức độ tự tin (1-5 sao hoặc easy/hard)
class RateFlashcard extends FlashcardEvent {
  // difficulty: 'easy', 'medium' (or 'normal' in UI), 'hard'
  final String difficulty;

  const RateFlashcard({required this.difficulty});

  @override
  List<Object?> get props => [difficulty];
}

/// Shuffle các flashcard
class ShuffleFlashcards extends FlashcardEvent {
  const ShuffleFlashcards();
}

/// Hoàn thành ôn tập tập hợp flashcard này
class CompleteFlashcardSet extends FlashcardEvent {
  const CompleteFlashcardSet();
}

/// Reset tiến độ (bắt đầu lại từ đầu)
class ResetProgress extends FlashcardEvent {
  const ResetProgress();
}

/// Lọc flashcard theo độ khó
class FilterByDifficulty extends FlashcardEvent {
  final String difficulty; // easy, medium, hard, or all

  const FilterByDifficulty({required this.difficulty});

  @override
  List<Object?> get props => [difficulty];
}

/// Lọc flashcard theo trạng thái
class FilterByStatus extends FlashcardEvent {
  final String status; // mastered, needsReview, all

  const FilterByStatus({required this.status});

  @override
  List<Object?> get props => [status];
}
