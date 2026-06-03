import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class SelfStudyUserCard extends StatelessWidget {
  const SelfStudyUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: const Text(
                'LV',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Text('Tuấn', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text('Mục tiêu: ĐH Bách Khoa K50', style: AppTextStyles.caption),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(title: 'Tổng giờ học', value: '150h'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(title: 'Điểm XP', value: '12,400'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(title: 'Hạng tuần', value: '#5'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Huy hiệu nổi bật', style: AppTextStyles.bodyMedium),
                Text(
                  'Xem tất cả',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _BadgeIcon(icon: Icons.emoji_events, color: Color(0xFFFFD666)),
                _BadgeIcon(icon: Icons.menu_book, color: Color(0xFFD6E4FF)),
                _BadgeIcon(
                  icon: Icons.local_fire_department,
                  color: Color(0xFFFFCCC7),
                ),
                _BadgeIcon(icon: Icons.mic, color: Color(0xFFD9F7BE)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(text: 'Thêm bạn bè', onPressed: () {}),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Gửi lời chào'),
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(title, style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _BadgeIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: AppColors.textPrimary, size: 20),
    );
  }
}
