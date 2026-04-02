import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/flashcard_bloc.dart';
import '../bloc/flashcard_event.dart';
import '../bloc/flashcard_state.dart';
import 'flashcard_completed_screen.dart';
import '../../data/models/flashcard_model.dart';

class FlashcardScreen extends StatefulWidget {
  final String lessonId;
  final String moduleName;

  const FlashcardScreen({
    Key? key,
    required this.lessonId,
    required this.moduleName,
  }) : super(key: key);

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  @override
  void initState() {
    super.initState();
    // Load flashcards khi screen load
    context.read<FlashcardBloc>().add(
          LoadFlashcards(
            lessonId: widget.lessonId,
            moduleName: widget.moduleName,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlashcardBloc, FlashcardState>(
      listener: (context, state) async {
        if (state is FlashcardCompleted) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FlashcardCompletedScreen(
                lessonId: widget.lessonId,
                moduleName: widget.moduleName,
                totalFlashcards: state.totalFlashcards,
                masteredCount: state.masteredCount,
                finalScore: state.finalScore,
              ),
            ),
          );

          if (result == 'retry') {
            context.read<FlashcardBloc>().add(ResetProgress());
            context.read<FlashcardBloc>().add(
                  LoadFlashcards(
                    lessonId: widget.lessonId,
                    moduleName: widget.moduleName,
                  ),
                );
          } else if (result == 'back' || result == null) {
            Navigator.pop(context);
          }
        }
        if (state is FlashcardError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          // Xác nhận trước khi quay lại
          return await _showExitConfirmation(context) ?? false;
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: _buildAppBar(context),
          body: BlocBuilder<FlashcardBloc, FlashcardState>(
            builder: (context, state) {
              if (state is FlashcardLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is FlashcardLoaded) {
                return _buildFlashcardContent(context, state);
              }

              if (state is FlashcardError) {
                return Center(
                  child: Text(state.message),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  /// Build AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () {
          _showExitConfirmation(context);
        },
      ),
      title: const Text(
        'BIOLOGY 101',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Shuffle'),
              onTap: () {
                context.read<FlashcardBloc>().add(ShuffleFlashcards());
              },
            ),
            PopupMenuItem(
              child: const Text('Reset Progress'),
              onTap: () {
                context.read<FlashcardBloc>().add(ResetProgress());
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Build main flashcard content
  Widget _buildFlashcardContent(BuildContext context, FlashcardLoaded state) {
    if (state.filteredFlashcards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No flashcards found'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session progress
            _buildSessionProgress(state),
            const SizedBox(height: 24),

            // Flashcard display
            _buildFlashcardCard(context, state),
            const SizedBox(height: 24),

            // How well did you know this?
            if (state.isFlipped) _buildDifficultyRating(context, state),
            const SizedBox(height: 24),

            // Navigation buttons
            _buildNavigationButtons(context, state),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Session progress bar
  Widget _buildSessionProgress(FlashcardLoaded state) {
    final total = state.filteredFlashcards.length;
    final current = state.currentIndex + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'CURRENT SESSION',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              '$current / $total',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 6,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ],
    );
  }

  /// Flashcard (flip animation)
  Widget _buildFlashcardCard(BuildContext context, FlashcardLoaded state) {
    // state.filteredFlashcards was checked earlier to be non-empty
    final flashcard = state.currentFlashcard!;

    return GestureDetector(
      onTap: () {
        context.read<FlashcardBloc>().add(FlipCard());
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: _buildCardSide(
          key: ValueKey(state.isFlipped),
          isFlipped: state.isFlipped,
          flashcard: flashcard,
        ),
      ),
    );
  }

  /// Card front (question) or back (answer)
  Widget _buildCardSide({
    required Key key,
    required bool isFlipped,
    required Flashcard flashcard,
  }) {
    return Container(
      key: key,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Label
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isFlipped ? 'ANSWER' : 'TERMINOLOGY',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // Main text
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isFlipped)
                          Text(
                            flashcard.question,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          )
                        else
                          Column(
                            children: [
                              // Answer image (if available)
                              if (flashcard.answerImageUrl != null)
                                Container(
                                  height: 120,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[200],
                                  ),
                                  child: Image.network(
                                    flashcard.answerImageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              // Answer text
                              Text(
                                flashcard.answer,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                              if (flashcard.explanation != null) ...[
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.amber[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.amber[200]!,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'EXAMPLE',
                                        style: TextStyle(
                                          color: Colors.amber[700],
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '"${flashcard.explanation}"',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black54,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                // Difficulty badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(flashcard.difficulty)[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    flashcard.difficulty.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      color: _getDifficultyColor(flashcard.difficulty)[700],
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tap to flip hint
          if (!isFlipped)
            Positioned(
              bottom: 16,
              right: 16,
              child: Column(
                children: [
                  const Text(
                    'Tap to flip card',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.flip,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Difficulty rating buttons
  Widget _buildDifficultyRating(BuildContext context, FlashcardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How well did you know this?',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDifficultyButton(
              context: context,
              label: 'Hard',
              color: Colors.red,
              icon: Icons.sentiment_very_dissatisfied,
            ),
            _buildDifficultyButton(
              context: context,
              label: 'Normal',
              color: Colors.orange,
              icon: Icons.sentiment_satisfied,
            ),
            _buildDifficultyButton(
              context: context,
              label: 'Easy',
              color: Colors.blue,
              icon: Icons.sentiment_very_satisfied,
            ),
          ],
        ),
      ],
    );
  }

  /// Single difficulty button
  Widget _buildDifficultyButton({
    required BuildContext context,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        // Use difficulty label only; bloc will map to confidence and auto-advance
        context.read<FlashcardBloc>().add(RateFlashcard(difficulty: label.toLowerCase()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Navigation buttons (Redo, Star)
  Widget _buildNavigationButtons(BuildContext context, FlashcardLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        if (state.hasPrevious)
          GestureDetector(
            onTap: () {
              context.read<FlashcardBloc>().add(PreviousFlashcard());
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.grey[400],
              ),
            ),
          )
        else
          const SizedBox(width: 48),

        const SizedBox(width: 32),

        // Redo button
        GestureDetector(
          onTap: () {
            // Mark as need review -> treat as 'Hard'
            context.read<FlashcardBloc>().add(RateFlashcard(difficulty: 'hard'));
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Icon(
              Icons.refresh,
              size: 20,
              color: Colors.grey[500],
            ),
          ),
        ),

        const SizedBox(width: 24),

        // Star button (bookmark)
        GestureDetector(
          onTap: () {
            // Mark as mastered/bookmark -> treat as 'Easy'
            context.read<FlashcardBloc>().add(RateFlashcard(difficulty: 'easy'));
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Icon(
              Icons.star_outline,
              size: 20,
              color: Colors.grey[500],
            ),
          ),
        ),

        const SizedBox(width: 32),

        // Next button
        if (state.hasNext)
          GestureDetector(
            onTap: () {
              context.read<FlashcardBloc>().add(NextFlashcard());
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey[400],
              ),
            ),
          )
        else
          const SizedBox(width: 48),
      ],
    );
  }

  /// Show exit confirmation
  Future<bool?> _showExitConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Session?'),
        content: const Text('Your progress will be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  /// Get difficulty color
  MaterialColor _getDifficultyColor(FlashcardDifficulty difficulty) {
    switch (difficulty) {
      case FlashcardDifficulty.easy:
        return Colors.green;
      case FlashcardDifficulty.medium:
        return Colors.orange;
      case FlashcardDifficulty.hard:
        return Colors.red;
    }
  }
}
