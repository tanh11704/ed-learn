import { apiRequest } from './client.js';

export function getMe() {
  return apiRequest('/users/me');
}

export function updateMe(body) {
  return apiRequest('/users/me', { method: 'PUT', body });
}

export function getMyStreak() {
  return apiRequest('/user-streaks/me');
}

export function getMyBadges({ page = 0, size = 20 } = {}) {
  return apiRequest(`/user-badges/me?page=${page}&size=${size}`);
}

export function getMyCourses() {
  return apiRequest('/users/my-courses');
}
