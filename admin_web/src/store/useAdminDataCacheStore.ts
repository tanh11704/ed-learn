import { create } from 'zustand';
import type { AdminUserDto } from '../api/models/adminUser.dto';
import type { CourseResponseDto } from '../api/models/lms.dto';

/** Thời gian coi dữ liệu cache còn “đủ mới” để hiển thị ngay khi vào lại trang (vẫn gọi API cập nhật nền). */
export const ADMIN_DATA_CACHE_TTL_MS = 5 * 60 * 1000;

export function adminUsersCacheKey(page: number, search: string): string {
  return `p${page}:q${search}`;
}

type UsersSnapshot = {
  rows: AdminUserDto[];
  totalPages: number;
  totalElements: number;
  fetchedAt: number;
};

type CoursesSnapshot = {
  courses: CourseResponseDto[];
  fetchedAt: number;
};

type CourseDetailEntry = {
  detail: CourseResponseDto;
  fetchedAt: number;
};

interface AdminDataCacheState {
  usersByKey: Record<string, UsersSnapshot>;
  coursesList: CoursesSnapshot | null;
  courseDetailById: Record<string, CourseDetailEntry>;

  setUsersSnapshot: (
    key: string,
    payload: { rows: AdminUserDto[]; totalPages: number; totalElements: number }
  ) => void;
  getUsersSnapshot: (key: string) => UsersSnapshot | null;

  setCoursesList: (courses: CourseResponseDto[]) => void;
  getCoursesList: () => CoursesSnapshot | null;
  invalidateCoursesList: () => void;

  setCourseDetail: (id: string, detail: CourseResponseDto) => void;
  getCourseDetail: (id: string) => CourseResponseDto | null;
  invalidateCourseDetail: (id: string) => void;
}

export const useAdminDataCacheStore = create<AdminDataCacheState>((set, get) => ({
  usersByKey: {},
  coursesList: null,
  courseDetailById: {},

  setUsersSnapshot: (key, payload) =>
    set((s) => ({
      usersByKey: {
        ...s.usersByKey,
        [key]: {
          rows: payload.rows,
          totalPages: payload.totalPages,
          totalElements: payload.totalElements,
          fetchedAt: Date.now(),
        },
      },
    })),

  getUsersSnapshot: (key) => get().usersByKey[key] ?? null,

  setCoursesList: (courses) =>
    set({
      coursesList: { courses, fetchedAt: Date.now() },
    }),

  getCoursesList: () => get().coursesList,

  invalidateCoursesList: () => set({ coursesList: null }),

  setCourseDetail: (id, detail) =>
    set((s) => ({
      courseDetailById: {
        ...s.courseDetailById,
        [id]: { detail, fetchedAt: Date.now() },
      },
    })),

  getCourseDetail: (id) => get().courseDetailById[id]?.detail ?? null,

  invalidateCourseDetail: (id) =>
    set((s) => {
      const next = { ...s.courseDetailById };
      delete next[id];
      return { courseDetailById: next };
    }),
}));
