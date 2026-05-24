import { apiRequest } from './client.js';

export function getErrorBankStudentStatistics() {
  return apiRequest('/management/error-bank/students/statistics');
}
