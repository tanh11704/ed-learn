import { apiRequest } from './client.js';

export function getChaptersByCourse(courseId) {
  return apiRequest(`/management/chapters?courseId=${courseId}`);
}

export function createChapter(body) {
  return apiRequest('/management/chapters', { method: 'POST', body });
}

export function updateChapter(id, body) {
  return apiRequest(`/management/chapters/${id}`, { method: 'PUT', body });
}

export function deleteChapter(id) {
  return apiRequest(`/management/chapters/${id}`, { method: 'DELETE' });
}
