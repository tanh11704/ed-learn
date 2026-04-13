import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool a = true;
  bool b = true;
  bool c = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0, title: Text('Thông báo & Giao diện', style: AppTextStyles.heading2)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cài đặt thông báo', style: AppTextStyles.bodyLarge),
          const SizedBox(height: 10),
          _tile('Nhắc nhở học tập hằng ngày', 'Nhận thông báo để duy trì thói quen học.', a, (v) => setState(() => a = v)),
          _tile('Thông báo phòng Pomodoro mới', 'Thông báo khi bạn bè học nhóm.', b, (v) => setState(() => b = v)),
          _tile('Cập nhật & Khuyến mãi', 'Thông tin về tính năng mới và gói ưu đãi.', c, (v) => setState(() => c = v)),
          const SizedBox(height: 18),
          Text('Ngôn ngữ hiển thị', style: AppTextStyles.bodyLarge),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(children: [Text('Tiếng Việt', style: AppTextStyles.bodyMedium), const Spacer(), const Icon(Icons.keyboard_arrow_down)]),
          ),
        ]),
      ),
    );
  }

  Widget _tile(String title, String sub, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: AppTextStyles.bodyMedium), Text(sub, style: AppTextStyles.caption)])), Switch(value: value, activeThumbColor: AppColors.primary, onChanged: onChanged)]),
    );
  }
}
