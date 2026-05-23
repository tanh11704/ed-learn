import { apiRequest } from './client.js';

export function getCourseProgress() {
  return apiRequest('/management/course-progress');
}
