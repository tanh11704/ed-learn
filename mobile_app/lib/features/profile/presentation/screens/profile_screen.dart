import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../home/data/datasources/home_remote_datasource.dart';
import '../../../home/data/models/user_model.dart';
import '../../../home/data/models/user_streak_model.dart';
import '../widgets/profile_action_tile.dart';
import '../widgets/profile_stat_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final HomeRemoteDataSource _dataSource = HomeRemoteDatasourceImpl();

  bool _isLoading = true;
  UserModel? _user;
  UserStreakModel? _streak;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _dataSource.getUserInfo(),
        _dataSource.getUserStreak(),
      ]);
      if (!mounted) return;
      setState(() {
        _user = results[0] as UserModel;
        _streak = results[1] as UserStreakModel;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Cá nhân', style: AppTextStyles.heading2),
        actions: [
          if (!_isLoading)
            IconButton(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh_outlined),
              tooltip: 'Làm mới',
            ),
          IconButton(
            onPressed: () => context.go('/profile/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ── Avatar ──
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: AppColors.white,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                        backgroundImage: (_user?.avatar != null && _user!.avatar!.isNotEmpty)
                            ? NetworkImage(_user!.avatar!)
                            : null,
                        child: (_user?.avatar == null || _user!.avatar!.isEmpty)
                            ? const Icon(Icons.person, size: 42, color: AppColors.primary)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Tên & Email từ API ──
                    Text(
                      _user?.name.isNotEmpty == true ? _user!.name : 'Người dùng',
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _user?.email ?? '—',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 8),

                    // ── Badge thành viên ──
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'THÀNH VIÊN PREMIUM',
                        style: AppTextStyles.caption.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Stats: streak từ API, XP & cấp placeholder ──
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        children: [
                          // Streak từ API
                          ProfileStatItem(
                            value: _streak != null
                                ? '${_streak!.currentStreak} ngày'
                                : '0 ngày',
                            label: 'CHUỖI',
                            icon: Icons.local_fire_department,
                            iconColor: _streak != null && _streak!.currentStreak > 0
                                ? Colors.deepOrange
                                : Colors.grey,
                          ),
                          // XP — chưa có API
                          const ProfileStatItem(
                            value: '— XP',
                            label: 'TỔNG ĐIỂM',
                            icon: Icons.stars,
                          ),
                          // Cấp — chưa có API
                          const ProfileStatItem(
                            value: '—',
                            label: 'XẾP HẠNG',
                            icon: Icons.military_tech,
                          ),
                        ],
                      ),
                    ),

                    // ── Streak detail nếu có ──
                    if (_streak != null && _streak!.longestStreak > 0) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.emoji_events_rounded,
                                size: 14, color: Colors.amber),
                            const SizedBox(width: 6),
                            Text(
                              'Chuỗi dài nhất: ${_streak!.longestStreak} ngày',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.orange[800],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_streak!.streakFreezeCount > 0) ...[
                              const SizedBox(width: 12),
                              const Icon(Icons.ac_unit_rounded,
                                  size: 14, color: Colors.blueAccent),
                              const SizedBox(width: 4),
                              Text(
                                '${_streak!.streakFreezeCount} đóng băng',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // ── Menu actions ──
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
            ),
    );
  }
}
