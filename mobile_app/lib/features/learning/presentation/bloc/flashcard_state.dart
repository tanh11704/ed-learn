import 'package:equatable/equatable.dart';
import '../../data/models/flashcard_model.dart';

abstract class FlashcardState extends Equatable {
  const FlashcardState();

  @override
  List<Object?> get props => [];
}

/// Initial state - Chưa load gì
class FlashcardInitial extends FlashcardState {
  const FlashcardInitial();
}

/// Đang load flashcards
class FlashcardLoading extends FlashcardState {
  const FlashcardLoading();
}

/// Load thành công - Hiển thị danh sách flashcard
class FlashcardLoaded extends FlashcardState {
  final FlashcardSet flashcardSet;
  final List<Flashcard> filteredFlashcards; // Danh sách sau khi filter
  final int currentIndex; // Index flashcard hiện tại
  final bool isFlipped; // Card mặt trước (false) hay mặt sau (true)
  final String filterDifficulty; // Filter theo độ khó
  final String filterStatus; // Filter theo trạng thái
  final double progress; // Tiến độ ôn tập (0.0 to 1.0)
  final int masteredCount; // Số flashcard đã thuộc
  final int reviewedCount; // Số flashcard đã ôn tập

  const FlashcardLoaded({
    required this.flashcardSet,
    required this.filteredFlashcards,
    this.currentIndex = 0,
    this.isFlipped = false,
    this.filterDifficulty = 'all',
    this.filterStatus = 'all',
    this.progress = 0.0,
    this.masteredCount = 0,
    this.reviewedCount = 0,
  });

  /// Copy with để update state một phần
  FlashcardLoaded copyWith({
    FlashcardSet? flashcardSet,
    List<Flashcard>? filteredFlashcards,
    int? currentIndex,
    bool? isFlipped,
    String? filterDifficulty,
    String? filterStatus,
    double? progress,
    int? masteredCount,
    int? reviewedCount,
  }) {
    return FlashcardLoaded(
      flashcardSet: flashcardSet ?? this.flashcardSet,
      filteredFlashcards: filteredFlashcards ?? this.filteredFlashcards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      filterDifficulty: filterDifficulty ?? this.filterDifficulty,
      filterStatus: filterStatus ?? this.filterStatus,
      progress: progress ?? this.progress,
      masteredCount: masteredCount ?? this.masteredCount,
      reviewedCount: reviewedCount ?? this.reviewedCount,
    );
  }

  /// Get flashcard hiện tại (nullable) - UI should handle empty state
  Flashcard? get currentFlashcard =>
    filteredFlashcards.isNotEmpty && currentIndex >= 0 && currentIndex < filteredFlashcards.length
      ? filteredFlashcards[currentIndex]
      : null;

  /// Check xem có flashcard kế tiếp không
  bool get hasNext => filteredFlashcards.isNotEmpty && currentIndex < filteredFlashcards.length - 1;

  /// Check xem có flashcard trước không
  bool get hasPrevious => filteredFlashcards.isNotEmpty && currentIndex > 0;

  @override
  List<Object?> get props => [
        flashcardSet,
        filteredFlashcards,
        currentIndex,
        isFlipped,
        filterDifficulty,
        filterStatus,
        progress,
        masteredCount,
        reviewedCount,
      ];
}

/// Error khi load flashcards
class FlashcardError extends FlashcardState {
  final String message;

  const FlashcardError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Đã hoàn thành ôn tập tập hợp flashcard
class FlashcardCompleted extends FlashcardState {
  final FlashcardSet flashcardSet;
  final int totalFlashcards;
  final int masteredCount;
  final double finalScore; // 0.0 to 1.0
  final int totalReviewTime; // minutes

  const FlashcardCompleted({
    required this.flashcardSet,
    required this.totalFlashcards,
    required this.masteredCount,
    required this.finalScore,
    this.totalReviewTime = 0,
  });

  @override
  List<Object?> get props => [
        flashcardSet,
        totalFlashcards,
        masteredCount,
        finalScore,
        totalReviewTime,
      ];
}
