import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/profile_action_tile.dart';
import '../widgets/profile_stat_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Cá nhân', style: AppTextStyles.heading2),
        actions: [
          IconButton(onPressed: () => context.go('/profile/settings'), icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.white,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: const Icon(Icons.person, size: 42, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 10),
            Text('Nguyễn Văn Đức', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text('nguyenvan@email.com', style: AppTextStyles.caption),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text('THÀNH VIÊN PREMIUM', style: AppTextStyles.caption.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  ProfileStatItem(value: '5 ngày', label: 'CHUỖI', icon: Icons.local_fire_department),
                  ProfileStatItem(value: '1250 XP', label: 'TỔNG ĐIỂM', icon: Icons.stars),
                  ProfileStatItem(value: 'Cấp 12', label: 'XẾP HẠNG', icon: Icons.military_tech),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ProfileActionTile(
              icon: Icons.edit_note,
              title: 'Chỉnh sửa thông tin',
              onTap: () => context.go('/profile/edit'),
            ),
            const SizedBox(height: 10),
            ProfileActionTile(
              icon: Icons.flag_outlined,
              title: 'Mục tiêu học tập',
              onTap: () => context.go('/profile/study-goal'),
            ),
            const SizedBox(height: 10),
            ProfileActionTile(
              icon: Icons.workspace_premium,
              title: 'Nâng cấp Premium',
              subtitle: 'Mở khóa toàn bộ AI học',
              onTap: () => context.go('/profile/premium'),
            ),
            const SizedBox(height: 10),
            ProfileActionTile(
              icon: Icons.task_alt,
              title: 'Nhiệm vụ học tập',
              onTap: () => context.go('/profile/tasks'),
            ),
            const SizedBox(height: 10),
            ProfileActionTile(
              icon: Icons.leaderboard,
              title: 'Bảng xếp hạng',
              onTap: () => context.go('/profile/ranking'),
            ),
            const SizedBox(height: 10),
            ProfileActionTile(
              icon: Icons.shield_outlined,
              title: 'Huy hiệu của tôi',
              onTap: () => context.go('/profile/badges'),
            ),
            const SizedBox(height: 10),
            ProfileActionTile(
              icon: Icons.storefront,
              title: 'Đổi điểm XP',
              onTap: () => context.go('/profile/xp-store'),
            ),
          ],
        ),
      ),
    );
  }
}
