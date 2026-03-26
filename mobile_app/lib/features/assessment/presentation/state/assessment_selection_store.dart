import 'package:flutter/foundation.dart';

class AssessmentSelectionStore {
  AssessmentSelectionStore._();

  static final ValueNotifier<String> selectedExamBlock = ValueNotifier<String>('A00');
}
