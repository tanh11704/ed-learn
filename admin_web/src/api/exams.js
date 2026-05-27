import { apiRequest } from './client.js';

export function getExams({ status } = {}) {
  const params = new URLSearchParams();
  if (status) params.set('status', status);
  const query = params.toString();
  return apiRequest(`/admin/exams${query ? `?${query}` : ''}`);
}

export function createExam(body) {
  return apiRequest('/admin/exams', { method: 'POST', body });
}

export function updateExam(id, body) {
  return apiRequest(`/admin/exams/${id}`, { method: 'PUT', body });
}

export function deleteExam(id) {
  return apiRequest(`/admin/exams/${id}`, { method: 'DELETE' });
}

export function getExam(id) {
  return apiRequest(`/admin/exams/${id}`);
}

export function getExamQuestions(id) {
  return apiRequest(`/admin/exams/${id}/questions`);
}

function toQuestionFormData(body) {
  const form = new FormData();
  if (body.examId) form.append('examId', body.examId);
  if (body.questionType) form.append('questionType', body.questionType);
  if (body.paperPart) form.append('paperPart', body.paperPart);
  form.append('content', body.content || '');
  form.append('orderIndex', String(body.orderIndex ?? 0));
  form.append('score', String(body.score));
  if (body.correctAnswer) form.append('correctAnswer', body.correctAnswer);
  if (body.imageUrl) form.append('imageUrl', body.imageUrl);
  if (body.imageFile) form.append('imageFile', body.imageFile);
  if (body.options) form.append('optionsJson', JSON.stringify(body.options));
  return form;
}

export function createQuestion(body) {
  return apiRequest('/admin/exams/questions', {
    method: 'POST',
    body: body?.imageFile ? toQuestionFormData(body) : body,
  });
}

export function updateQuestion(questionId, body) {
  return apiRequest(`/admin/exams/questions/${questionId}`, {
    method: 'PUT',
    body: body?.imageFile ? toQuestionFormData(body) : body,
  });
}

export function getQuestionOptions(questionId) {
  return apiRequest(`/admin/exams/questions/${questionId}/options`);
}

export function createOption(questionId, body) {
  return apiRequest(`/admin/exams/questions/${questionId}/options`, {
    method: 'POST',
    body,
  });
}

export function updateOption(questionId, optionId, body) {
  return apiRequest(
    `/admin/exams/questions/${questionId}/options/${optionId}`,
    { method: 'PUT', body },
  );
}

export function deleteOption(questionId, optionId) {
  return apiRequest(
    `/admin/exams/questions/${questionId}/options/${optionId}`,
    { method: 'DELETE' },
  );
}
