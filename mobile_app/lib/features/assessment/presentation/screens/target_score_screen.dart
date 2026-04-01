import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../state/assessment_selection_store.dart';

class TargetScoreScreen extends StatefulWidget {
  const TargetScoreScreen({super.key});

  @override
  State<TargetScoreScreen> createState() => _TargetScoreScreenState();
}

class _TargetScoreScreenState extends State<TargetScoreScreen> {
  double _targetScore = 30;
  late String _examBlock;
  late List<String> _subjects;
  late List<TextEditingController> _controllers;
  bool _isUpdatingText = false;

  static const Map<String, List<String>> _blockSubjects = {
    'A00': ['Toán', 'Vật lý', 'Hóa học'],
    'A01': ['Toán', 'Vật lý', 'Tiếng Anh'],
    'D01': ['Toán', 'Ngữ văn', 'Tiếng Anh'],
    'B00': ['Toán', 'Hóa học', 'Sinh học'],
    'C00': ['Ngữ văn', 'Lịch sử', 'Địa lý'],
    'D07': ['Toán', 'Hóa học', 'Tiếng Anh'],
  };

  @override
  void initState() {
    super.initState();
    _examBlock = AssessmentSelectionStore.selectedExamBlock.value;
    _subjects = _blockSubjects[_examBlock] ?? _blockSubjects['A00']!;
    _controllers = _subjects.map((_) => TextEditingController()).toList();
    _updateScoresFromTotal(_targetScore);
    AssessmentSelectionStore.selectedExamBlock.addListener(_handleBlockChange);
  }

  @override
  void dispose() {
    AssessmentSelectionStore.selectedExamBlock.removeListener(_handleBlockChange);
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleBlockChange() {
    final newBlock = AssessmentSelectionStore.selectedExamBlock.value;
    if (newBlock == _examBlock) {
      return;
    }
    setState(() {
      _examBlock = newBlock;
      _subjects = _blockSubjects[_examBlock] ?? _blockSubjects['A00']!;
      for (final controller in _controllers) {
        controller.dispose();
      }
      _controllers = _subjects.map((_) => TextEditingController()).toList();
      _updateScoresFromTotal(_targetScore);
    });
  }

  void _updateScoresFromTotal(double total) {
    final perSubject = _subjects.isEmpty ? 0.0 : total / _subjects.length;
    _isUpdatingText = true;
    for (final controller in _controllers) {
      controller.text = perSubject.toStringAsFixed(1);
    }
    _isUpdatingText = false;
  }

  void _updateTotalFromSubjects() {
    final total = _controllers.fold<double>(
      0,
      (sum, controller) => sum + (double.tryParse(controller.text) ?? 0),
    );
    setState(() => _targetScore = total.clamp(0, 30));
  }

  void _onSubjectChanged(String value) {
    if (_isUpdatingText) {
      return;
    }
    _updateTotalFromSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text('Mục tiêu điểm số của bạn', style: AppTextStyles.heading2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(_targetScore.toStringAsFixed(0), style: AppTextStyles.heading1.copyWith(fontSize: 44, color: AppColors.primary), textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text('Tổng điểm mục tiêu', style: AppTextStyles.caption, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Text('Điều chỉnh điểm', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0', style: AppTextStyles.caption),
                  Text('10', style: AppTextStyles.caption),
                  Text('20', style: AppTextStyles.caption),
                  Text('30', style: AppTextStyles.caption),
                ],
              ),
              Slider(
                value: _targetScore,
                max: 30,
                min: 0,
                onChanged: (value) {
                  setState(() => _targetScore = value);
                  _updateScoresFromTotal(value);
                },
                activeColor: AppColors.primary,
                inactiveColor: AppColors.border,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Điểm mục tiêu từng môn', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  Text(_examBlock, style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 12),
              ...List.generate(_subjects.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index == _subjects.length - 1 ? 0 : 12),
                  child: _ScoreInput(
                    label: _subjects[index],
                    controller: _controllers[index],
                    onChanged: _onSubjectChanged,
                  ),
                );
              }),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Lưu mục tiêu',
                onPressed: () => context.go('/assessment/learning-schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreInput extends StatelessWidget {
  const _ScoreInput({required this.label, required this.controller, required this.onChanged});

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))),
          SizedBox(
            width: 72,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.right,
              onChanged: onChanged,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 6),
          Text('điểm', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
