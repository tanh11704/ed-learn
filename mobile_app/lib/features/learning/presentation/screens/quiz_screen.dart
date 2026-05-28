import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/datasources/learning_remote_datasource.dart';
import '../../data/models/quiz_question_model.dart';

class QuizScreen extends StatefulWidget {
  final String lessonId;
  final String quizName;
  final String moduleName;
  final String? courseId;

  const QuizScreen({
    Key? key,
    this.lessonId = '',
    this.quizName = 'Bai tap',
    this.moduleName = 'Module',
    this.courseId,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final LearningRemoteDataSource _remoteDataSource = LearningRemoteDataSourceImpl();
  List<QuizQuestion> questions = [];
  int currentQuestionIndex = 0;
  Map<int, String> userAnswers = {};
  DateTime? startTime;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final lessonId = await _resolveLessonId();
    if (lessonId.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Thiếu thông tin bài tập.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final loadedQuestions = await _remoteDataSource.getLessonExercises(lessonId);
      if (!mounted) return;
      setState(() {
        questions = loadedQuestions;
        currentQuestionIndex = 0;
        userAnswers = {};
        startTime = DateTime.now();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<String> _resolveLessonId() async {
    if (widget.lessonId.trim().isNotEmpty) {
      return widget.lessonId.trim();
    }

    final courseId = widget.courseId;
    if (courseId == null || courseId.trim().isEmpty) {
      return '';
    }

    final course = await _remoteDataSource.getCourseDetail(courseId);
    for (final chapter in course.chapters) {
      for (final lesson in chapter.lessons) {
        if (lesson.title.trim().toLowerCase() == widget.quizName.trim().toLowerCase()) {
          return lesson.id;
        }
      }
    }
    return '';
  }

  void _selectAnswer(String answer) {
    setState(() {
      userAnswers[questions[currentQuestionIndex].id] = answer;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _submitQuiz();
    }
  }

  void _submitQuiz() {
    var correctCount = 0;
    for (final question in questions) {
      if (userAnswers[question.id] == question.correctAnswer) {
        correctCount++;
      }
    }

    final duration = DateTime.now().difference(startTime ?? DateTime.now());
    final minutes = duration.inMinutes;

    context.push(
      '/learning/quiz-result',
      extra: {
        'correctCount': correctCount,
        'totalCount': questions.length,
        'minutes': minutes,
        'quizName': widget.quizName,
        'userAnswers': userAnswers,
        'questions': questions,
      },
    );
  }

  void _showQuestionNavigator() {
    if (questions.isEmpty) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildQuestionNavigator(),
    );
  }

  Widget _buildQuestionNavigator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${questions.length} câu hỏi',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              final isAnswered = userAnswers.containsKey(question.id);
              final isCurrent = index == currentQuestionIndex;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentQuestionIndex = index;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppColors.primary
                        : (isAnswered ? Colors.green : Colors.grey[300]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCurrent || isAnswered ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildScaffoldBody(const Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return _buildScaffoldBody(
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadQuestions,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return _buildScaffoldBody(
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Bài học này chưa có câu hỏi bài tập.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == questions.length - 1;
    final hasAnswered = userAnswers.containsKey(currentQuestion.id);
    final selectedAnswer = userAnswers[currentQuestion.id];

    return _buildScaffoldBody(
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1} of ${questions.length}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              currentQuestion.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            ...List.generate(currentQuestion.options.length, (index) {
              final option = currentQuestion.options[index];
              final isSelected = selectedAnswer == option;
              final optionLabel = String.fromCharCode(65 + index);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _selectAnswer(option),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey[300]!,
                        width: isSelected ? 2 : 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              optionLabel,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey[600],
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: hasAnswered ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasAnswered ? AppColors.primary : Colors.grey[300],
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isLastQuestion ? 'Nộp bài' : 'Tiếp theo',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScaffoldBody(Widget body) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.quizName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_3x3_rounded, color: AppColors.primary),
            onPressed: questions.isEmpty ? null : _showQuestionNavigator,
          ),
        ],
      ),
      body: body,
    );
  }
}
