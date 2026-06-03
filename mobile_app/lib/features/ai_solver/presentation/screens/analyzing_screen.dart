import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/datasources/ai_solver_remote_datasource.dart';

class AnalyzingScreen extends StatefulWidget {
  final String imagePath;
  final String subject;

  const AnalyzingScreen({
    super.key,
    required this.imagePath,
    this.subject = 'math',
  });

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  final AiSolverRemoteDataSource _dataSource = AiSolverRemoteDataSource();
  String? _errorMessage;
  bool _isSolving = true;

  @override
  void initState() {
    super.initState();
    _solve();
  }

  Future<void> _solve() async {
    setState(() {
      _isSolving = true;
      _errorMessage = null;
    });

    try {
      final solution = await _dataSource.solveImage(
        image: File(widget.imagePath),
        subject: widget.subject,
        gradeLevel: '12',
        language: 'vi',
      );
      if (!mounted) return;
      context.go(
        '/camera/solution-detail',
        extra: {'solution': solution, 'imagePath': widget.imagePath},
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isSolving = false;
      });
    }
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
          onPressed: () => context.go(
            '/camera/crop',
            extra: {'imagePath': widget.imagePath, 'subject': widget.subject},
          ),
        ),
        title: Text('AI Solver', style: AppTextStyles.heading2),
      ),
      body: SafeArea(
        child: _errorMessage == null
            ? _AnalyzingBody(isSolving: _isSolving)
            : _ErrorBody(
                message: _errorMessage!,
                onRetry: _solve,
                onRetake: () => context.go('/camera'),
              ),
      ),
    );
  }
}

class _AnalyzingBody extends StatelessWidget {
  final bool isSolving;

  const _AnalyzingBody({required this.isSolving});

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
                  'Ảnh đang được gửi lên ai-service. Vui lòng chờ giây lát.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                if (isSolving)
                  const CircularProgressIndicator(color: AppColors.primary),
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

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onRetake;

  const _ErrorBody({
    required this.message,
    required this.onRetry,
    required this.onRetake,
  });

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
                child: Icon(
                  Icons.error_outline,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Không thể giải ảnh này',
            style: AppTextStyles.heading2.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          PrimaryButton(text: 'Thử lại', onPressed: onRetry),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetake,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text(
              'Chụp lại',
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
