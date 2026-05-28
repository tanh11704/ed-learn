import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../data/models/exam_session_models.dart';
import '../../data/repositories/exam_repository_impl.dart';

class ExamSolutionDetailScreen extends StatefulWidget {
  final String? attemptId;

  const ExamSolutionDetailScreen({super.key, this.attemptId});

  @override
  State<ExamSolutionDetailScreen> createState() =>
      _ExamSolutionDetailScreenState();
}

class _ExamSolutionDetailScreenState extends State<ExamSolutionDetailScreen> {
  final _repository = ExamRepositoryImpl();
  late Future<ExamAttemptReview> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadReview();
  }

  Future<ExamAttemptReview> _loadReview() {
    final attemptId = widget.attemptId;
    if (attemptId == null || attemptId.isEmpty) {
      return Future.error('Không tìm thấy mã phiên thi để xem lại bài làm.');
    }
    return _repository.getAttemptReview(attemptId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'Xem lại bài làm',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<ExamAttemptReview>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _future = _loadReview());
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final questions = snapshot.data?.session.questions ?? [];
            if (questions.isEmpty) {
              return const Center(child: Text('Chưa có dữ liệu xem lại.'));
            }

            final hasCorrectAnswer = questions.any(
              (question) => question.options.any(
                (option) => option.isCorrect != null,
              ),
            );

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: questions.length + (hasCorrectAnswer ? 0 : 1),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (!hasCorrectAnswer && index == 0) {
                  return const _ReviewNotice();
                }
                final question = questions[hasCorrectAnswer ? index : index - 1];
                return _ReviewQuestionCard(
                  number: hasCorrectAnswer ? index + 1 : index,
                  total: questions.length,
                  question: question,
                  hasCorrectAnswer: hasCorrectAnswer,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ReviewNotice extends StatelessWidget {
  const _ReviewNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: const Text(
        'Backend chưa trả cờ đáp án đúng/sai trong API review, nên màn này chỉ đang hiển thị lại đề và các lựa chọn. Khi API trả isCorrect/correct cho option, app sẽ tự tô đáp án đúng màu xanh.',
        style: TextStyle(fontSize: 12, color: Color(0xFF9A3412), height: 1.35),
      ),
    );
  }
}

class _ReviewQuestionCard extends StatelessWidget {
  final int number;
  final int total;
  final ExamQuestionDto question;
  final bool hasCorrectAnswer;

  const _ReviewQuestionCard({
    required this.number,
    required this.total,
    required this.question,
    required this.hasCorrectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final sortedOptions = List<ExamOptionDto>.from(question.options)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

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
          Text(
            'CÂU HỎI $number/$total',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 8),
          _ExamFormattedText(
            question.content,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.35,
            ),
          ),
          if (question.imageUrl != null && question.imageUrl!.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(question.imageUrl!, fit: BoxFit.contain),
            ),
          ],
          const SizedBox(height: 12),
          ...sortedOptions.asMap().entries.map((entry) {
            final label = String.fromCharCode(65 + entry.key);
            return _AnswerTile(
              label: '$label.',
              option: entry.value,
              hasCorrectAnswer: hasCorrectAnswer,
            );
          }),
        ],
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  final String label;
  final ExamOptionDto option;
  final bool hasCorrectAnswer;

  const _AnswerTile({
    required this.label,
    required this.option,
    required this.hasCorrectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = option.isCorrect == true;
    final color = isCorrect ? const Color(0xFF22C55E) : const Color(0xFFE5E7EB);
    final icon = hasCorrectAnswer && isCorrect
        ? Icons.check_circle
        : Icons.circle_outlined;

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
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isCorrect ? FontWeight.w600 : FontWeight.w500,
              color: isCorrect ? const Color(0xFF15803D) : Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ExamFormattedText(
              _stripOptionLabel(option.content),
              style: TextStyle(
                fontWeight: isCorrect ? FontWeight.w600 : FontWeight.w500,
                color: isCorrect ? const Color(0xFF15803D) : Colors.black87,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamFormattedText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _ExamFormattedText(this.text, {required this.style});

  @override
  Widget build(BuildContext context) {
    final normalized = _normalizeText(text);
    final parts = _splitMath(normalized);
    if (parts.length == 1 && !parts.first.isMath) {
      return Text(normalized, style: style);
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 2,
      runSpacing: 4,
      children: parts.map((part) {
        if (!part.isMath) return Text(part.value, style: style);
        return Math.tex(
          part.value,
          textStyle: style,
          mathStyle: MathStyle.text,
          textScaleFactor: 1,
          onErrorFallback: (_) => Text(part.value, style: style),
        );
      }).toList(),
    );
  }
}

class _TextPart {
  final String value;
  final bool isMath;

  const _TextPart(this.value, this.isMath);
}

List<_TextPart> _splitMath(String value) {
  final parts = <_TextPart>[];
  final regex = RegExp(r'\\\((.*?)\\\)|\\\[(.*?)\\\]');
  var cursor = 0;
  for (final match in regex.allMatches(value)) {
    if (match.start > cursor) {
      parts.add(_TextPart(value.substring(cursor, match.start), false));
    }
    parts.add(_TextPart((match.group(1) ?? match.group(2) ?? '').trim(), true));
    cursor = match.end;
  }
  if (cursor < value.length) {
    final rest = value.substring(cursor);
    final looksLikeMath = RegExp(r'\\frac|\\sqrt|[_^{}]').hasMatch(rest);
    parts.add(_TextPart(rest, looksLikeMath));
  }
  return parts.where((part) => part.value.isNotEmpty).toList();
}

String _normalizeText(String value) {
  return value
      .replaceAll(r'\n', '\n')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String _stripOptionLabel(String value) {
  return value.replaceFirst(RegExp(r'^[A-H]\.\s*'), '').trim();
}
