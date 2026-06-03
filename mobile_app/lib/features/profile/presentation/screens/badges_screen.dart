import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/datasources/user_badge_remote_datasource.dart';
import '../../data/models/user_badge_models.dart';
import '../../data/repositories/user_badge_repository_impl.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  late final UserBadgeRepositoryImpl _repository;
  late final Future<List<UserBadgeResponse>> _badgesFuture;

  final List<IconData> _badgeIcons = const [
    Icons.emoji_events_outlined,
    Icons.menu_book_rounded,
    Icons.bolt_rounded,
    Icons.star_rounded,
    Icons.shield_outlined,
    Icons.local_fire_department,
  ];

  final List<Color> _badgeColors = const [
    Color(0xFFFF7E36),
    Color(0xFFB94ADD),
    Color(0xFF20C997),
    Color(0xFF2E7BEF),
    Color(0xFF6A5AE0),
    Color(0xFFFFB200),
  ];

  @override
  void initState() {
    super.initState();
    _repository = UserBadgeRepositoryImpl(UserBadgeRemoteDataSourceImpl());
    _badgesFuture = _loadBadges();
  }

  Future<List<UserBadgeResponse>> _loadBadges() async {
    final response = await _repository.getMyBadges(page: 0, size: 50);
    return response.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text('Huy hiệu của tôi', style: AppTextStyles.heading2),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
      ),
      body: FutureBuilder<List<UserBadgeResponse>>(
        future: _badgesFuture,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    'Không tải được huy hiệu',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _badgesFuture = _loadBadges();
                    }),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data ?? [];
          final unlockedCount = data.length;
          final totalCount = (unlockedCount < 12) ? 12 : unlockedCount;
          final badges = _buildBadgeItems(data, totalCount: totalCount);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5F0),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFFDCCB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BỘ SƯU TẬP HUY HIỆU',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFFFF7E36),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '$unlockedCount huy hiệu',
                            style: AppTextStyles.heading1,
                          ),
                          const Spacer(),
                          Text(
                            '$unlockedCount / $totalCount đã mở',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          minHeight: 9,
                          value: totalCount > 0
                              ? unlockedCount / totalCount
                              : 0.0,
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.emoji_events_outlined,
                            size: 16,
                            color: Color(0xFFFF7E36),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            unlockedCount == 0
                                ? 'Hoàn thành thử thách để nhận huy hiệu đầu tiên!'
                                : 'Bạn đã mở khóa $unlockedCount huy hiệu. Tiếp tục nào!',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('Bộ sưu tập', style: AppTextStyles.heading1),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unlockedCount/$totalCount ĐÃ MỞ',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: badges.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.76,
                  ),
                  itemBuilder: (context, index) {
                    final badge = badges[index];
                    final card = _badgeItem(
                      badge,
                      onTap: badge.unlocked
                          ? () => context.go('/profile/badges/detail')
                          : null,
                    );
                    return badge.unlocked
                        ? card
                        : Opacity(opacity: 0.78, child: card);
                  },
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF1FA),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.workspace_premium_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sắp nhận được huy hiệu mới',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Hoàn thành thêm 2 bài học tiếng Anh để mở khóa "Bậc thầy ngôn ngữ".',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<_BadgeItem> _buildBadgeItems(
    List<UserBadgeResponse> data, {
    required int totalCount,
  }) {
    final unlocked = data.asMap().entries.map((entry) {
      final index = entry.key;
      final badge = entry.value;
      return _BadgeItem(
        name: badge.badgeName,
        icon: _badgeIcons[index % _badgeIcons.length],
        color: _badgeColors[index % _badgeColors.length],
        unlocked: true,
        imageUrl: badge.imageUrl,
        description: badge.badgeDescription,
        earnedAt: badge.earnedAt,
        xpReward: badge.xpReward,
      );
    }).toList();

    final lockedCount = (totalCount - unlocked.length).clamp(0, 6);
    final locked = List.generate(
      lockedCount,
      (index) => const _BadgeItem(
        name: 'Chưa mở',
        icon: Icons.lock_outline_rounded,
        color: Color(0xFFAEB4C1),
        unlocked: false,
        xpReward: 0,
      ),
    );

    return [...unlocked, ...locked];
  }

  Widget _badgeItem(_BadgeItem badge, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: badge.unlocked ? badge.color : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: badge.unlocked
                    ? Colors.transparent
                    : const Color(0xFFBAC2D1),
                width: 1.5,
              ),
              boxShadow: badge.unlocked
                  ? [
                      BoxShadow(
                        color: badge.color.withValues(alpha: 0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: badge.unlocked && badge.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      badge.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Icon(badge.icon, color: Colors.white, size: 28),
                    ),
                  )
                : Icon(
                    badge.icon,
                    color: badge.unlocked
                        ? Colors.white
                        : const Color(0xFF9EA5B5),
                    size: 28,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            badge.name,
            style: AppTextStyles.bodyMedium.copyWith(
              color: badge.unlocked
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (badge.unlocked && badge.xpReward > 0) ...[
            const SizedBox(height: 2),
            Text(
              '+${badge.xpReward} XP',
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFFFF7E36),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BadgeItem {
  final String name;
  final IconData icon;
  final Color color;
  final bool unlocked;
  final String? imageUrl;
  final String? description;
  final String? earnedAt;
  final int xpReward;

  const _BadgeItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.unlocked,
    required this.xpReward,
    this.imageUrl,
    this.description,
    this.earnedAt,
  });
}
