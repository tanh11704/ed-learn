import 'package:flutter/material.dart';

class ExamSolutionDetailScreen extends StatelessWidget {
  const ExamSolutionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {Navigator.of(context).maybePop();},
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'Chi tiết lời giải',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        centerTitle: true,
        actions: [
      IconButton(
        onPressed: () {
          // Thoát hẳn về trang danh sách đề thi
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        icon: const Icon(Icons.close, color: Colors.black87),
        tooltip: 'Thoát',
      ),
      const SizedBox(width: 8), // Khoảng cách nhỏ giữa nút đóng và mép phải
    ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _QuestionCard(),
            const SizedBox(height: 16),
            _AnswerSummary(),
            const SizedBox(height: 16),
            const Text(
              'Các bước giải chi tiết',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const _StepCard(
              stepNumber: 1,
              title: 'Xác định công thức',
              description: 'Bài toán yêu cầu tính cạnh huyền của tam giác vuông.',
              formula: 'BC² = AB² + AC²',
            ),
            const _StepCard(
              stepNumber: 2,
              title: 'Thay số vào công thức',
              description: 'Thay AB = 9 và AC = 12.',
              formula: 'BC² = 9² + 12² = 81 + 144 = 225',
            ),
            const _StepCard(
              stepNumber: 3,
              title: 'Kết luận',
              description: 'Lấy căn bậc hai của 225.',
              formula: 'BC = √225 = 15',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E6BFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Xem câu tiếp theo',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CÂU HỎI 24/50',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Trong các đặc điểm sau đây, đặc điểm nào là quan trọng nhất để phân biệt một hợp chất hữu cơ với một hợp chất vô cơ?',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _AnswerTile(label: 'A.', text: 'Khả năng tan trong nước', isCorrect: false),
          _AnswerTile(label: 'B.', text: 'Sự hiện diện của nguyên tố Carbon', isCorrect: true),
          _AnswerTile(label: 'C.', text: 'Trạng thái vật lý ở nhiệt độ thường', isCorrect: false),
          _AnswerTile(label: 'D.', text: 'Màu sắc đặc trưng của hợp chất', isCorrect: false),
        ],
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  final String label;
  final String text;
  final bool isCorrect;

  const _AnswerTile({
    required this.label,
    required this.text,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? const Color(0xFF22C55E) : const Color(0xFFE5E7EB);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFEFFDF5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(isCorrect ? Icons.check_circle : Icons.circle_outlined, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label  $text',
              style: TextStyle(
                fontWeight: isCorrect ? FontWeight.w600 : FontWeight.w500,
                color: isCorrect ? const Color(0xFF15803D) : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(Icons.lightbulb_outline, color: Color(0xFF2563EB)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Đáp án đúng: B. Sự hiện diện của nguyên tố Carbon',
              style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;
  final String formula;

  const _StepCard({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.formula,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: const Color(0xFF2563EB),
                child: Text(
                  stepNumber.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            formula,
            style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1D4ED8)),
          ),
        ],
      ),
    );
  }
}