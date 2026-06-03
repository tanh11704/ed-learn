import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/exam_session_args.dart';
import '../bloc/exam_taking_bloc/exam_taking_bloc.dart';
import '../bloc/exam_taking_bloc/exam_taking_event.dart';
import '../bloc/exam_taking_bloc/exam_taking_state.dart';
import '../widgets/camera_pip_view.dart';
import '../widgets/question_navigation_grid.dart';
import '../widgets/submit_confirmation_dialog.dart';

class ExamTakingScreen extends StatelessWidget {
  const ExamTakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ExamSessionArgs.fromExtra(GoRouterState.of(context).extra);

    return BlocProvider(
      create: (_) => ExamTakingBloc()
        ..add(
          LoadExamTaking(
            examId: args.examId,
            examTitle: args.examTitle,
            durationMinutes: args.durationMinutes,
            gradeLevel: args.gradeLevel,
            className: args.className,
          ),
        ),
      child: BlocListener<ExamTakingBloc, ExamTakingState>(
        listenWhen: (prev, curr) {
          final hasSubmitError =
              curr is ExamTakingLoaded &&
              curr.submitError != null &&
              (prev is! ExamTakingLoaded ||
                  prev.submitError != curr.submitError);
          return curr is ExamTakingFinished ||
              curr is ExamTakingError ||
              hasSubmitError;
        },
        listener: (context, state) {
          if (state is ExamTakingFinished) {
            context.go('/exam/exam-result', extra: state);
          } else if (state is ExamTakingError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ExamTakingLoaded && state.submitError != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.submitError!)));
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const SizedBox(width: 4),
            title: BlocBuilder<ExamTakingBloc, ExamTakingState>(
              builder: (context, state) {
                final remaining = state is ExamTakingLoaded
                    ? state.remainingSeconds
                    : 0;
                final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
                final seconds = (remaining % 60).toString().padLeft(2, '0');
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            size: 20,
                            color: Color(0xFFFF4D4F),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$minutes:$seconds',
                            style: const TextStyle(
                              color: Color(0xFFFF4D4F),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: BlocBuilder<ExamTakingBloc, ExamTakingState>(
                  builder: (context, state) {
                    final isSubmitting =
                        state is ExamTakingLoaded && state.isSubmitting;
                    return ElevatedButton(
                      onPressed: state is! ExamTakingLoaded || isSubmitting
                          ? null
                          : () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) => SubmitConfirmationDialog(
                                  totalQuestions: state.questions.length,
                                  answeredCount: state.selectedAnswers.length,
                                  onSubmit: () {
                                    Navigator.of(ctx).pop();
                                    context.read<ExamTakingBloc>().add(
                                      const SubmitExam(),
                                    );
                                  },
                                  onReview: () => Navigator.of(ctx).pop(),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E6BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Nộp bài',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: BlocBuilder<ExamTakingBloc, ExamTakingState>(
              builder: (context, state) {
                if (state is ExamTakingLoading ||
                    (state is ExamTakingLoaded && state.isSubmitting)) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ExamTakingError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(state.message, textAlign: TextAlign.center),
                    ),
                  );
                }

                if (state is! ExamTakingLoaded) {
                  return const SizedBox.shrink();
                }

                final question = state.currentQuestion;
                final total = state.questions.length;
                final currentNumber = state.currentIndex + 1;
                final answeredIndexes = state.selectedAnswers.keys.toSet();

                return Column(
                  children: [
                    const SizedBox(height: 26),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        children: [
                          Text(
                            'CÂU HỎI $currentNumber/$total',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(26, 8, 26, 22),
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _ExamFormattedText(
                                      question.content,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        height: 1.35,
                                      ),
                                    ),
                                    if (question.imageUrl != null &&
                                        question.imageUrl!.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          question.imageUrl!,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, _, _) =>
                                              const SizedBox.shrink(),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 70),
                              const CameraPipView(),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...question.options.map(
                            (option) => _AnswerTile(
                              label: option.label,
                              text: option.text,
                              selected:
                                  state.selectedAnswers[state.currentIndex] ==
                                  option.id,
                              onTap: () => context.read<ExamTakingBloc>().add(
                                SelectAnswer(
                                  questionIndex: state.currentIndex,
                                  optionId: option.id,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 10,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'TIẾN ĐỘ LÀM BÀI',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${answeredIndexes.length}/$total Hoàn thành',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          QuestionNavigationGrid(
                            totalQuestions: total,
                            currentIndex: state.currentIndex,
                            answeredIndexes: answeredIndexes,
                            onSelect: (index) => context
                                .read<ExamTakingBloc>()
                                .add(GoToQuestion(index)),
                          ),
                        ],
                      ),
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

class _AnswerTile extends StatelessWidget {
  final String label;
  final String text;
  final bool selected;
  final VoidCallback? onTap;

  const _AnswerTile({
    required this.label,
    required this.text,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF2E6BFF) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF2E6BFF) : Colors.transparent,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF2E6BFF)
                      : const Color(0xFFCBD5E1),
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? const Color(0xFF1D4ED8) : Colors.black87,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _ExamFormattedText(
                _stripOptionLabel(text),
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? const Color(0xFF1D4ED8) : Colors.black87,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamFormattedText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _ExamFormattedText(this.text, {required this.style});

  @override
  Widget build(BuildContext context) {
    final normalized = _normalizeText(text);
    final parts = _splitMath(normalized);

    if (parts.length == 1 && !parts.first.isMath) {
      return Text(normalized, style: style);
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 2,
      runSpacing: 4,
      children: parts.map((part) {
        if (!part.isMath) {
          return Text(part.value, style: style);
        }
        return Math.tex(
          part.value,
          textStyle: style,
          mathStyle: MathStyle.text,
          textScaleFactor: 1,
          onErrorFallback: (_) => Text(part.value, style: style),
        );
      }).toList(),
    );
  }
}

class _TextPart {
  final String value;
  final bool isMath;

  const _TextPart(this.value, this.isMath);
}

List<_TextPart> _splitMath(String value) {
  final parts = <_TextPart>[];
  final regex = RegExp(r'\\\((.*?)\\\)|\\\[(.*?)\\\]');
  var cursor = 0;

  for (final match in regex.allMatches(value)) {
    if (match.start > cursor) {
      parts.add(_TextPart(value.substring(cursor, match.start), false));
    }
    parts.add(_TextPart((match.group(1) ?? match.group(2) ?? '').trim(), true));
    cursor = match.end;
  }

  if (cursor < value.length) {
    final rest = value.substring(cursor);
    final looksLikeMath = RegExp(r'\\frac|\\sqrt|[_^{}]').hasMatch(rest);
    parts.add(_TextPart(rest, looksLikeMath));
  }

  return parts.where((part) => part.value.isNotEmpty).toList();
}

String _normalizeText(String value) {
  return value.replaceAll(r'\n', '\n').replaceAll(RegExp(r'\s+'), ' ').trim();
}

String _stripOptionLabel(String value) {
  return value.replaceFirst(RegExp(r'^[A-H]\.\s*'), '').trim();
}
