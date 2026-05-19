import { apiRequest } from './client.js';

export function getDashboardSummary() {
  return apiRequest('/statistics/summary');
}

export function getTopCourses() {
  return apiRequest('/statistics/top-courses');
}

export function getMonthlyEnrollments(year) {
  const q = year ? `?year=${year}` : '';
  return apiRequest(`/statistics/monthly-enrollments${q}`);
}
