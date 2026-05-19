import { apiRequest } from './client.js';

export function getCourses({ page = 0, size = 20, subject } = {}) {
  const params = new URLSearchParams({ page, size });
  if (subject) params.set('subject', subject);
  return apiRequest(`/courses?${params}`);
}

export function getCourseDetail(id) {
  return apiRequest(`/courses/${id}`);
}

export function createCourse(body) {
  return apiRequest('/courses/admin', { method: 'POST', body });
}

export function updateCourse(id, body) {
  return apiRequest(`/courses/admin/${id}`, { method: 'PUT', body });
}

export function deleteCourse(id) {
  return apiRequest(`/courses/admin/${id}`, { method: 'DELETE' });
}
