import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class LearningScheduleScreen extends StatefulWidget {
  const LearningScheduleScreen({super.key});

  @override
  State<LearningScheduleScreen> createState() => _LearningScheduleScreenState();
}

class _LearningScheduleScreenState extends State<LearningScheduleScreen> {
  final List<String> _days = const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  final List<String> _times = const ['15 phút', '30 phút', '45 phút'];

  final Set<String> _selectedDays = {'T2', 'T3', 'T4', 'T5', 'T6'};
  String _selectedTime = '15 phút';

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
        title: Text('Lộ trình học tập', style: AppTextStyles.heading2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Bạn có thể học vào lúc nào?', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                'Thiết lập thời gian để AI tối ưu hoá kết quả học tập của bạn.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 24),
              Text('CHỌN NGÀY TRONG TUẦN', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _days
                    .map(
                      (day) => _DayChip(
                        label: day,
                        selected: _selectedDays.contains(day),
                        onTap: () => setState(() {
                          if (_selectedDays.contains(day)) {
                            _selectedDays.remove(day);
                          } else {
                            _selectedDays.add(day);
                          }
                        }),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              Text('THỜI GIAN HỌC MỖI NGÀY', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _times
                      .map(
                        (time) => _TimeOption(
                          label: time,
                          selected: _selectedTime == time,
                          onTap: () => setState(() => _selectedTime = time),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
              Text('Bạn đã chọn học 1 giờ vào 5 ngày mỗi tuần. Tổng cộng 5 giờ/tuần.', style: AppTextStyles.caption),
              const SizedBox(height: 24),
              PrimaryButton(
                text: '✨ Tạo lộ trình AI',
                onPressed: () => context.go('/assessment/ai-processing'),
              ),
              const SizedBox(height: 12),
              Text(
                'Hệ thống sẽ dựa vào dữ liệu học tập và thời gian rảnh của bạn để thiết kế bài học phù hợp.',
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.label, this.selected = false, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(color: selected ? AppColors.white : AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _TimeOption extends StatelessWidget {
  const _TimeOption({required this.label, this.selected = false, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: selected ? AppColors.primary : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
