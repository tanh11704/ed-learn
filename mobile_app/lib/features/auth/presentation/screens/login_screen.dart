import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    context.read<AuthBloc>().add(
          LoginSubmitted(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Đăng nhập',
      subtitle: 'Chào mừng trở lại!\nVui lòng đăng nhập để tiếp tục học tập.',
      showBack: false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state.status == AuthStatus.failure && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }

          if (state.status == AuthStatus.authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đăng nhập thành công!')),
            );
            
            // Lấy email từ input
            final email = _emailController.text.trim();
            
            // Kiểm tra xem user đã hoàn thành assessment chưa
            final tokenStorage = TokenStorageService();
            
            // Lưu email user hiện tại
            await tokenStorage.saveCurrentUserEmail(email);
            
            final hasCompletedAssessment = await tokenStorage.hasCompletedAssessment(email);
            
            if (hasCompletedAssessment) {
              // Đã làm assessment rồi -> đi tới home
              context.pushReplacement('/home');
            } else {
              // Chưa làm assessment -> yêu cầu làm bài test đầu vào
              context.pushReplacement('/assessment/intro');
            }
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthTextField(
                label: 'Email',
                hintText: 'example@email.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) {
                    return 'Vui lòng nhập email.';
                  }
                  if (!trimmed.toLowerCase().endsWith('@gmail.com')) {
                    return 'Email phải có đuôi @gmail.com.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Mật khẩu',
                hintText: 'Nhập mật khẩu',
                controller: _passwordController,
                obscureText: _obscurePassword,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) {
                    return 'Vui lòng nhập mật khẩu.';
                  }
                  if (trimmed.length <= 6) {
                    return 'Mật khẩu phải trên 6 ký tự.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.go('/forgot-password'),
                  child: Text('Quên mật khẩu?', style: AppTextStyles.caption),
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state.status == AuthStatus.loading;
                  return PrimaryButton(
                    text: isLoading ? 'Đang đăng nhập...' : 'Đăng nhập',
                    onPressed: isLoading ? null : _submit,
                  );
                },
              ),
              const SizedBox(height: 20),
              const AuthSectionDivider(text: 'HOẶC TIẾP TỤC VỚI'),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 360;
                  if (isNarrow) {
                    return Column(
                      children: const [
                        SizedBox(
                          width: double.infinity,
                          child: AuthSocialButton(
                            label: 'Google',
                            svgAsset: 'assets/icons/google.svg',
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: AuthSocialButton(
                            label: 'Facebook',
                            svgAsset: 'assets/icons/facebook.svg',
                          ),
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: const [
                      Expanded(
                        child: AuthSocialButton(
                          label: 'Google',
                          svgAsset: 'assets/icons/google.svg',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: AuthSocialButton(
                          label: 'Facebook',
                          svgAsset: 'assets/icons/facebook.svg',
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Chưa có tài khoản? ', style: AppTextStyles.bodyMedium),
                  TextButton(
                    onPressed: () => context.go('/register'),
                    child: Text('Đăng ký ngay', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
