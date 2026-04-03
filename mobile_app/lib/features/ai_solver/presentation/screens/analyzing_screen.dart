import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/scanner_bloc/scanner_bloc.dart';
import '../bloc/scanner_bloc/scanner_state.dart';

class AnalyzingScreen extends StatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    _autoTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.go('/camera/solution-detail');
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'AI Solver',
          style: AppTextStyles.heading2,
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ScannerBloc, ScannerState>(
          builder: (context, state) {
            if (state is ScannerBlurError) {
              return _BlurErrorBody();
            }

            final progress = state is ScannerProcessing ? state.progress : 0.65;
            return _AnalyzingBody(progress: progress);
          },
        ),
      ),
    );
  }
}

class _AnalyzingBody extends StatelessWidget {
  final double progress;

  const _AnalyzingBody({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology,
                    size: 72,
                    color: Color(0xFF3DDCFF),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'AI đang đọc đề và tìm lời giải...',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Vui lòng chờ giây lát...',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _Dot(isActive: true),
                    _Dot(),
                    _Dot(),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        color: AppColors.primary,
                        backgroundColor: const Color(0xFFE5E7EB),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('${(progress * 100).round()}%'),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(
            text: 'Hủy quá trình',
            onPressed: () => context.go('/camera'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _BlurErrorBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.white,
                child: Icon(Icons.error_outline, size: 40, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Ảnh hơi mờ, vui lòng quét lại!',
            style: AppTextStyles.heading2.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Để có kết quả tốt nhất, hãy dùng ảnh in rõ nét và cung cấp đủ ánh sáng.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            text: 'Quét lại',
            onPressed: () => context.go('/camera'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.go('/camera/solution-detail'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            icon: const Icon(Icons.edit_note),
            label: Text(
              'Gõ đề bài',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;

  const _Dot({this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : const Color(0xFFCBD5F0),
        shape: BoxShape.circle,
      ),
    );
  }
}
