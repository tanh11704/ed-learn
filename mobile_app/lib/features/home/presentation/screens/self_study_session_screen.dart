import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'self_study_user_card.dart';

class SelfStudySessionScreen extends StatefulWidget {
  const SelfStudySessionScreen({super.key});

  @override
  State<SelfStudySessionScreen> createState() => _SelfStudySessionScreenState();
}

class _SelfStudySessionScreenState extends State<SelfStudySessionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PHÒNG TỰ HỌC', style: AppTextStyles.bodyLarge),
            Text('SESSION ACTIVE', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 6),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => _TimerCircle(progress: _controller.value),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book, color: AppColors.primary, size: 18),
                  const SizedBox(width: 6),
                  Text('Chủ đề: Đạo hàm & Tích phân', style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('STUDY GROUP (12)', style: AppTextStyles.caption),
            ),
            const SizedBox(height: 10),
            _ParticipantsGrid(
              onProfileTap: () => _showProfile(context),
            ),
            const Spacer(),
            _SessionActions(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const SelfStudyUserCard(),
    );
  }
}

class _TimerCircle extends StatelessWidget {
  final double progress;

  const _TimerCircle({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 210,
            width: 210,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          Positioned(
            top: 20,
            child: SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('24:59', style: AppTextStyles.heading1.copyWith(fontSize: 32)),
              Text('Đang tập trung...', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParticipantsGrid extends StatelessWidget {
  final VoidCallback onProfileTap;

  const _ParticipantsGrid({required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final participants = const [
      'Bạn',
      'Minh',
      'Lan',
      'Tuấn',
      'Hà',
      'Bảo',
      'Trang',
      'Others',
    ];

    return Wrap(
      spacing: 18,
      runSpacing: 18,
      children: participants.map((name) {
        return GestureDetector(
          onTap: onProfileTap,
          child: Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(name.characters.first, style: AppTextStyles.caption),
              ),
              const SizedBox(height: 6),
              Text(name, style: AppTextStyles.caption),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SessionActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _IconButton(icon: Icons.mic_off, onTap: () {}),
            const SizedBox(width: 12),
            _IconButton(icon: Icons.music_note, onTap: () {}),
            const SizedBox(width: 12),
            _IconButton(icon: Icons.pause_circle_filled, onTap: () {}),
            const SizedBox(width: 12),
            _IconButton(icon: Icons.chat_bubble_outline, onTap: () {}),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 160,
          child: ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text('Rời phòng'),
          ),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
    );
  }
}
