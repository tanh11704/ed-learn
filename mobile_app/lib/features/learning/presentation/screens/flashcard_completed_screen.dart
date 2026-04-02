import 'package:flutter/material.dart';

class FlashcardCompletedScreen extends StatelessWidget {
  final String lessonId;
  final String moduleName;
  final int totalFlashcards;
  final int masteredCount;
  final double finalScore;

  const FlashcardCompletedScreen({
    Key? key,
    required this.lessonId,
    required this.moduleName,
    required this.totalFlashcards,
    required this.masteredCount,
    required this.finalScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final percent = (finalScore * 100).clamp(0, 100).toDouble();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kết quả Flashcard',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildScoreCard(percent),
            const SizedBox(height: 24),
            _buildStatsRow(),
            const SizedBox(height: 24),
            _buildSummaryText(),
            const Spacer(),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(double percent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 8),
          Text(
            '${percent.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Hoàn thành phiên học',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            label: 'Đã thuộc',
            value: '$masteredCount/$totalFlashcards',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            label: 'Tỉ lệ',
            value: '${(finalScore * 100).toStringAsFixed(0)}%',
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryText() {
    final summary = masteredCount == totalFlashcards
        ? 'Xuất sắc! Bạn đã thuộc tất cả thẻ.'
        : 'Bạn đã thuộc $masteredCount trên $totalFlashcards thẻ.';

    return Text(
      summary,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Retry: restart flashcard session
              Navigator.pop(context, 'retry');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Làm lại'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context, 'back');
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Quay lại bài học'),
          ),
        ),
      ],
    );
  }
}
