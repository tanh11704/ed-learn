import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../../../core/constants/app_text_styles.dart';

class MathTextView extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool selectable;

  const MathTextView({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.left,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedStyle = style ?? AppTextStyles.bodyLarge.copyWith(height: 1.4);
    final latex = _normalizeLatex(text);

    return Math.tex(
      latex,
      textStyle: resolvedStyle,
      textScaleFactor: 1,
      mathStyle: MathStyle.text,
    );
  }

  String _normalizeLatex(String value) {
    final trimmed = value.trim();
    if (trimmed.startsWith(r'$') && trimmed.endsWith(r'$')) {
      return trimmed.substring(1, trimmed.length - 1);
    }

    final hasLatexSymbols = RegExp(r'[\\^_=+*/]|\\sqrt|\\frac').hasMatch(trimmed);
    if (hasLatexSymbols) {
      return trimmed;
    }

    return r'\text{' + trimmed + r'}';
  }
}
