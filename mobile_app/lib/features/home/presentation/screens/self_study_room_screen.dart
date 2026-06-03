import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'self_study_room_sheet.dart';

class SelfStudyRoomScreen extends StatefulWidget {
  const SelfStudyRoomScreen({super.key});

  @override
  State<SelfStudyRoomScreen> createState() => _SelfStudyRoomScreenState();
}

class _SelfStudyRoomScreenState extends State<SelfStudyRoomScreen> {
  String _selectedFilter = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    final rooms = const [
      _RoomCardData(
        title: 'Phòng Cày Toán 9+',
        subject: 'BÀNG TẬP TRUNG',
        members: 15,
        total: 20,
        timeLeft: '15/20',
      ),
      _RoomCardData(
        title: 'Cố lên 2k8 - Luyện đề Anh',
        subject: 'BÀNG NGHĨ GIAO',
        members: 8,
        total: 12,
        timeLeft: '8/12',
      ),
      _RoomCardData(
        title: 'Group Study 101 - Lý thuyết',
        subject: 'BÀNG TẬP TRUNG',
        members: 18,
        total: 25,
        timeLeft: '18/25',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Phòng tự học chung', style: AppTextStyles.heading2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateRoomSheet(context),
        backgroundColor: AppColors.primary,
        label: const Text('Tạo phòng mới'),
        icon: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 60,
                      width: 80,
                      color: AppColors.primary.withValues(alpha: 0.15),
                      child: const Icon(
                        Icons.people_alt,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cùng học, cùng tiến bộ',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tham gia cùng 1,240 học sinh đang online',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'Tất cả',
                    isSelected: _selectedFilter == 'Tất cả',
                    onTap: () => setState(() => _selectedFilter = 'Tất cả'),
                  ),
                  _FilterChip(
                    label: 'Toán học',
                    isSelected: _selectedFilter == 'Toán học',
                    onTap: () => setState(() => _selectedFilter = 'Toán học'),
                  ),
                  _FilterChip(
                    label: 'Tiếng Anh',
                    isSelected: _selectedFilter == 'Tiếng Anh',
                    onTap: () => setState(() => _selectedFilter = 'Tiếng Anh'),
                  ),
                  _FilterChip(
                    label: 'Ngữ văn',
                    isSelected: _selectedFilter == 'Ngữ văn',
                    onTap: () => setState(() => _selectedFilter = 'Ngữ văn'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Phòng đang hoạt động', style: AppTextStyles.bodyLarge),
                Text(
                  'Xem thêm',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...rooms.map(
              (room) => _RoomCard(
                data: room,
                onJoin: () => context.go('/home/self-study/session'),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _showCreateRoomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SelfStudyRoomSheet(),
    );
  }
}

class _RoomCardData {
  final String title;
  final String subject;
  final int members;
  final int total;
  final String timeLeft;

  const _RoomCardData({
    required this.title,
    required this.subject,
    required this.members,
    required this.total,
    required this.timeLeft,
  });
}

class _RoomCard extends StatelessWidget {
  final _RoomCardData data;
  final VoidCallback onJoin;

  const _RoomCard({required this.data, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.subject,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(data.title, style: AppTextStyles.bodyLarge),
                const SizedBox(height: 6),
                Text(
                  '👥 ${data.members}/${data.total} • ${data.timeLeft}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 34,
            child: ElevatedButton(
              onPressed: onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Tham gia'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
