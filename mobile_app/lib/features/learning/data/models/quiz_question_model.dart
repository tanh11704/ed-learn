class QuizQuestion {
  final int id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
  });

  // Factory constructor from JSON
  factory QuizQuestion.fromJson(Map<String, dynamic> json, {int? fallbackId}) {
    final options = _parseOptions(json);
    final rawAnswer = (json['correctAnswer'] ?? json['answer'] ?? '').toString();
    final correctOption = (json['correctOption'] ?? json['correctAnswerKey'] ?? '').toString();
    final correctAnswer = _normalizeCorrectAnswer(
      options: options,
      rawAnswer: rawAnswer,
      correctOption: correctOption,
      correctIndex: json['correctIndex'],
    );

    return QuizQuestion(
      id: _parseId(json['id']) ?? fallbackId ?? 0,
      question: (json['question'] ?? json['prompt'] ?? '').toString(),
      options: options,
      correctAnswer: correctAnswer,
      explanation: json['explanation']?.toString(),
    );
  }

  static int? _parseId(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static String _answerFromOptionLabel(List<String> options, String label) {
    final index = 'ABCD'.indexOf(label.trim().toUpperCase());
    if (index >= 0 && index < options.length) return options[index];
    return '';
  }

  static List<String> _parseOptions(Map<String, dynamic> json) {
    final rawOptions = json['options'] ?? json['answers'] ?? json['choices'];
    if (rawOptions is List) {
      return rawOptions
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList();
    }

    final directOptions = [
      json['optionA'],
      json['optionB'],
      json['optionC'],
      json['optionD'],
    ]
        .map((item) => item?.toString() ?? '')
        .where((item) => item.trim().isNotEmpty)
        .toList();
    if (directOptions.isNotEmpty) return directOptions;

    if (rawOptions is String) {
      final trimmed = rawOptions.trim();
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        return trimmed
            .substring(1, trimmed.length - 1)
            .split(',')
            .map((item) => item.replaceAll(RegExp(r'''^["'\s]+|["'\s]+$'''), ''))
            .where((item) => item.trim().isNotEmpty)
            .toList();
      }
    }

    return [];
  }

  static String _normalizeCorrectAnswer({
    required List<String> options,
    required String rawAnswer,
    required String correctOption,
    dynamic correctIndex,
  }) {
    final answer = rawAnswer.trim();
    if (answer.length == 1 && 'ABCD'.contains(answer.toUpperCase())) {
      return _answerFromOptionLabel(options, answer);
    }
    if (answer.isNotEmpty) return answer;

    if (correctOption.trim().isNotEmpty) {
      return _answerFromOptionLabel(options, correctOption);
    }

    final index = correctIndex is num
        ? correctIndex.toInt()
        : int.tryParse(correctIndex?.toString() ?? '');
    if (index != null && index >= 0 && index < options.length) {
      return options[index];
    }

    return '';
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }

  // Copy with method for immutability
  QuizQuestion copyWith({
    int? id,
    String? question,
    List<String>? options,
    String? correctAnswer,
    String? explanation,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
    );
  }
}
