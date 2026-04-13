import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class BadgeDetailScreen extends StatelessWidget {
  const BadgeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0, title: Text('Chi tiết huy hiệu', style: AppTextStyles.heading2)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              CircleAvatar(radius: 34, backgroundColor: Colors.amber.shade100, child: Icon(Icons.workspace_premium, color: Colors.amber.shade700, size: 38)),
              const SizedBox(height: 12),
              Text('Streak Master', style: AppTextStyles.heading2),
              const SizedBox(height: 6),
              Text('Duy trì streak học tập liên tục 7 ngày', style: AppTextStyles.caption, textAlign: TextAlign.center),
            ]),
          ),
          const SizedBox(height: 16),
          PrimaryButton(text: 'Chia sẻ huy hiệu', onPressed: () {}),
        ]),
      ),
    );
  }
}
