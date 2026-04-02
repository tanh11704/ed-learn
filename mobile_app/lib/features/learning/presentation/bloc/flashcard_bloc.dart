import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/flashcard_model.dart';
import 'flashcard_event.dart';
import 'flashcard_state.dart';

class FlashcardBloc extends Bloc<FlashcardEvent, FlashcardState> {
  FlashcardBloc() : super(const FlashcardInitial()) {
    // Register event handlers
    on<LoadFlashcards>(_onLoadFlashcards);
    on<NextFlashcard>(_onNextFlashcard);
    on<PreviousFlashcard>(_onPreviousFlashcard);
    on<FlipCard>(_onFlipCard);
    on<RateFlashcard>(_onRateFlashcard);
    on<ShuffleFlashcards>(_onShuffleFlashcards);
    on<CompleteFlashcardSet>(_onCompleteFlashcardSet);
    on<ResetProgress>(_onResetProgress);
    on<FilterByDifficulty>(_onFilterByDifficulty);
    on<FilterByStatus>(_onFilterByStatus);
  }

  /// Load flashcards từ lesson
  Future<void> _onLoadFlashcards(
    LoadFlashcards event,
    Emitter<FlashcardState> emit,
  ) async {
    emit(const FlashcardLoading());

    try {
      // TODO: Thay bằng API call hoặc repository
      // Hiện tại mock data
      final flashcards = _mockFlashcards(event.lessonId, event.moduleName);
      final flashcardSet = FlashcardSet(
        id: 'set_${event.lessonId}',
        name: 'Ôn tập $event.moduleName',
        lessonId: event.lessonId,
        moduleName: event.moduleName,
        flashcards: flashcards,
      );

      emit(FlashcardLoaded(
        flashcardSet: flashcardSet,
        filteredFlashcards: flashcards,
      ));
    } catch (e) {
      emit(FlashcardError(message: 'Lỗi load flashcard: ${e.toString()}'));
    }
  }

  /// Chuyển sang flashcard tiếp theo
  Future<void> _onNextFlashcard(
    NextFlashcard event,
    Emitter<FlashcardState> emit,
  ) async {
    if (state is FlashcardLoaded) {
      final currentState = state as FlashcardLoaded;
      if (currentState.hasNext) {
        emit(currentState.copyWith(
          currentIndex: currentState.currentIndex + 1,
          isFlipped: false, // Reset flip khi sang card mới
        ));
      } else {
        // Đã tới card cuối cùng, hoàn thành
        _emitCompletionState(currentState, emit);
      }
    }
  }

  /// Chuyển sang flashcard trước đó
  Future<void> _onPreviousFlashcard(
    PreviousFlashcard event,
    Emitter<FlashcardState> emit,
  ) async {
    if (state is FlashcardLoaded) {
      final currentState = state as FlashcardLoaded;
      if (currentState.hasPrevious) {
        emit(currentState.copyWith(
          currentIndex: currentState.currentIndex - 1,
          isFlipped: false,
        ));
      }
    }
  }

  /// Flip card (lật giữa mặt trước và mặt sau)
  Future<void> _onFlipCard(
    FlipCard event,
    Emitter<FlashcardState> emit,
  ) async {
    if (state is FlashcardLoaded) {
      final currentState = state as FlashcardLoaded;
      final nowFlipped = !currentState.isFlipped;
      // If user flips to the back side, count as a review
      final reviewedCount = currentState.reviewedCount + (nowFlipped ? 1 : 0);

      emit(currentState.copyWith(isFlipped: nowFlipped, reviewedCount: reviewedCount));
    }
  }

