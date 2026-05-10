import { apiFormPost, apiJson } from './ensureOk';
import type {
  ChapterResponseDto,
  CourseResponseDto,
  CustomPageDto,
  LessonResponseDto,
} from './models/lms.dto';

export async function listCourses(params?: {
  subject?: string;
  page?: number;
  size?: number;
}): Promise<CustomPageDto<CourseResponseDto>> {
  const page = params?.page ?? 0;
  const size = params?.size ?? 50;
  return apiJson<CustomPageDto<CourseResponseDto>>({
    url: '/api/v1/courses',
    method: 'GET',
    params: {
      page,
      size,
      ...(params?.subject ? { subject: params.subject } : {}),
    },
  });
}

export async function getCourse(id: string): Promise<CourseResponseDto> {
  return apiJson<CourseResponseDto>({
    url: `/api/v1/courses/${id}`,
    method: 'GET',
  });
}

export async function createCourse(body: {
  title: string;
  description: string;
  subject: string;
}): Promise<CourseResponseDto> {
  return apiJson<CourseResponseDto>({
    url: '/api/v1/courses',
    method: 'POST',
    body,
  });
}

export async function updateCourse(
  id: string,
  body: {
    title: string;
    description: string;
    subject: string;
    thumbnailUrl?: string | null;
  }
): Promise<CourseResponseDto> {
  return apiJson<CourseResponseDto>({
    url: `/api/v1/courses/${id}`,
    method: 'PUT',
    body,
  });
}

export async function deleteCourse(id: string): Promise<void> {
  await apiJson<unknown>({
    url: `/api/v1/courses/${id}`,
    method: 'DELETE',
  });
}

export async function createChapter(body: {
  courseId: string;
  title: string;
  orderIndex: number;
}): Promise<ChapterResponseDto> {
  return apiJson<ChapterResponseDto>({
    url: '/api/v1/chapters',
    method: 'POST',
    body: {
      courseId: body.courseId,
      title: body.title,
      orderIndex: body.orderIndex,
    },
  });
}

export async function createLesson(body: {
  chapterId: string;
  title: string;
  orderIndex: number | null;
  isPreview: boolean;
}): Promise<LessonResponseDto> {
  return apiJson<LessonResponseDto>({
    url: '/api/v1/management/lessons',
    method: 'POST',
    body: {
      chapterId: body.chapterId,
      title: body.title,
      orderIndex: body.orderIndex,
      isPreview: body.isPreview,
    },
  });
}

export async function updateLesson(
  id: string,
  body: {
    chapterId: string | null;
    title: string;
    orderIndex: number | null;
    isPreview: boolean | null;
  }
): Promise<LessonResponseDto> {
  return apiJson<LessonResponseDto>({
    url: `/api/v1/management/lessons/${id}`,
    method: 'PUT',
    body,
  });
}

export async function deleteLesson(id: string): Promise<void> {
  await apiJson<unknown>({
    url: `/api/v1/management/lessons/${id}`,
    method: 'DELETE',
  });
}

export async function uploadLessonMedia(
  lessonId: string,
  file: File,
  mediaType: 'VIDEO' | 'PDF'
): Promise<LessonResponseDto> {
  const fd = new FormData();
  fd.append('file', file);
  const path = `/api/v1/management/lessons/${lessonId}/upload?mediaType=${encodeURIComponent(mediaType)}`;
  return apiFormPost<LessonResponseDto>(path, fd);
}
