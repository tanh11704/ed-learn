import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/mock_exam/data/models/exam_session_args.dart';

class CameraCheckScreen extends StatefulWidget {
  const CameraCheckScreen({super.key});

  @override
  State<CameraCheckScreen> createState() => _CameraCheckScreenState();
}

class _CameraCheckScreenState extends State<CameraCheckScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  // 2. Hàm khởi tạo Camera
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Ưu tiên chọn Camera trước (Front Camera)
      final frontCam = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        frontCam,
        ResolutionPreset.medium,
        enableAudio: false, // Tắt tiếng để tránh hú khi kiểm tra
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint("Camera error: $e");
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  @override
  void dispose() {
    // 3. QUAN TRỌNG: Giải phóng camera khi thoát màn hình để tránh nóng máy/tốn pin
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              'Kiểm tra Camera',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Xác thực danh tính trước khi bắt đầu',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 28),

            // --- KHU VỰC HIỂN THỊ CAMERA ---
            Center(
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E293B),
                  border: Border.all(color: const Color(0xFF2563EB), width: 2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Hiển thị luồng Camera thực tế
                    ClipOval(
                      child: SizedBox(
                        width: 290,
                        height: 290,
                        child: _isInitialized
                            ? AspectRatio(
                                aspectRatio:
                                    1, // Ép khung hình vuông để cắt tròn đẹp
                                child: CameraPreview(_controller!),
                              )
                            : _hasError
                            ? const Icon(
                                Icons.videocam_off,
                                color: Colors.red,
                                size: 50,
                              )
                            : const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),
            const Text(
              'Vui lòng giữ khuôn mặt của bạn\ntrong khung hình',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 44),

            // --- THANH TRẠNG THÁI KIỂM TRA ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CheckItem(
                    label: 'ÁNH SÁNG',
                    icon: Icons.wb_sunny,
                    isActive: _isInitialized,
                  ),
                  _CheckItem(
                    label: 'CAMERA',
                    icon: Icons.videocam,
                    isActive: _isInitialized,
                  ),
                  _CheckItem(label: 'MICRO', icon: Icons.mic, isActive: true),
                ],
              ),
            ),

            const Spacer(),

            // --- NÚT BẮT ĐẦU ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isInitialized
                      ? () {
                          final args = ExamSessionArgs.fromExtra(
                            GoRouterState.of(context).extra,
                          );
                          context.go('/exam/exam-session', extra: args);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    disabledBackgroundColor: Colors.grey.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  label: const Text(
                    'Bắt đầu làm bài',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;

  const _CheckItem({
    required this.label,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isActive
              ? const Color(0xFF16A34A)
              : Colors.grey.withValues(alpha: 0.2),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Icon(
          isActive ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 12,
          color: isActive ? const Color(0xFF22C55E) : Colors.grey,
        ),
      ],
    );
  }
}
