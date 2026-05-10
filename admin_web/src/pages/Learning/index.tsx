import { useState, useEffect, useCallback } from 'react';
import { Video, BookOpen, FolderPlus, RefreshCw } from 'lucide-react';
import { Lesson } from './types';
import LessonFilters from './components/LessonFilters';
import LessonGrid from './components/LessonGrid';
import UploadLessonModal from './components/UploadLessonModal';
import type { LessonFormPayload } from './components/UploadLessonModal';
import ViewLessonModal from './components/ViewLessonModal';
import LessonDeleteDialog from './components/LessonDeleteDialog';
import {
  listCourses,
  getCourse,
  createCourse,
  createChapter,
  createLesson,
  updateLesson,
  deleteLesson,
  uploadLessonMedia,
} from '../../api/lmsApi';
import type { CourseResponseDto } from '../../api/models/lms.dto';
import { ApiError } from '../../api/ensureOk';
import { useAdminDataCacheStore } from '../../store/useAdminDataCacheStore';

const PLACEHOLDER_THUMB =
  'https://images.unsplash.com/photo-1610484826967-09c5720778c7?w=800&q=80';

function formatUploadDate(iso: string): string {
  try {
    return new Date(iso).toLocaleString('vi-VN', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
    });
  } catch {
    return '—';
  }
}

function flattenLessons(course: CourseResponseDto | null): Lesson[] {
  if (!course) return [];
  const rows: Lesson[] = [];
  for (const ch of course.chapters ?? []) {
    if (ch.isDeleted) continue;
    for (const le of ch.lessons ?? []) {
      const url = le.videoUrl || le.pdfUrl || '';
      rows.push({
        id: le.id,
        title: le.title,
        subject: course.subject,
        duration: '—',
        thumbnail: course.thumbnailUrl || PLACEHOLDER_THUMB,
        videoUrl: url,
        views: 0,
        uploadDate: formatUploadDate(le.createdAt),
        status: 'active',
        chapterId: le.chapterId,
        chapterTitle: ch.title,
        orderIndex: le.orderIndex,
        isPreview: le.isPreview,
      });
    }
  }
  return rows.sort((a, b) => (a.orderIndex ?? 0) - (b.orderIndex ?? 0));
}

