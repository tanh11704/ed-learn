import { apiRequest } from './client.js';

export function createLesson(body) {
  return apiRequest('/management/lessons', { method: 'POST', body });
}

export function updateLesson(id, body) {
  return apiRequest(`/management/lessons/${id}`, { method: 'PUT', body });
}

export function reorderLessons(chapterId, lessonIds) {
  return apiRequest(`/management/lessons/chapter/${chapterId}/reorder`, {
    method: 'PUT',
    body: { lessonIds },
  });
}

export function updateLessonVideoUrl(id, videoUrl) {
  return apiRequest(`/management/lessons/${id}/video-url`, {
    method: 'PUT',
    body: { videoUrl },
  });
}

export function deleteLesson(id) {
  return apiRequest(`/management/lessons/${id}`, { method: 'DELETE' });
}

export function uploadLessonMedia(id, file, mediaType = 'VIDEO') {
  const form = new FormData();
  form.append('file', file);
  return apiRequest(
    `/management/lessons/${id}/upload?mediaType=${mediaType}`,
    { method: 'POST', body: form },
  );
}
