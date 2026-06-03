import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class StudyGoalScreen extends StatefulWidget {
  const StudyGoalScreen({super.key});

  @override
  State<StudyGoalScreen> createState() => _StudyGoalScreenState();
}

class _StudyGoalScreenState extends State<StudyGoalScreen> {
  double _target = 27.5;
  String _selectedBlock = 'A00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Mục tiêu học tập', style: AppTextStyles.heading2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Khối thi mục tiêu', style: AppTextStyles.bodyLarge),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: ['A00', 'A01', 'D01', 'B00', 'C00'].map((block) {
                final selected = _selectedBlock == block;
                return ChoiceChip(
                  selected: selected,
                  label: Text(block),
                  onSelected: (_) => setState(() => _selectedBlock = block),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textPrimary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Điểm mục tiêu', style: AppTextStyles.bodyLarge),
                      const Spacer(),
                      Text(
                        '${_target.toStringAsFixed(1)} / 30',
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _target,
                    min: 15,
                    max: 30,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _target = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text('Trường Đại học mơ ước', style: AppTextStyles.bodyLarge),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm tên trường...',
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary),
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 18, child: Icon(Icons.school)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Đại học Bách Khoa Hà Nội',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  const Icon(Icons.check_circle, color: AppColors.primary),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Thời gian học mỗi ngày', style: AppTextStyles.bodyLarge),
            const SizedBox(height: 8),
            _timeOption('Nhẹ nhàng', '15 phút/ngày', false),
            _timeOption('Thường xuyên', '30 phút/ngày', true),
            _timeOption('Chiến thần', '60+ phút/ngày', false),
            const SizedBox(height: 14),
            PrimaryButton(text: 'Cập nhật mục tiêu', onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _timeOption(String title, String sub, bool selected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.bolt,
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium),
                Text(sub, style: AppTextStyles.caption),
              ],
            ),
          ),
          Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
