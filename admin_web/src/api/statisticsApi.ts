import { apiJson } from './ensureOk';
import type { DashboardSummaryDto, TopCourseDto } from './models/lms.dto';

export async function getDashboardSummary(): Promise<DashboardSummaryDto> {
  return apiJson<DashboardSummaryDto>({
    url: '/api/v1/statistics/summary',
    method: 'GET',
  });
}

export async function getTopCourses(): Promise<TopCourseDto[]> {
  return apiJson<TopCourseDto[]>({
    url: '/api/v1/statistics/top-courses',
    method: 'GET',
  });
}
