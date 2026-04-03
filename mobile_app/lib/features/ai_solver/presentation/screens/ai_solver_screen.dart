import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class AiSolverScreen extends StatelessWidget {
  const AiSolverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F1E16),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Quét câu hỏi',
          style: AppTextStyles.heading2.copyWith(color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF3C2B22),
            child: const Center(
              child: Icon(Icons.camera_alt, size: 96, color: Colors.white54),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 120,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 1.4,
                ),
              ),
              child: Center(
                child: Text(
                  'Giữ đề bài trong khung',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 220,
            child: Column(
              children: [
                _RoundIconButton(icon: Icons.flash_on, onPressed: () {}),
                const SizedBox(height: 12),
                _RoundIconButton(icon: Icons.zoom_in, onPressed: () {}),
                const SizedBox(height: 12),
                _RoundIconButton(icon: Icons.rotate_right, onPressed: () {}),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Căn chỉnh đề bài trong khung',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Đảm bảo chữ viết rõ nét và đủ ánh sáng',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _BottomIcon(
                        icon: Icons.photo_library_outlined,
                        label: 'Thư viện',
                      ),
                      InkWell(
                        onTap: () => context.go('/camera/crop'),
                        borderRadius: BorderRadius.circular(48),
                        child: Container(
                          height: 76,
                          width: 76,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.camera_alt, color: AppColors.white, size: 32),
                        ),
                      ),
                      _BottomIcon(
                        icon: Icons.bolt_outlined,
                        label: 'Tự động',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _RoundIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.white, size: 20),
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BottomIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
