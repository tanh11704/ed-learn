/** Khớp CustomPage từ backend */
export interface CustomPageDto<T> {
  content: T[];
  pageNumber: number;
  pageSize: number;
  totalElements: number;
  totalPages: number;
  last: boolean;
}

export interface LessonResponseDto {
  id: string;
  chapterId: string;
  title: string;
  videoUrl: string | null;
  pdfUrl: string | null;
  orderIndex: number;
  isPreview: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface ChapterResponseDto {
  id: string;
  courseId: string;
  title: string;
  orderIndex: number;
  lessons: LessonResponseDto[];
  isDeleted?: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface CourseResponseDto {
  id: string;
  title: string;
  description: string;
  subject: string;
  thumbnailUrl: string | null;
  chapters: ChapterResponseDto[];
  createdAt: string;
  updatedAt: string;
}

export interface DashboardSummaryDto {
  totalStudents: number;
  totalActiveCourses: number;
  currentMonthEnrollments: number;
  currentMonthRevenue: number;
}

export interface TopCourseDto {
  courseId: string;
  title: string;
  totalStudents: number;
}
