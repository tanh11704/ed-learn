import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/auth_widgets.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Nhập mã OTP',
      subtitle: 'Chúng tôi đã gửi mã 4 chữ số đến email của bạn.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              OtpBox(value: '-'),
              OtpBox(value: '-'),
              OtpBox(value: '-'),
              OtpBox(value: '-'),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Gửi lại sau 00:30',
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Xác nhận',
            onPressed: () => context.go('/reset-password'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            child: Text('Sử dụng phương thức khác', style: AppTextStyles.caption),
          ),
        ],
      ),
    );
  }
}
