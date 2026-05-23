import { apiRequest } from './client.js';

export function getExamAttemptSummary(examId) {
  return apiRequest(`/management/exam-attempts/exams/${examId}/summary`);
}

export function getExamAttemptStudents(examId) {
  return apiRequest(`/management/exam-attempts/exams/${examId}/students`);
}

export function getExamAttemptsByGrade(examId) {
  return apiRequest(`/management/exam-attempts/exams/${examId}/by-grade`);
}
