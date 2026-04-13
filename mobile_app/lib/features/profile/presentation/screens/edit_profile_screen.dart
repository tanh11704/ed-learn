import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Chỉnh sửa thông tin', style: AppTextStyles.heading2),
        actions: [TextButton(onPressed: () {}, child: const Text('Lưu'))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(radius: 46, backgroundColor: AppColors.white, child: Icon(Icons.person, size: 44, color: AppColors.primary.withValues(alpha: 0.8))),
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _field('Họ và tên', 'Nguyễn Minh Quân'),
            _field('Số điện thoại', '+84 0987 654 321'),
            _field('Email', 'minhquan.ng@design.vn'),
            _field('Trường học hiện tại', 'Đại học Kiến trúc TP. Hồ Chí Minh', hasChevron: true),
            const SizedBox(height: 12),
            Center(child: Text('Đổi mật khẩu', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600))),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Row(
                children: [
                  const Icon(Icons.privacy_tip_outlined, color: AppColors.warning),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Hiển thị hồ sơ công khai', style: AppTextStyles.bodyMedium)),
                  Switch(value: true, activeThumbColor: AppColors.primary, onChanged: (_) {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, String value, {bool hasChevron = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTextStyles.caption),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [Expanded(child: Text(value, style: AppTextStyles.bodyMedium)), if (hasChevron) const Icon(Icons.keyboard_arrow_down)],
            ),
          ),
        ],
      ),
    );
  }
}
