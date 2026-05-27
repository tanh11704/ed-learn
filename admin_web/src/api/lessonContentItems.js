import { apiRequest } from './client.js';

export function getLessonContentItems(lessonId, { type } = {}) {
  const params = new URLSearchParams();
  if (type) params.set('type', type);
  const query = params.toString();
  return apiRequest(`/management/lessons/${lessonId}/content-items${query ? `?${query}` : ''}`);
}

export function createLessonContentItem(lessonId, body) {
  return apiRequest(`/management/lessons/${lessonId}/content-items`, {
    method: 'POST',
    body,
  });
}

export function updateLessonContentItem(itemId, body) {
  return apiRequest(`/management/lesson-content-items/${itemId}`, {
    method: 'PUT',
    body,
  });
}

export function deleteLessonContentItem(itemId) {
  return apiRequest(`/management/lesson-content-items/${itemId}`, { method: 'DELETE' });
}
