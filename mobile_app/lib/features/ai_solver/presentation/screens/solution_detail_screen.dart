import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/models/ai_solver_solution_model.dart';

class SolutionDetailScreen extends StatelessWidget {
  final AiSolverSolution solution;
  final String? imagePath;

  const SolutionDetailScreen({
    super.key,
    required this.solution,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final needsRetake = solution.needsClarification;
    final answer = solution.answer.trim().isEmpty
        ? 'Chưa có đáp án chắc chắn. Vui lòng chụp lại hoặc crop rõ hơn.'
        : solution.answer;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.go('/camera'),
        ),
        title: Text('Lời giải chi tiết', style: AppTextStyles.heading2),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () => context.go('/camera/notebook'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            _QuestionCard(
              imagePath: imagePath,
              detectedQuestion: solution.detectedQuestion,
              needsRetake: needsRetake,
            ),
            if (solution.warnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              _WarningsBox(warnings: solution.warnings),
            ],
            const SizedBox(height: 14),
            _AnswerCard(
              answer: answer,
              needsRetake: needsRetake,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetaChip(label: 'Tin cậy ${(solution.confidence * 100).round()}%'),
                if (solution.model.isNotEmpty) _MetaChip(label: solution.model),
                ...solution.topicTags.map((tag) => _MetaChip(label: tag)),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Các bước giải chi tiết',
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            if (solution.steps.isEmpty)
              _EmptyStepsCard(needsRetake: needsRetake)
            else
              ...solution.steps.asMap().entries.map(
                    (entry) => _SolutionStepCard(
                      stepNumber: entry.key + 1,
                      step: entry.value,
                    ),
                  ),
            const SizedBox(height: 12),
            if (needsRetake)
              PrimaryButton(
                text: 'Chụp / crop lại',
                onPressed: () => context.go('/camera'),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => context.go('/home'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Đã hiểu',
                          style: AppTextStyles.buttonText.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Hỏi AI',
                      onPressed: () => context.go(
                        '/camera/ai-tutor-chat',
                        extra: {'solution': solution},
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final String? imagePath;
  final String detectedQuestion;
  final bool needsRetake;

  const _QuestionCard({
    required this.imagePath,
    required this.detectedQuestion,
    required this.needsRetake,
  });

  @override
  Widget build(BuildContext context) {
    final questionText = detectedQuestion.trim().isEmpty
        ? 'AI chưa đọc được đầy đủ đề bài.'
        : detectedQuestion;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imagePath != null && imagePath!.isNotEmpty) ...[
            _ImagePreview(imagePath: imagePath!),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Icon(
                needsRetake ? Icons.warning_amber_rounded : Icons.check_circle,
                color: needsRetake ? Colors.orange : AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  needsRetake ? 'AI cần ảnh rõ hơn' : 'Câu hỏi đã nhận diện',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _TextBox(text: questionText),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String imagePath;

  const _ImagePreview({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.contain,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                'Không thể hiển thị ảnh',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final String answer;
  final bool needsRetake;

  const _AnswerCard({
    required this.answer,
    required this.needsRetake,
  });

  @override
  Widget build(BuildContext context) {
    final color = needsRetake ? const Color(0xFFFFF7ED) : AppColors.primaryLight;
    final accent = needsRetake ? Colors.orange : AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: needsRetake ? const Color(0xFFFED7AA) : const Color(0xFFBAE6FD)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đáp án',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                _SafeMathText(
                  text: answer,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: needsRetake ? Colors.orange[900] : AppColors.primaryDark,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              needsRetake ? Icons.refresh : Icons.check,
              color: accent,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _SolutionStepCard extends StatelessWidget {
  final int stepNumber;
  final AiSolverStep step;

  const _SolutionStepCard({
    required this.stepNumber,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    final title = step.title.trim().isEmpty ? 'Bước $stepNumber' : step.title;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  stepNumber.toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _cleanVisibleText(title),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
          if (step.explanation.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _TextBox(
              text: step.explanation,
              dense: true,
            ),
          ],
          if ((step.latex ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _FormulaBox(latex: step.latex!),
          ],
        ],
      ),
    );
  }
}

class _TextBox extends StatelessWidget {
  final String text;
  final bool dense;

  const _TextBox({
    required this.text,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dense ? 12 : 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: SelectableText(
        _cleanVisibleText(text),
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          height: 1.45,
        ),
      ),
    );
  }
}

class _FormulaBox extends StatelessWidget {
  final String latex;

  const _FormulaBox({required this.latex});

  @override
  Widget build(BuildContext context) {
    final lines = _cleanLatex(latex)
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines
            .map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Math.tex(
                    line,
                    textStyle: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    mathStyle: MathStyle.text,
                    textScaleFactor: 1,
                    onErrorFallback: (error) => SelectableText(
                      _cleanVisibleText(line),
                      style: AppTextStyles.bodyMedium.copyWith(height: 1.35),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SafeMathText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _SafeMathText({
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = _cleanLatex(text);
    final isShortFormula = _looksLikeFormula(normalized) && !normalized.contains('\n') && normalized.length < 90;

    if (!isShortFormula) {
      return SelectableText(
        _cleanVisibleText(text),
        style: style,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Math.tex(
        normalized,
        textStyle: style,
        mathStyle: MathStyle.text,
        textScaleFactor: 1,
        onErrorFallback: (error) => SelectableText(
          _cleanVisibleText(text),
          style: style,
        ),
      ),
    );
  }
}

class _EmptyStepsCard extends StatelessWidget {
  final bool needsRetake;

  const _EmptyStepsCard({required this.needsRetake});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        needsRetake
            ? 'AI cần ảnh rõ hơn để tạo các bước giải.'
            : 'Chưa có bước giải. Vui lòng thử lại với ảnh rõ hơn.',
        style: AppTextStyles.bodyMedium,
      ),
    );
  }
}

class _WarningsBox extends StatelessWidget {
  final List<String> warnings;

  const _WarningsBox({required this.warnings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: warnings
            .map(
              (warning) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Colors.orange),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _cleanVisibleText(warning),
                        style: AppTextStyles.caption.copyWith(color: Colors.orange[900]),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;

  const _MetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        _cleanVisibleText(label),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

String _cleanVisibleText(String value) {
  return value
      .replaceAll(r'\n', '\n')
      .replaceAll(r'\(', '')
      .replaceAll(r'\)', '')
      .replaceAll(r'\[', '')
      .replaceAll(r'\]', '')
      .replaceAll(r'$', '')
      .replaceAll(RegExp(r'\s+\n'), '\n')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();
}

String _cleanLatex(String value) {
  var output = _cleanVisibleText(value);
  if (output.startsWith(r'\text{') && output.endsWith('}')) {
    output = output.substring(6, output.length - 1);
  }
  return output.trim();
}

bool _looksLikeFormula(String value) {
  return RegExp(r'(\\frac|\\sqrt|\\left|\\right|[_^=<>]|[{}])').hasMatch(value);
}
