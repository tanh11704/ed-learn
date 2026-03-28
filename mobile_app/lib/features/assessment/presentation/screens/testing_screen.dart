import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/assessment_bloc.dart';
import '../bloc/assessment_event.dart';
import '../bloc/assessment_state.dart';
import '../models/assessment_ui_models.dart';
import '../widgets/question_card.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
    late final Future<List<AssessmentQuestionUi>> _questionsFuture;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
        _questionsFuture = Future.value(const [
      AssessmentQuestionUi(
        id: 1,
        content: 'Khi làm bài thi, bạn thường bắt đầu từ phần nào?',
        options: ['Dễ trước khó sau', 'Làm tuần tự từ đầu', 'Phần mình tự tin nhất', 'Làm ngẫu nhiên'],
      ),
      AssessmentQuestionUi(
        id: 2,
        content: 'Bạn học tốt nhất vào thời điểm nào?',
        options: ['Sáng sớm', 'Buổi trưa', 'Buổi chiều', 'Buổi tối'],
      ),
      AssessmentQuestionUi(
        id: 3,
        content: 'Bạn muốn cải thiện kỹ năng nào?',
        options: ['Tư duy logic', 'Ghi nhớ nhanh', 'Viết luận', 'Thuyết trình'],
      ),
      AssessmentQuestionUi(
        id: 4,
        content: 'Bạn thích hình thức học nào?',
        options: ['Video ngắn', 'Tài liệu đọc', 'Lớp học trực tiếp', 'Bài tập thực hành'],
      ),
    ]);
  }

  void _goNext(List<AssessmentQuestionUi> questions) {
    if (_currentIndex < questions.length - 1) {
      setState(() => _currentIndex += 1);
    } else {
      context.go('/assessment/result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AssessmentBloc(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
          title: FutureBuilder<List<AssessmentQuestionUi>>(
            future: _questionsFuture,
            builder: (context, snapshot) {
              final total = snapshot.data?.length ?? 0;
              if (total == 0) {
                return Text('Câu 0/0', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary));
              }
              return Text(
                'Câu ${_currentIndex + 1}/$total',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
              );
            },
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text('08:45', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: FutureBuilder<List<AssessmentQuestionUi>>(
              future: _questionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Không tải được câu hỏi.', style: AppTextStyles.caption),
                  );
                }

                final questions = snapshot.data ?? [];
                if (questions.isEmpty) {
                  return Center(
                    child: Text('Chưa có dữ liệu câu hỏi.', style: AppTextStyles.caption),
                  );
                }

                if (_currentIndex >= questions.length) {
                  _currentIndex = 0;
                }

                final question = questions[_currentIndex];
                final progress = (_currentIndex + 1) / questions.length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              minHeight: 6,
                              value: progress,
                              backgroundColor: AppColors.border,
                              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'TIẾN ĐỘ: ${(progress * 100).round()}%',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: BlocBuilder<AssessmentBloc, AssessmentState>(
                        builder: (context, state) {
                          return QuestionCard(
                            question: question.content,
                            options: question.options,
                            selectedIndex: state.answers[_currentIndex],
                            onSelect: (index) {
                              context.read<AssessmentBloc>().add(
                                    AnswerSelected(questionIndex: _currentIndex, optionIndex: index),
                                  );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: _currentIndex == questions.length - 1
                          ? 'Hoàn thành →'
                          : 'Câu tiếp theo →',
                      onPressed: () => _goNext(questions),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

