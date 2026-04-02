import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/quiz_question_model.dart';

class QuizScreen extends StatefulWidget {
  final String quizName;
  final String moduleName;

  const QuizScreen({
    Key? key,
    this.quizName = 'Geography Quiz',
    this.moduleName = 'Pandas Analysis',
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuizQuestion> questions;
  int currentQuestionIndex = 0;
  Map<int, String> userAnswers = {};
  DateTime? startTime;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    _initializeQuestions();
  }

  void _initializeQuestions() {
    questions = [
      QuizQuestion(
        id: 1,
        question: 'Which of these is the smallest country in the world by land area?',
        options: ['Monaco', 'Vatican City', 'San Marino', 'Liechtenstein'],
        correctAnswer: 'Vatican City',
        explanation: 'Vatican City is the smallest country in the world with an area of only 0.44 square kilometers.',
      ),
      QuizQuestion(
        id: 2,
        question: 'What is the capital of Australia?',
        options: ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'],
        correctAnswer: 'Canberra',
        explanation: 'Canberra is the capital city of Australia, located between Sydney and Melbourne.',
      ),
      QuizQuestion(
        id: 3,
        question: 'Which mountain is the highest in the world?',
        options: ['K2', 'Mount Everest', 'Kangchenjunga', 'Makalu'],
        correctAnswer: 'Mount Everest',
        explanation: 'Mount Everest is the highest mountain in the world at 8,849 meters.',
      ),
      QuizQuestion(
        id: 4,
        question: 'What is the largest desert in the world?',
        options: ['Sahara', 'Arabian', 'Gobi', 'Antarctica'],
        correctAnswer: 'Antarctica',
        explanation: 'Antarctica is technically the largest desert in the world.',
      ),
      QuizQuestion(
        id: 5,
        question: 'Which country has the most islands?',
        options: ['Sweden', 'Norway', 'Indonesia', 'Finland'],
        correctAnswer: 'Indonesia',
        explanation: 'Indonesia has the most islands of any country with over 17,000 islands.',
      ),
      QuizQuestion(
        id: 6,
        question: 'What is the longest river in the world?',
        options: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'],
        correctAnswer: 'Nile',
        explanation: 'The Nile River is the longest river in the world at approximately 6,650 kilometers.',
      ),
      QuizQuestion(
        id: 7,
        question: 'Which continent is the largest by area?',
        options: ['Africa', 'Asia', 'Europe', 'North America'],
        correctAnswer: 'Asia',
        explanation: 'Asia is the largest continent by area with approximately 44.58 million square kilometers.',
      ),
      QuizQuestion(
        id: 8,
        question: 'What is the capital of Japan?',
        options: ['Osaka', 'Tokyo', 'Kyoto', 'Hiroshima'],
        correctAnswer: 'Tokyo',
        explanation: 'Tokyo is the capital and largest city of Japan.',
      ),
      QuizQuestion(
        id: 9,
        question: 'Which ocean is the largest?',
        options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
        correctAnswer: 'Pacific',
        explanation: 'The Pacific Ocean is the largest ocean, covering more area than all other oceans combined.',
      ),
      QuizQuestion(
        id: 10,
        question: 'What is the deepest point in the ocean?',
        options: ['Mariana Trench', 'Tonga Trench', 'Kuril-Kamchatka Trench', 'Kermadec Trench'],
        correctAnswer: 'Mariana Trench',
        explanation: 'The Mariana Trench is the deepest part of the ocean at approximately 10,994 meters.',
      ),
    ];
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
      // Last question - navigate to result screen
      _submitQuiz();
    }
  }

  void _submitQuiz() {
    int correctCount = 0;
    for (var question in questions) {
      if (userAnswers[question.id] == question.correctAnswer) {
        correctCount++;
      }
    }

    final duration = DateTime.now().difference(startTime!);
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
                '${questions.length} Câu hỏi',
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
                    border: isCurrent
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
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
    final currentQuestion = questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == questions.length - 1;
    final hasAnswered = userAnswers.containsKey(currentQuestion.id);
    final selectedAnswer = userAnswers[currentQuestion.id];

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
        title: Expanded(
          child: Text(
            widget.quizName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_3x3_rounded, color: AppColors.primary),
            onPressed: _showQuestionNavigator,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Question number
              Text(
                'Question ${currentQuestionIndex + 1} of ${questions.length}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),

              // Progress bar
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

              // Question text
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

              // Answer options
              ...List.generate(currentQuestion.options.length, (index) {
                final option = currentQuestion.options[index];
                final isSelected = selectedAnswer == option;
                final optionLabel = String.fromCharCode(65 + index); // A, B, C, D

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

              // Next button
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
      ),
    );
  }
}
