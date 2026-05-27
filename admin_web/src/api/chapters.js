import { apiRequest } from './client.js';

export function getChaptersByCourse(courseId, { status = 'ACTIVE' } = {}) {
  const params = new URLSearchParams({ courseId });
  if (status) params.set('status', status);
  return apiRequest(`/management/chapters?${params}`);
}

export function createChapter(body) {
  return apiRequest('/management/chapters', { method: 'POST', body });
}

export function updateChapter(id, body) {
  return apiRequest(`/management/chapters/${id}`, { method: 'PUT', body });
}

export function reorderChapters(courseId, chapterIds) {
  return apiRequest(`/management/chapters/course/${courseId}/reorder`, {
    method: 'PUT',
    body: { chapterIds },
  });
}

export function deleteChapter(id) {
  return apiRequest(`/management/chapters/${id}`, { method: 'DELETE' });
}