  /// Đánh giá mức độ tự tin
  Future<void> _onRateFlashcard(
    RateFlashcard event,
    Emitter<FlashcardState> emit,
  ) async {
    if (state is FlashcardLoaded) {
      final currentState = state as FlashcardLoaded;
      final currentFlashcard = currentState.currentFlashcard;

      if (currentFlashcard == null) {
        // Nothing to rate
        return;
      }

      // Map difficulty string from UI to a confidence score
      double mapDifficultyToConfidence(String difficulty) {
        final d = difficulty.toLowerCase();
        if (d == 'easy') return 0.95;
        if (d == 'normal' || d == 'medium') return 0.6;
        if (d == 'hard') return 0.2;
        // default
        return 0.5;
      }

      final newConfidence = mapDifficultyToConfidence(event.difficulty);

      final updatedFlashcard = currentFlashcard.copyWith(
        confidenceScore: newConfidence,
        reviewCount: currentFlashcard.reviewCount + 1,
        lastReviewedAt: DateTime.now(),
      );

      final updatedFlashcards = List<Flashcard>.from(currentState.filteredFlashcards);
      updatedFlashcards[currentState.currentIndex] = updatedFlashcard;

      final masteredCount =
          updatedFlashcards.where((f) => f.confidenceScore != null && f.confidenceScore! >= 0.9).length;
      final progress = updatedFlashcards.isNotEmpty ? masteredCount / updatedFlashcards.length : 0.0;

      // Increase reviewedCount metric
      final reviewedCount = currentState.reviewedCount + 1;

      // Auto-advance: nếu còn card tiếp theo -> next; nếu không -> complete
      if (currentState.hasNext) {
        emit(currentState.copyWith(
          filteredFlashcards: updatedFlashcards,
          progress: progress,
          masteredCount: masteredCount,
          reviewedCount: reviewedCount,
          currentIndex: currentState.currentIndex + 1,
          isFlipped: false,
        ));
      } else {
        // complete set
        final completionState = currentState.copyWith(
          filteredFlashcards: updatedFlashcards,
          progress: progress,
          masteredCount: masteredCount,
          reviewedCount: reviewedCount,
        );
        _emitCompletionState(completionState, emit);
      }
    }
  }




  /// Shuffle các flashcard
  Future<void> _onShuffleFlashcards(
    ShuffleFlashcards event,
    Emitter<FlashcardState> emit,
  ) async {
    if (state is FlashcardLoaded) {
      final currentState = state as FlashcardLoaded;
      final shuffledFlashcards = List<Flashcard>.from(currentState.filteredFlashcards)..shuffle();

      emit(currentState.copyWith(
        filteredFlashcards: shuffledFlashcards,
        currentIndex: 0,
        isFlipped: false,
      ));
    }
  }

  /// Hoàn thành ôn tập tập hợp flashcard
  Future<void> _onCompleteFlashcardSet(
    CompleteFlashcardSet event,
    Emitter<FlashcardState> emit,
  ) async {
    if (state is FlashcardLoaded) {
      final currentState = state as FlashcardLoaded;
      _emitCompletionState(currentState, emit);
    }
  }

  /// Reset tiến độ
  Future<void> _onResetProgress(
    ResetProgress event,
    Emitter<FlashcardState> emit,
  ) async {
    if (state is FlashcardLoaded) {
      final currentState = state as FlashcardLoaded;
      final resetFlashcards = currentState.filteredFlashcards
          .map((f) => f.copyWith(
                confidenceScore: null,
                reviewCount: 0,
                lastReviewedAt: null,
              ))
          .toList();

      emit(currentState.copyWith(
        filteredFlashcards: resetFlashcards,
        currentIndex: 0,
        isFlipped: false,
        progress: 0.0,
        masteredCount: 0,
        reviewedCount: 0,
      ));
    }
  }

  /// Lọc flashcard theo độ khó
  Future<void> _onFilterByDifficulty(
    FilterByDifficulty event,
    Emitter<FlashcardState> emit,
  ) async {
    if (state is FlashcardLoaded) {
      final currentState = state as FlashcardLoaded;
      final allFlashcards = currentState.flashcardSet.flashcards;

      List<Flashcard> filtered = allFlashcards;
      if (event.difficulty != 'all') {
        filtered = allFlashcards.where((f) => f.difficulty.toString().split('.').last == event.difficulty).toList();
      }

      // Apply status filter nếu đã filter
      if (currentState.filterStatus != 'all') {
        filtered = _applyStatusFilter(filtered, currentState.filterStatus);
      }

      emit(currentState.copyWith(
        filteredFlashcards: filtered,
        filterDifficulty: event.difficulty,
        currentIndex: 0,
        isFlipped: false,
      ));
    }
  }

