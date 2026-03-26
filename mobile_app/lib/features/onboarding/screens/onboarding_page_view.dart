import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'adaptive_learning_page.dart';
import 'smart_exam_page.dart';
import 'splash_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({
    super.key,
    required this.pages,
  });

  final List<Widget> pages;

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  final _controller = PageController();
  int _pageIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_pageIndex < widget.pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  const Spacer(),
                  if (_pageIndex < widget.pages.length - 1)
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text('Bỏ qua', style: AppTextStyles.bodyMedium),
                    )
                  else
                    const SizedBox(height: 36),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.pages.length,
                onPageChanged: (index) => setState(() => _pageIndex = index),
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final page = _controller.hasClients
                          ? _controller.page ?? _pageIndex.toDouble()
                          : _pageIndex.toDouble();
                      final delta = (page - index).abs();
                      final scale = 1 - (delta * 0.05).clamp(0.0, 0.08);
                      final opacity = 1 - (delta * 0.15).clamp(0.0, 0.3);
                      return Transform.scale(
                        scale: scale,
                        child: Opacity(opacity: opacity, child: child),
                      );
                    },
                    child: widget.pages[index],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  _DotsIndicator(length: widget.pages.length, index: _pageIndex),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(width: 72),
                      const Spacer(),
                      SizedBox(
                        width: 180,
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: _goNext,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                          ),
                          icon: Icon(
                            _pageIndex == widget.pages.length - 1
                                ? Icons.arrow_forward_rounded
                                : Icons.arrow_right_alt_rounded,
                          ),
                          label: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              _pageIndex == widget.pages.length - 1
                                  ? 'Bắt đầu ngay'
                                  : 'Next',
                              style: AppTextStyles.buttonText,
                              key: ValueKey(_pageIndex == widget.pages.length - 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.length, required this.index});

  final int length;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 22 : 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}

const List<Widget> defaultOnboardingPages = [
  SplashScreen(),
  AdaptiveLearningPage(),
  SmartExamPage(),
];
