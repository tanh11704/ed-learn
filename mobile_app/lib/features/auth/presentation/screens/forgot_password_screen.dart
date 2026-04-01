import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Quên mật khẩu',
      subtitle: 'Vui lòng nhập email của bạn để nhận mã xác thực OTP.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E8),
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.mail_outline, size: 64, color: Color(0xFF1890FF)),
          ),
          const SizedBox(height: 24),
          const AuthTextField(
            label: 'Email Address',
            hintText: 'Nhập email của bạn',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Gửi mã OTP',
            onPressed: () => context.go('/otp'),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => context.go('/login'),
            child: Text('Quay lại Đăng nhập', style: AppTextStyles.caption),
          ),
        ],
      ),
    );
  }
}
