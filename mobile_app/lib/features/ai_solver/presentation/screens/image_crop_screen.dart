import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class ImageCropScreen extends StatefulWidget {
  final String imagePath;
  final String initialSubject;

  const ImageCropScreen({
    super.key,
    required this.imagePath,
    this.initialSubject = 'math',
  });

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final TransformationController _controller = TransformationController();
  int _rotationTurns = 0;
  bool _coverFrame = false;
  String _subject = 'math';

  @override
  void initState() {
    super.initState();
    _subject = widget.initialSubject;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _rotateImage() {
    setState(() {
      _rotationTurns = (_rotationTurns + 1) % 4;
      _controller.value = Matrix4.identity();
    });
  }

  void _toggleFitMode() {
    setState(() {
      _coverFrame = !_coverFrame;
      _controller.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageFile = File(widget.imagePath);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.go('/camera'),
        ),
        title: Text('Cắt & Xoay', style: AppTextStyles.heading2),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 3 / 4.6,
                    child: _CropFrame(
                      child: InteractiveViewer(
                        transformationController: _controller,
                        minScale: 0.7,
                        maxScale: 5,
                        boundaryMargin: const EdgeInsets.all(160),
                        clipBehavior: Clip.none,
                        child: Center(
                          child: Transform.rotate(
                            angle: _rotationTurns * math.pi / 2,
                            child: Image.file(
                              imageFile,
                              fit: _coverFrame ? BoxFit.cover : BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image, size: 96),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _SubjectPicker(
                value: _subject,
                onChanged: (value) {
                  setState(() {
                    _subject = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Kéo ảnh để căn đề vào khung xanh, chụm hai ngón để phóng to/thu nhỏ.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ActionIcon(
                    label: 'XOAY',
                    icon: Icons.crop_rotate,
                    onTap: _rotateImage,
                  ),
                  _ActionIcon(
                    label: 'HỖ TRỢ',
                    icon: Icons.help_outline,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Ưu tiên crop còn đúng một câu hỏi rõ nét.',
                          ),
                        ),
                      );
                    },
                  ),
                  _ActionIcon(
                    label: 'TỶ LỆ',
                    icon: Icons.aspect_ratio,
                    onTap: _toggleFitMode,
                    isActive: _coverFrame,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                text: 'Quét ngay',
                onPressed: () => context.go(
                  '/camera/analyzing',
                  extra: {'imagePath': widget.imagePath, 'subject': _subject},
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SubjectPicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _SubjectPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'Môn học',
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'math', child: Text('Toán')),
        DropdownMenuItem(value: 'biology', child: Text('Sinh học')),
        DropdownMenuItem(value: 'physics', child: Text('Vật lý')),
        DropdownMenuItem(value: 'chemistry', child: Text('Hóa học')),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _CropFrame extends StatelessWidget {
  final Widget child;

  const _CropFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          IgnorePointer(child: CustomPaint(painter: _RuleOfThirdsPainter())),
        ],
      ),
    );
  }
}

class _RuleOfThirdsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.16)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(size.width / 3, 0),
      Offset(size.width / 3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 2 / 3, 0),
      Offset(size.width * 2 / 3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 3),
      Offset(size.width, size.height / 3),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 2 / 3),
      Offset(size.width, size.height * 2 / 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActionIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _ActionIcon({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: isActive ? AppColors.white : AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
