import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  bool _isWeek = true;

  static final _topThree = [
    _Leader(name: 'Thùy Trang', xp: '9,820 XP', rank: 2),
    _Leader(name: 'Phương Nam', xp: '12,500 XP', rank: 1),
    _Leader(name: 'Hoàng Thành', xp: '8,150 XP', rank: 3),
  ];

  static final _ranking = [
    _RankItem(
      position: 4,
      name: 'Văn Đức',
      xp: '7,200 XP',
      trendUp: true,
      isMe: true,
    ),
    _RankItem(position: 5, name: 'Quang Thắng', xp: '6,850 XP'),
    _RankItem(position: 6, name: 'Xuân Tuấn', xp: '6,100 XP', trendUp: false),
    _RankItem(position: 7, name: 'Bảo Ngọc', xp: '5,920 XP', trendUp: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text('Bảng xếp hạng', style: AppTextStyles.heading2),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: _periodButton(
                      title: 'Tuần này',
                      selected: _isWeek,
                      onTap: () => setState(() => _isWeek = true),
                    ),
                  ),
                  Expanded(
                    child: _periodButton(
                      title: 'Tháng này',
                      selected: !_isWeek,
                      onTap: () => setState(() => _isWeek = false),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _podiumPerson(_topThree[0], 74, false)),
                Expanded(child: _podiumPerson(_topThree[1], 112, true)),
                Expanded(child: _podiumPerson(_topThree[2], 62, false)),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(children: _ranking.map(_rankingRow).toList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _periodButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _podiumPerson(_Leader person, double barHeight, bool isFirst) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: isFirst ? 38 : 28,
              backgroundColor: AppColors.primary,
              child: CircleAvatar(
                radius: isFirst ? 34 : 24,
                backgroundColor: Colors.orange.shade100,
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: isFirst ? 34 : 22,
                ),
              ),
            ),
            if (isFirst)
              const Positioned(
                top: -16,
                left: 0,
                right: 0,
                child: Icon(
                  Icons.workspace_premium,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
            Positioned(
              bottom: -4,
              right: -4,
              child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${person.rank}',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          person.name,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(person.xp, style: AppTextStyles.caption),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: barHeight,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isFirst
                ? AppColors.primary.withValues(alpha: 0.28)
                : AppColors.border.withValues(alpha: 0.55),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            border: Border.all(color: AppColors.border),
          ),
        ),
      ],
    );
  }

  Widget _rankingRow(_RankItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: item.isMe
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${item.position}',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const CircleAvatar(
            radius: 16,
            child: Icon(Icons.person_outline, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(item.xp, style: AppTextStyles.caption),
              ],
            ),
          ),
          _trendIcon(item.trendUp),
        ],
      ),
    );
  }

  Widget _trendIcon(bool? trendUp) {
    if (trendUp == null) {
      return Text(
        '—',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }
    return Icon(
      trendUp ? Icons.trending_up : Icons.trending_down,
      color: trendUp ? Colors.green : Colors.red,
      size: 18,
    );
  }
}

class _Leader {
  final String name;
  final String xp;
  final int rank;

  const _Leader({required this.name, required this.xp, required this.rank});
}

class _RankItem {
  final int position;
  final String name;
  final String xp;
  final bool? trendUp;
  final bool isMe;

  const _RankItem({
    required this.position,
    required this.name,
    required this.xp,
    this.trendUp,
    this.isMe = false,
  });
}
