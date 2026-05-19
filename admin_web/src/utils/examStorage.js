export function examQuestionStorageKey(examId) {
  return `edlearn_exam_questions_${examId}`;
}

export function readStoredExamQuestions(examId) {
  try {
    const raw = localStorage.getItem(examQuestionStorageKey(examId));
    const parsed = raw ? JSON.parse(raw) : [];
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}

export function writeStoredExamQuestions(examId, questions) {
  try {
    localStorage.setItem(examQuestionStorageKey(examId), JSON.stringify(questions));
  } catch {
    // Local preview storage is best-effort only.
  }
}