export default function LearningManagement() {
  const coursesCache = useAdminDataCacheStore.getState().getCoursesList();
  const [courses, setCourses] = useState<CourseResponseDto[]>(
    () => coursesCache?.courses ?? []
  );
  const [selectedCourseId, setSelectedCourseId] = useState('');
  const [courseDetail, setCourseDetail] = useState<CourseResponseDto | null>(null);
  const [lessons, setLessons] = useState<Lesson[]>([]);
  const [listLoading, setListLoading] = useState(() => !coursesCache?.courses?.length);
  const [listSoftRefresh, setListSoftRefresh] = useState(false);
  const [detailLoading, setDetailLoading] = useState(false);
  const [detailSoftRefresh, setDetailSoftRefresh] = useState(false);
  const [error, setError] = useState('');

  const [searchTerm, setSearchTerm] = useState('');
  const [subjectFilter, setSubjectFilter] = useState('all');

  const [isViewModalOpen, setIsViewModalOpen] = useState(false);
  const [viewingLesson, setViewingLesson] = useState<Lesson | null>(null);

  const [isFormModalOpen, setIsFormModalOpen] = useState(false);
  const [editingLesson, setEditingLesson] = useState<Lesson | null>(null);

  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [deletingLessonId, setDeletingLessonId] = useState<string | null>(null);

  const [courseModalOpen, setCourseModalOpen] = useState(false);
  const [courseCreateError, setCourseCreateError] = useState('');
  const [newCourse, setNewCourse] = useState({ title: '', description: '', subject: '' });
  const [chapterModalOpen, setChapterModalOpen] = useState(false);
  const [newChapter, setNewChapter] = useState({ title: '', orderIndex: 0 });

  const loadCourseList = useCallback(async () => {
    const cached = useAdminDataCacheStore.getState().getCoursesList();
    const hadList = !!(cached?.courses?.length);
    if (hadList) {
      setCourses(cached!.courses);
      setSelectedCourseId((prev) => {
        if (prev && cached!.courses.some((c) => c.id === prev)) return prev;
        return cached!.courses[0]?.id ?? '';
      });
      setListLoading(false);
      setListSoftRefresh(true);
    } else {
      setListLoading(true);
    }
    setError('');
    try {
      const page = await listCourses({ page: 0, size: 100 });
      const list = page.content ?? [];
      useAdminDataCacheStore.getState().setCoursesList(list);
      setCourses(list);
      setSelectedCourseId((prev) => {
        if (prev && list.some((c) => c.id === prev)) return prev;
        return list[0]?.id ?? '';
      });
    } catch (e: unknown) {
      if (!hadList) {
        setError(e instanceof ApiError ? e.message : 'Không tải được danh sách khóa học.');
      } else if (e instanceof ApiError) {
        setError(e.message);
      }
    } finally {
      setListLoading(false);
      setListSoftRefresh(false);
    }
  }, []);

  const refreshCourseDetail = useCallback(async (courseId: string) => {
    if (!courseId) {
      setCourseDetail(null);
      setLessons([]);
      return;
    }
    const cached = useAdminDataCacheStore.getState().getCourseDetail(courseId);
    const hadDetail = !!cached;
    if (cached) {
      setCourseDetail(cached);
      setLessons(flattenLessons(cached));
      setDetailLoading(false);
      setDetailSoftRefresh(true);
    } else {
      setDetailLoading(true);
    }
    try {
      const detail = await getCourse(courseId);
      useAdminDataCacheStore.getState().setCourseDetail(courseId, detail);
      setCourseDetail(detail);
      setLessons(flattenLessons(detail));
    } catch (e: unknown) {
      if (!hadDetail) {
        setError(e instanceof ApiError ? e.message : 'Không tải chi tiết khóa học.');
        setCourseDetail(null);
        setLessons([]);
      } else if (e instanceof ApiError) {
        setError(e.message);
      }
    } finally {
      setDetailLoading(false);
      setDetailSoftRefresh(false);
    }
  }, []);

  useEffect(() => {
    loadCourseList();
  }, [loadCourseList]);

  useEffect(() => {
    if (selectedCourseId) refreshCourseDetail(selectedCourseId);
    else {
      setCourseDetail(null);
      setLessons([]);
    }
  }, [selectedCourseId, refreshCourseDetail]);

  const chapterOptions =
    courseDetail?.chapters
      ?.filter((c) => !c.isDeleted)
      .map((c) => ({ id: c.id, title: c.title })) ?? [];

  const filteredLessons = lessons.filter((l) => {
    const matchSearch = l.title.toLowerCase().includes(searchTerm.toLowerCase());
    const matchSubject = subjectFilter === 'all' || l.subject === subjectFilter;
    return matchSearch && matchSubject;
  });

  const handleDeleteLesson = (id: string) => {
    setDeletingLessonId(id);
    setIsDeleteDialogOpen(true);
  };

  const confirmDelete = async () => {
    if (!deletingLessonId) return;
    try {
      await deleteLesson(deletingLessonId);
      setIsDeleteDialogOpen(false);
      setDeletingLessonId(null);
      if (selectedCourseId) await refreshCourseDetail(selectedCourseId);
    } catch (e: unknown) {
      setError(e instanceof ApiError ? e.message : 'Xóa thất bại.');
    }
  };

  const handleSaveLesson = async (data: LessonFormPayload) => {
    if (editingLesson) {
      await updateLesson(editingLesson.id, {
        chapterId: editingLesson.chapterId ?? data.chapterId,
        title: data.title,
        orderIndex: data.orderIndex,
        isPreview: data.isPreview,
      });
      if (data.mediaFile) {
        const mt = data.mediaFile.type.includes('pdf') ? 'PDF' : 'VIDEO';
        await uploadLessonMedia(editingLesson.id, data.mediaFile, mt);
      }
    } else {
      const created = await createLesson({
        chapterId: data.chapterId,
        title: data.title,
        orderIndex: data.orderIndex,
        isPreview: data.isPreview,
      });
      if (data.mediaFile) {
        const mt = data.mediaFile.type.includes('pdf') ? 'PDF' : 'VIDEO';
        await uploadLessonMedia(created.id, data.mediaFile, mt);
      }
    }
    if (selectedCourseId) await refreshCourseDetail(selectedCourseId);
  };

  const handleCreateCourse = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newCourse.title.trim() || !newCourse.description.trim() || !newCourse.subject.trim()) return;
    setCourseCreateError('');
    setError('');
    try {
      const c = await createCourse({
        title: newCourse.title.trim(),
        description: newCourse.description.trim(),
        subject: newCourse.subject.trim(),
      });
      setCourseModalOpen(false);
      setCourseCreateError('');
      setNewCourse({ title: '', description: '', subject: '' });
      await loadCourseList();
      setSelectedCourseId(c.id);
    } catch (err: unknown) {
      const base =
        err instanceof ApiError ? err.message : 'Tạo khóa học thất bại.';
      const hint500 =
        err instanceof ApiError && err.status >= 500
          ? ' Kiểm tra backend: PostgreSQL, Redis, log container (500 = lỗi phía máy chủ).'
          : '';
      const hintUrl =
        err instanceof ApiError && err.status === 404
          ? ' Kiểm tra VITE_API_BASE_URL chỉ là http://IP:8080 (không thêm /api/v1).'
          : '';
      const full = `${base}${hint500}${hintUrl}`;
      setCourseCreateError(full);
      setError(full);
    }
  };

  const handleCreateChapter = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedCourseId || !newChapter.title.trim()) return;
    try {
      await createChapter({
        courseId: selectedCourseId,
        title: newChapter.title.trim(),
        orderIndex: newChapter.orderIndex,
      });
      setChapterModalOpen(false);
      setNewChapter({ title: '', orderIndex: 0 });
      await refreshCourseDetail(selectedCourseId);
    } catch (err: unknown) {
      setError(err instanceof ApiError ? err.message : 'Tạo chương thất bại.');
    }
  };

  const courseSubject = courseDetail?.subject ?? '—';

  return (
    <div className="space-y-6 max-w-[1600px] mx-auto pb-10">
      <div className="flex flex-col gap-4">
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
          <div>
            <h1 className="text-2xl font-bold text-foreground tracking-tight">Thư viện bài giảng</h1>
            <p className="text-muted-foreground text-sm mt-1">
              Dữ liệu từ API — chọn khóa học, quản lý chương và bài học. Vào lại trang: hiển thị bản đã lưu, làm mới nền.
            </p>
          </div>
          <div className="flex flex-wrap gap-2">
            <button
              type="button"
              onClick={() => loadCourseList()}
              className="flex items-center gap-2 px-3 py-2 border border-border rounded-lg text-sm text-foreground hover:bg-muted"
            >
              <RefreshCw
                size={16}
                className={listLoading || listSoftRefresh ? 'animate-spin' : ''}
              />
              Tải lại
            </button>
            <button
              type="button"
              onClick={() => {
                setCourseCreateError('');
                setCourseModalOpen(true);
              }}
              className="flex items-center gap-2 px-3 py-2 bg-muted border border-border rounded-lg text-sm font-medium"
            >
              <BookOpen size={16} /> Khóa học mới
            </button>
            <button
              type="button"
              disabled={!selectedCourseId}
              onClick={() => {
                const next =
                  (courseDetail?.chapters?.filter((c) => !c.isDeleted).length ?? 0);
                setNewChapter({ title: '', orderIndex: next });
                setChapterModalOpen(true);
              }}
              className="flex items-center gap-2 px-3 py-2 bg-muted border border-border rounded-lg text-sm font-medium disabled:opacity-50"
            >
              <FolderPlus size={16} /> Chương mới
            </button>
            <button
              type="button"
              disabled={!selectedCourseId || chapterOptions.length === 0}
              onClick={() => {
                setEditingLesson(null);
                setIsFormModalOpen(true);
              }}
              className="flex items-center gap-2 px-4 py-2 bg-primary hover:bg-primary/90 text-primary-foreground rounded-lg font-medium transition-all shadow-brand disabled:opacity-50"
            >
              <Video size={18} /> Thêm bài giảng
            </button>
          </div>
        </div>

        <div className="flex flex-wrap items-center gap-3">
          <label className="text-sm text-muted-foreground">Khóa học:</label>
          <select
            value={selectedCourseId}
            onChange={(e) => setSelectedCourseId(e.target.value)}
            disabled={courses.length === 0}
            className="bg-muted border border-border rounded-lg px-3 py-2 text-sm text-foreground min-w-[220px]"
          >
            {courses.length === 0 ? (
              <option value="">— Chưa có khóa học —</option>
            ) : (
              courses.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.title} ({c.subject})
                </option>
              ))
            )}
          </select>
          {detailLoading && !courseDetail && (
            <span className="text-xs text-muted-foreground">Đang tải…</span>
          )}
          {detailSoftRefresh && (
            <span className="text-xs text-muted-foreground">Đang cập nhật…</span>
          )}
        </div>
      </div>

      {error && (
        <div className="p-4 rounded-xl bg-danger/10 border border-danger/25 text-danger text-sm">{error}</div>
      )}

      <LessonFilters
        searchTerm={searchTerm}
        setSearchTerm={setSearchTerm}
        subjectFilter={subjectFilter}
        setSubjectFilter={setSubjectFilter}
      />

      <LessonGrid
        lessons={filteredLessons}
        onView={(lesson) => {
          setViewingLesson(lesson);
          setIsViewModalOpen(true);
        }}
        onEdit={(lesson) => {
          setEditingLesson(lesson);
          setIsFormModalOpen(true);
        }}
        onDelete={handleDeleteLesson}
      />

      <UploadLessonModal
        isOpen={isFormModalOpen}
        onClose={() => setIsFormModalOpen(false)}
        onSave={handleSaveLesson}
        initialData={editingLesson}
        courseSubject={courseSubject}
        chapters={chapterOptions}
        defaultChapterId={chapterOptions[0]?.id}
      />

      <ViewLessonModal
        isOpen={isViewModalOpen}
        onClose={() => setIsViewModalOpen(false)}
        lesson={viewingLesson}
      />

      <LessonDeleteDialog
        isOpen={isDeleteDialogOpen}
        onClose={() => setIsDeleteDialogOpen(false)}
        onConfirm={confirmDelete}
        lessonTitle={
          deletingLessonId ? lessons.find((l) => l.id === deletingLessonId)?.title || '' : ''
        }
      />

      {courseModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center px-4 bg-black/50">
          <form
            onSubmit={handleCreateCourse}
            className="bg-card border border-border rounded-2xl p-6 w-full max-w-md space-y-4 shadow-xl"
          >
            <h3 className="font-bold text-lg text-foreground">Tạo khóa học</h3>
            {courseCreateError && (
              <div className="p-3 rounded-lg bg-danger/10 border border-danger/25 text-danger text-sm">
                {courseCreateError}
              </div>
            )}
            <input
              required
              placeholder="Tiêu đề"
              value={newCourse.title}
              onChange={(e) => setNewCourse((s) => ({ ...s, title: e.target.value }))}
              className="w-full bg-muted border border-border rounded-lg px-3 py-2 text-sm"
            />
            <textarea
              required
              placeholder="Mô tả"
              value={newCourse.description}
              onChange={(e) => setNewCourse((s) => ({ ...s, description: e.target.value }))}
              className="w-full bg-muted border border-border rounded-lg px-3 py-2 text-sm min-h-[80px]"
            />
            <input
              required
              placeholder="Chủ đề (subject)"
              value={newCourse.subject}
              onChange={(e) => setNewCourse((s) => ({ ...s, subject: e.target.value }))}
              className="w-full bg-muted border border-border rounded-lg px-3 py-2 text-sm"
            />
            <div className="flex justify-end gap-2">
              <button
                type="button"
                onClick={() => {
                  setCourseModalOpen(false);
                  setCourseCreateError('');
                }}
                className="px-4 py-2 text-sm"
              >
                Hủy
              </button>
              <button type="submit" className="px-4 py-2 rounded-lg bg-primary text-primary-foreground text-sm">
                Tạo
              </button>
            </div>
          </form>
        </div>
      )}

      {chapterModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center px-4 bg-black/50">
          <form
            onSubmit={handleCreateChapter}
            className="bg-card border border-border rounded-2xl p-6 w-full max-w-md space-y-4 shadow-xl"
          >
            <h3 className="font-bold text-lg text-foreground">Tạo chương</h3>
            <input
              required
              placeholder="Tên chương"
              value={newChapter.title}
              onChange={(e) => setNewChapter((s) => ({ ...s, title: e.target.value }))}
              className="w-full bg-muted border border-border rounded-lg px-3 py-2 text-sm"
            />
            <input
              type="number"
              placeholder="Thứ tự"
              value={newChapter.orderIndex}
              onChange={(e) => setNewChapter((s) => ({ ...s, orderIndex: parseInt(e.target.value, 10) || 0 }))}
              className="w-full bg-muted border border-border rounded-lg px-3 py-2 text-sm"
            />
            <div className="flex justify-end gap-2">
              <button type="button" onClick={() => setChapterModalOpen(false)} className="px-4 py-2 text-sm">
                Hủy
              </button>
              <button type="submit" className="px-4 py-2 rounded-lg bg-primary text-primary-foreground text-sm">
                Tạo
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
