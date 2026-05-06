import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0, title: Text('Cài đặt', style: AppTextStyles.heading2)),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.failure && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }

          if (state.status == AuthStatus.unauthenticated) {
            context.go('/login');
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TÀI KHOẢN', style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Column(
                  children: [
                    SettingsTile(icon: Icons.lock_outline, title: 'Bảo mật & Mật khẩu', onTap: () {}),
                    const Divider(height: 1),
                    SettingsTile(icon: Icons.devices_outlined, title: 'Quản lý thiết bị', onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text('HỆ THỐNG', style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Column(
                  children: [
                    SettingsTile(icon: Icons.notifications_none, title: 'Cài đặt Thông báo', onTap: () => context.go('/profile/settings/notifications')),
                    const Divider(height: 1),
                    SettingsTile(icon: Icons.public, title: 'Giao diện & Ngôn ngữ', onTap: () => context.go('/profile/settings/notifications')),
                    const Divider(height: 1),
                    SettingsTile(icon: Icons.cleaning_services_outlined, title: 'Xóa bộ nhớ đệm', trailingText: '109 MB', onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text('HỖ TRỢ', style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Column(
                  children: [
                    SettingsTile(icon: Icons.help_outline, title: 'Trung tâm trợ giúp', onTap: () {}),
                    const Divider(height: 1),
                    SettingsTile(icon: Icons.policy_outlined, title: 'Điều khoản & Chính sách', onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Center(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state.status == AuthStatus.loading;
                    return TextButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              final confirm = await _showLogoutDialog(context);
                              if (confirm != true || !context.mounted) return;
                              context.read<AuthBloc>().add(LogoutRequested());
                            },
                      child: Text('Đăng xuất tài khoản', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error)),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Xác nhận đăng xuất', style: AppTextStyles.heading2),
          content: Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này?', style: AppTextStyles.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('Hủy', style: AppTextStyles.bodyMedium),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Đăng xuất', style: AppTextStyles.buttonText),
            ),
          ],
        );
      },
    );
  }
}
