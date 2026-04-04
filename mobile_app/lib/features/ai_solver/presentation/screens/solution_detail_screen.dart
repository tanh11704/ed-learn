import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/math_text_view.dart';
import '../widgets/step_by_step_card.dart';
import '../bloc/solution_bloc/solution_bloc.dart';
import '../bloc/solution_bloc/solution_state.dart';

class SolutionDetailScreen extends StatelessWidget {
  const SolutionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
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
        child: BlocBuilder<SolutionBloc, SolutionState>(
          builder: (context, state) {
            if (state is! SolutionLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(Icons.change_history, size: 64),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                          const SizedBox(width: 6),
                          Text('CÂU HỎI ĐÃ NHẬN DIỆN', style: AppTextStyles.caption),
                        ],
                      ),
                      const SizedBox(height: 8),
                      MathTextView(text: state.question),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MathTextView(
                          text: state.answer,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      Container(
                        height: 28,
                        width: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Các bước giải chi tiết',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...state.steps.map(
                  (step) => StepByStepCard(
                    stepNumber: step.stepNumber,
                    title: step.title,
                    description: step.description,
                    formula: step.formula,
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: 'Hỏi AI Tutor',
                  onPressed: () => context.go('/camera/ai-tutor-chat'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