  /// Lọc flashcard theo trạng thái
  Future<void> _onFilterByStatus(
    FilterByStatus event,
    Emitter<FlashcardState> emit,
  ) async {
    if (state is FlashcardLoaded) {
      final currentState = state as FlashcardLoaded;
      final allFlashcards = currentState.flashcardSet.flashcards;

      List<Flashcard> filtered = _applyStatusFilter(allFlashcards, event.status);

      // Apply difficulty filter nếu đã filter
      if (currentState.filterDifficulty != 'all') {
        filtered = filtered
            .where((f) => f.difficulty.toString().split('.').last == currentState.filterDifficulty)
            .toList();
      }

      emit(currentState.copyWith(
        filteredFlashcards: filtered,
        filterStatus: event.status,
        currentIndex: 0,
        isFlipped: false,
      ));
    }
  }

  /// Helper: Tính toán state hoàn thành
  void _emitCompletionState(FlashcardLoaded currentState, Emitter<FlashcardState> emit) {
    final totalFlashcards = currentState.filteredFlashcards.length;
    final masteredCount = currentState.filteredFlashcards
        .where((f) => f.confidenceScore != null && f.confidenceScore! >= 0.9)
        .length;
    final finalScore = masteredCount / totalFlashcards;

    emit(FlashcardCompleted(
      flashcardSet: currentState.flashcardSet,
      totalFlashcards: totalFlashcards,
      masteredCount: masteredCount,
      finalScore: finalScore,
    ));
  }

  /// Helper: Apply status filter
  List<Flashcard> _applyStatusFilter(List<Flashcard> flashcards, String status) {
    if (status == 'mastered') {
      return flashcards.where((f) => f.confidenceScore != null && f.confidenceScore! >= 0.9).toList();
    } else if (status == 'needsReview') {
      return flashcards.where((f) => f.needsReview).toList();
    }
    return flashcards;
  }

  /// Mock data - Thay bằng API sau
  List<Flashcard> _mockFlashcards(String lessonId, String moduleName) {
    return [
      Flashcard(
        id: '1',
        question: 'What is the capital of France?',
        answer: 'Paris',
        lessonId: lessonId,
        moduleName: moduleName,
        difficulty: FlashcardDifficulty.easy,
        explanation: 'Paris is the capital and most populous city of France. It is located in the north-central part of the country.',
      ),
      Flashcard(
        id: '2',
        question: 'What is the largest planet in our solar system?',
        answer: 'Jupiter',
        lessonId: lessonId,
        moduleName: moduleName,
        difficulty: FlashcardDifficulty.easy,
        explanation: 'Jupiter is the largest planet in our solar system with a mass of 1.898 × 10^27 kg.',
      ),
      Flashcard(
        id: '3',
        question: 'Who wrote Romeo and Juliet?',
        answer: 'William Shakespeare',
        lessonId: lessonId,
        moduleName: moduleName,
        difficulty: FlashcardDifficulty.medium,
        explanation: 'William Shakespeare wrote Romeo and Juliet, one of his most famous tragedies, around 1594-1596.',
      ),
      Flashcard(
        id: '4',
        question: 'What is the smallest prime number?',
        answer: '2',
        lessonId: lessonId,
        moduleName: moduleName,
        difficulty: FlashcardDifficulty.hard,
        explanation: '2 is the only even prime number and the smallest prime number in mathematics.',
      ),
      Flashcard(
        id: '5',
        question: 'Which element has the symbol Au?',
        answer: 'Gold',
        lessonId: lessonId,
        moduleName: moduleName,
        difficulty: FlashcardDifficulty.medium,
        explanation: 'Gold (Au) comes from the Latin word "aurum" and is a precious metal.',
      ),
    ];
  }
}
