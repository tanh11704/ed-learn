import { apiRequest } from './client.js';

export function getBadges({ page = 0, size = 20 } = {}) {
  return apiRequest(`/admin/badges?page=${page}&size=${size}`);
}

export function getBadge(id) {
  return apiRequest(`/admin/badges/${id}`);
}

export function createBadge(body) {
  return apiRequest('/admin/badges', { method: 'POST', body });
}

export function updateBadge(id, body) {
  return apiRequest(`/admin/badges/${id}`, { method: 'PUT', body });
}

export function deleteBadge(id) {
  return apiRequest(`/admin/badges/${id}`, { method: 'DELETE' });
}
