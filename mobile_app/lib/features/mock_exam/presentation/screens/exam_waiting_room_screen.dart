
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/mock_exam/data/models/exam_session_args.dart';

class ExamWaitingRoomScreen extends StatelessWidget {
  const ExamWaitingRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ExamSessionArgs.fromExtra(GoRouterState.of(context).extra);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'Chuẩn bị vào phòng thi',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Center(
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.shield_outlined,
                    size: 64, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              args.examTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thời gian: ${args.durationMinutes} phút',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            const Text(
              'Quy định phòng thi',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
            ),
            const SizedBox(height: 12),
            const _RuleItem(
              icon: Icons.notifications_off_outlined,
              title: 'Không gian yên tĩnh',
              subtitle:
                  'Đảm bảo không có tiếng ồn xung quanh ảnh hưởng đến bài thi.',
              iconColor: Color(0xFFFF8A65),
            ),
            const SizedBox(height: 12),
            const _RuleItem(
              icon: Icons.menu_book_outlined,
              title: 'Không sử dụng tài liệu',
              subtitle:
                  'Tuyệt đối không sử dụng tài liệu dưới mọi hình thức.',
              iconColor: Color(0xFFFF8A65),
            ),
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline, color: Color(0xFF3B82F6)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Camera chỉ dùng để AI tự động giám sát công bằng.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF2563EB)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('/exam/camera-check', extra: args);
                },
                icon: const Icon(Icons.videocam_outlined, color: Colors.white),
                label: const Text(
                  'Đồng ý và Cấp quyền Camera',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E6BFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;

  const _RuleItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}
