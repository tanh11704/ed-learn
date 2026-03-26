import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/auth_widgets.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Tạo mật khẩu mới',
      subtitle: 'Mật khẩu mới của bạn phải khác với các mật khẩu đã sử dụng trước đó.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthTextField(
            label: 'Mật khẩu mới',
            hintText: 'Nhập mật khẩu mới',
            obscureText: true,
            suffix: Icon(Icons.visibility_off, size: 18),
          ),
          const SizedBox(height: 16),
          const AuthTextField(
            label: 'Độ mạnh mật khẩu',
            hintText: 'Mạnh',
            suffix: Icon(Icons.check_circle, size: 18, color: AppColors.success),
          ),
          const SizedBox(height: 16),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sử dụng ít nhất 8 ký tự, bao gồm chữ cái và số.',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 16),
          const AuthTextField(
            label: 'Xác nhận mật khẩu',
            hintText: 'Nhập lại mật khẩu',
            obscureText: true,
            suffix: Icon(Icons.visibility_off, size: 18),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Lưu & Đăng nhập',
            onPressed: () => context.go('/login'),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              const Icon(Icons.lock, size: 40, color: AppColors.primaryLight),
              const SizedBox(height: 8),
              Text('Kết nối an toàn & bảo mật', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
