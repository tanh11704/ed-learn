import { apiRequest } from './client.js';

export function getCourseProgress(courseId) {
  const params = new URLSearchParams({ courseId });
  return apiRequest(`/management/course-progress?${params}`);
}
