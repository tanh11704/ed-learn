import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class SelfStudyRoomSheet extends StatefulWidget {
  const SelfStudyRoomSheet({super.key});

  @override
  State<SelfStudyRoomSheet> createState() => _SelfStudyRoomSheetState();
}

class _SelfStudyRoomSheetState extends State<SelfStudyRoomSheet> {
  int _capacity = 15;
  int _selectedCycle = 0;
  bool _isPrivate = false;
  String _selectedSubject = 'Toán học';
  final List<String> _subjects = const ['Toán học', 'Tiếng Anh', 'Ngữ văn'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                const Spacer(),
                Text('Tạo phòng tự học', style: AppTextStyles.heading2),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    final router = GoRouter.of(context);
                    Navigator.pop(context);
                    router.go('/home/self-study/session');
                  },
                  child: Text(
                    'Tạo',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Tên phòng', style: AppTextStyles.caption),
            const SizedBox(height: 6),
            TextField(
              decoration: InputDecoration(
                hintText: 'Ví dụ: Cày đề Toán xuyên đêm...',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Môn học', style: AppTextStyles.caption),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calculate,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSubject,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        items: _subjects
                            .map(
                              (subject) => DropdownMenuItem(
                                value: subject,
                                child: Text(subject),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _selectedSubject = value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Số lượng tối đa', style: AppTextStyles.caption),
            const SizedBox(height: 8),
            Row(
              children: [
                _ControlButton(
                  icon: Icons.remove,
                  onTap: () =>
                      setState(() => _capacity = (_capacity - 1).clamp(5, 30)),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Text('$_capacity', style: AppTextStyles.heading2),
                    Text('THÀNH VIÊN', style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(width: 12),
                _ControlButton(
                  icon: Icons.add,
                  onTap: () =>
                      setState(() => _capacity = (_capacity + 1).clamp(5, 30)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Chu kỳ Pomodoro', style: AppTextStyles.caption),
            const SizedBox(height: 8),
            _CycleOption(
              title: 'Tiêu chuẩn (25p học - 5p nghỉ)',
              subtitle: 'Phù hợp cho học tập cường độ vừa.',
              isSelected: _selectedCycle == 0,
              onTap: () => setState(() => _selectedCycle = 0),
            ),
            const SizedBox(height: 10),
            _CycleOption(
              title: 'Tập trung sâu (50p học - 10p nghỉ)',
              subtitle: 'Dành cho các kì thi cần sự tập trung cao độ.',
              isSelected: _selectedCycle == 1,
              onTap: () => setState(() => _selectedCycle = 1),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chế độ riêng tư', style: AppTextStyles.bodyLarge),
                        const SizedBox(height: 4),
                        Text(
                          'Yêu cầu mật khẩu để vào phòng',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isPrivate,
                    activeThumbColor: AppColors.primary,
                    onChanged: (value) => setState(() => _isPrivate = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Bắt đầu phòng ngay',
              onPressed: () {
                final router = GoRouter.of(context);
                Navigator.pop(context);
                router.go('/home/self-study/session');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
    );
  }
}

class _CycleOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _CycleOption({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary),
                color: isSelected ? AppColors.primary : AppColors.white,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: AppColors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
