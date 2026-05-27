import { useEffect, useMemo, useState } from 'react';
import { ArrowDown, ArrowUp, FileUp, Plus, Trash2 } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as coursesApi from '../api/courses.js';
import * as chaptersApi from '../api/chapters.js';
import * as lessonsApi from '../api/lessons.js';

const LESSON_TYPES = {
  VIDEO: {
    label: 'Video',
    prefix: '',
    titleLabel: 'Tiêu đề video',
    placeholder: 'Ví dụ: Khái niệm và ý nghĩa đạo hàm',
    submitLabel: 'Tạo video bài học',
  },
  FLASHCARD: {
    label: 'Flashcard',
    prefix: 'Flashcard',
    titleLabel: 'Tên bộ flashcard',
    placeholder: 'Ví dụ: Đạo hàm của hàm hợp',
    submitLabel: 'Tạo flashcard',
  },
  EXERCISE: {
    label: 'Exercise',
    prefix: 'Bài tập',
    titleLabel: 'Tên bài tập',
    placeholder: 'Ví dụ: Bài tập rèn luyện quy tắc tính',
    submitLabel: 'Tạo bài tập',
  },
};

function getLessonType(title = '') {
  const normalized = title.toLowerCase();
  if (normalized.includes('flashcard') || normalized.includes('flash card') || normalized.includes('thẻ')) {
    return 'FLASHCARD';
  }
  if (
    normalized.includes('exercise') ||
    normalized.includes('bài tập') ||
    normalized.includes('luyện tập') ||
    normalized.includes('quiz') ||
    normalized.includes('kiểm tra')
  ) {
    return 'EXERCISE';
  }
  return 'VIDEO';
}

function getTypedLessonTitle(type, title) {
  const trimmedTitle = title.trim();
  const config = LESSON_TYPES[type] || LESSON_TYPES.VIDEO;
  if (!config.prefix || trimmedTitle.toLowerCase().startsWith(config.prefix.toLowerCase())) {
    return trimmedTitle;
  }
  return `${config.prefix}: ${trimmedTitle}`;
}

function getItemNumber(title = '') {
  const match = title.match(/(?:chuong|chương|chapter|bai|bài|lesson)\s*(\d+)/i);
  return match ? Number(match[1]) : null;
}

function byDisplayOrder(left, right) {
  const leftNumber = getItemNumber(left.title);
  const rightNumber = getItemNumber(right.title);
  if (leftNumber !== null && rightNumber !== null && leftNumber !== rightNumber) {
    return leftNumber - rightNumber;
  }

  const byOrderIndex =
    (left.orderIndex ?? Number.MAX_SAFE_INTEGER) -
    (right.orderIndex ?? Number.MAX_SAFE_INTEGER);
  if (byOrderIndex !== 0) return byOrderIndex;

  return (left.createdAt || '').localeCompare(right.createdAt || '');
}

function normalizeChapters(chapters) {
  return [...chapters]
    .sort(byDisplayOrder)
    .map((chapter) => ({
      ...chapter,
      lessons: [...(chapter.lessons || [])].sort(byDisplayOrder),
    }));
}

function getNextOrderIndex(items) {
  const maxOrderIndex = items.reduce(
    (max, item) => Math.max(max, Number(item.orderIndex) || 0),
    0,
  );
  return maxOrderIndex + 1;
}

function LessonTypePreview({ type }) {
  if (type === 'EXERCISE') {
    return (
      <div className="lesson-type-preview exercise">
        <strong>Giao diện thêm bài tập</strong>
        <p>Bài học tạo ra sẽ hiển thị là EXERCISE trên mobile và mở màn luyện tập.</p>
        <ul>
          <li>Nhập tên bài tập ở ô tiêu đề.</li>
          <li>Không cần upload video/PDF cho bài tập.</li>
          <li>Câu hỏi hiện đang dùng bộ quiz trong app mobile.</li>
        </ul>
      </div>
    );
  }

  if (type === 'FLASHCARD') {
    return (
      <div className="lesson-type-preview flashcard">
        <strong>Giao diện thêm flashcard</strong>
        <p>Bài học tạo ra sẽ hiển thị là FLASHCARD trên mobile và mở màn ôn thẻ.</p>
        <ul>
          <li>Nhập tên bộ flashcard ở ô tiêu đề.</li>
          <li>Không cần upload video/PDF cho flashcard.</li>
          <li>Nội dung thẻ hiện đang dùng bộ flashcard trong app mobile.</li>
        </ul>
      </div>
    );
  }

  return (
    <div className="lesson-type-preview video">
      <strong>Giao diện thêm video</strong>
      <p>Tạo bài học video, sau đó dùng khối Video bài học và Upload PDF bên dưới nếu cần.</p>
    </div>
  );
}

function moveItem(items, index, direction) {
  const nextIndex = index + direction;
  if (nextIndex < 0 || nextIndex >= items.length) return items;
  const nextItems = [...items];
  [nextItems[index], nextItems[nextIndex]] = [nextItems[nextIndex], nextItems[index]];
  return nextItems;
}

export default function LearningContentPage() {
  const [courses, setCourses] = useState([]);
  const [courseId, setCourseId] = useState('');
  const [chapters, setChapters] = useState([]);
  const [chapterTitle, setChapterTitle] = useState('');
  const [lessonForm, setLessonForm] = useState({
    chapterId: '',
    type: 'VIDEO',
    title: '',
    isPreview: false,
  });
  const [uploadLessonId, setUploadLessonId] = useState('');
  const [uploadFile, setUploadFile] = useState(null);
  const [videoLessonId, setVideoLessonId] = useState('');
  const [videoUrl, setVideoUrl] = useState('');
  const [loading, setLoading] = useState(true);
  const [contentLoading, setContentLoading] = useState(false);
  const [error, setError] = useState('');

  const selectedCourse = useMemo(
    () => courses.find((course) => course.id === courseId),
    [courses, courseId],
  );
  const selectedLessonType = LESSON_TYPES[lessonForm.type] || LESSON_TYPES.VIDEO;

  async function loadCourses() {
    setLoading(true);
    setError('');
    try {
      const data = await coursesApi.getCourses({
        page: 0,
        size: 100,
        status: 'ACTIVE',
      });
      const list = data.content || [];
      setCourses(list);
      if (!courseId && list.length > 0) setCourseId(list[0].id);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  async function loadContent(id = courseId) {
    if (!id) {
      setChapters([]);
      return;
    }
    setContentLoading(true);
    setError('');
    try {
      const chapterList = await chaptersApi.getChaptersByCourse(id, {
        status: 'ACTIVE',
      });
      setChapters(normalizeChapters(Array.isArray(chapterList) ? chapterList : []));
    } catch (err) {
      setError(err.message);
    } finally {
      setContentLoading(false);
    }
  }

  useEffect(() => {
    loadCourses();
  }, []);

  useEffect(() => {
    loadContent(courseId);
    setLessonForm({ chapterId: '', type: 'VIDEO', title: '', isPreview: false });
  }, [courseId]);

  async function addChapter(e) {
    e.preventDefault();
    if (!courseId) return;
    setError('');
    try {
      await chaptersApi.createChapter({
        courseId,
        title: chapterTitle,
        orderIndex: getNextOrderIndex(chapters),
      });
      setChapterTitle('');
      await loadContent();
    } catch (err) {
      setError(err.message);
    }
  }

  async function deleteChapter(chapterId) {
    if (!confirm('Xóa chương này?')) return;
    setError('');
    try {
      await chaptersApi.deleteChapter(chapterId);
      await loadContent();
    } catch (err) {
      setError(err.message);
    }
  }

  async function moveChapter(chapterIndex, direction) {
    const nextChapters = moveItem(chapters, chapterIndex, direction);
    if (nextChapters === chapters || !courseId) return;
    setError('');
    try {
      await chaptersApi.reorderChapters(courseId, nextChapters.map((chapter) => chapter.id));
      await loadContent();
    } catch (err) {
      setError(err.message);
    }
  }

  async function moveLesson(chapter, lessonIndex, direction) {
    const lessons = chapter.lessons || [];
    const nextLessons = moveItem(lessons, lessonIndex, direction);
    if (nextLessons === lessons) return;
    setError('');
    try {
      await lessonsApi.reorderLessons(chapter.id, nextLessons.map((lesson) => lesson.id));
      await loadContent();
    } catch (err) {
      setError(err.message);
    }
  }

  async function addLesson(e) {
    e.preventDefault();
    if (!lessonForm.chapterId) return;
    setError('');
    try {
      await lessonsApi.createLesson({
        chapterId: lessonForm.chapterId,
        title: getTypedLessonTitle(lessonForm.type, lessonForm.title),
        isPreview: lessonForm.isPreview,
      });
      setLessonForm({ chapterId: '', type: 'VIDEO', title: '', isPreview: false });
      await loadContent();
    } catch (err) {
      setError(err.message);
    }
  }

  async function deleteLesson(lessonId) {
    if (!confirm('Xóa bài học này?')) return;
    setError('');
    try {
      await lessonsApi.deleteLesson(lessonId);
      await loadContent();
    } catch (err) {
      setError(err.message);
    }
  }

  async function handleUpload(e) {
    e.preventDefault();
    if (!uploadLessonId || !uploadFile) return;
    setError('');
    try {
      await lessonsApi.uploadLessonMedia(uploadLessonId, uploadFile, 'PDF');
      setUploadLessonId('');
      setUploadFile(null);
      e.target.reset();
      await loadContent();
    } catch (err) {
      setError(err.message);
    }
  }

  async function handleVideoUrlSubmit(e) {
    e.preventDefault();
    if (!videoLessonId || !videoUrl.trim()) return;
    setError('');
    try {
      await lessonsApi.updateLessonVideoUrl(videoLessonId, videoUrl.trim());
      setVideoLessonId('');
      setVideoUrl('');
      await loadContent();
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <div>
      <PageHeader
        title="Nội dung học"
        subtitle="Quản lý chương, bài học và media"
      />
      {error && <Alert>{error}</Alert>}

      <section className="panel">
        <h2>Khóa học</h2>
        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : (
          <label className="field-label">
            Chọn khóa học
            <select
              value={courseId}
              onChange={(e) => setCourseId(e.target.value)}
            >
              {courses.map((course) => (
                <option key={course.id} value={course.id}>
                  {course.title}
                </option>
              ))}
            </select>
          </label>
        )}
        {selectedCourse && (
          <p className="muted">
            {selectedCourse.subject || 'Không có chủ đề'} - {selectedCourse.id}
          </p>
        )}
      </section>

      <section className="panel">
        <h2>Thêm chương</h2>
        <form className="inline-form" onSubmit={addChapter}>
          <input
            value={chapterTitle}
            onChange={(e) => setChapterTitle(e.target.value)}
            placeholder="Tên chương"
            required
          />
          <button type="submit" className="btn btn-primary btn-sm">
            <Plus size={14} /> Thêm
          </button>
        </form>
      </section>

      <section className="panel">
        <h2>Thêm bài học</h2>
        <form className="form-grid" onSubmit={addLesson}>
          <label>
            Chương
            <select
              value={lessonForm.chapterId}
              onChange={(e) =>
                setLessonForm({ ...lessonForm, chapterId: e.target.value })
              }
              required
            >
              <option value="">-- Chọn chương --</option>
              {chapters.map((chapter) => (
                <option key={chapter.id} value={chapter.id}>
                  {chapter.title}
                </option>
              ))}
            </select>
          </label>
          <label>
            {selectedLessonType.titleLabel}
            <input
              value={lessonForm.title}
              onChange={(e) =>
                setLessonForm({ ...lessonForm, title: e.target.value })
              }
              placeholder={selectedLessonType.placeholder}
              required
            />
          </label>
          <label>
            Loại bài học
            <select
              value={lessonForm.type}
              onChange={(e) =>
                setLessonForm({ ...lessonForm, type: e.target.value })
              }
              required
            >
              {Object.entries(LESSON_TYPES).map(([value, config]) => (
                <option key={value} value={value}>
                  {config.label}
                </option>
              ))}
            </select>
          </label>
          <div className="span-2">
            <LessonTypePreview type={lessonForm.type} />
          </div>
          <label className="checkbox-label">
            <input
              type="checkbox"
              checked={lessonForm.isPreview}
              onChange={(e) =>
                setLessonForm({ ...lessonForm, isPreview: e.target.checked })
              }
            />
            Cho phép học thử
          </label>
          <div className="form-actions span-2">
            <button type="submit" className="btn btn-primary btn-sm">
              {selectedLessonType.submitLabel}
            </button>
          </div>
        </form>
      </section>

      <section className="panel">
        <h2>Video bài học</h2>
        <form className="form-grid" onSubmit={handleVideoUrlSubmit}>
          <label>
            Lesson ID
            <input
              value={videoLessonId}
              onChange={(e) => setVideoLessonId(e.target.value)}
              placeholder="UUID bài học"
              required
            />
          </label>
          <label>
            Link YouTube
            <input
              value={videoUrl}
              onChange={(e) => setVideoUrl(e.target.value)}
              placeholder="https://www.youtube.com/watch?v=..."
              required
            />
          </label>
          <div className="form-actions span-2">
            <button type="submit" className="btn btn-primary btn-sm">
              Lưu link video
            </button>
          </div>
        </form>
      </section>

      <section className="panel">
        <h2>Upload PDF bài học</h2>
        <form className="form-grid" onSubmit={handleUpload}>
          <label>
            Lesson ID
            <input
              value={uploadLessonId}
              onChange={(e) => setUploadLessonId(e.target.value)}
              placeholder="UUID bài học"
              required
            />
          </label>
          <label>
            File PDF
            <input
              type="file"
              accept="application/pdf"
              onChange={(e) => setUploadFile(e.target.files?.[0] || null)}
              required
            />
          </label>
          <div className="form-actions span-2">
            <button type="submit" className="btn btn-primary btn-sm">
              <FileUp size={14} /> Upload PDF
            </button>
          </div>
        </form>
      </section>

      <section className="panel">
        <h2>Danh sách nội dung</h2>
        {contentLoading ? (
          <p className="muted">Đang tải...</p>
        ) : chapters.length === 0 ? (
          <p className="muted">Chưa có chương</p>
        ) : (
          chapters.map((chapter, chapterIndex) => (
            <div key={chapter.id} className="content-group">
              <div className="panel-head">
                <div>
                  <h3>{chapter.title}</h3>
                  <p className="muted">Chapter ID: {chapter.id}</p>
                </div>
                <div className="row-actions">
                  <button
                    type="button"
                    className="btn-icon"
                    onClick={() => moveChapter(chapterIndex, -1)}
                    disabled={chapterIndex === 0}
                    title="Chuyển chương lên"
                  >
                    <ArrowUp size={16} />
                  </button>
                  <button
                    type="button"
                    className="btn-icon"
                    onClick={() => moveChapter(chapterIndex, 1)}
                    disabled={chapterIndex === chapters.length - 1}
                    title="Chuyển chương xuống"
                  >
                    <ArrowDown size={16} />
                  </button>
                  <button
                    type="button"
                    className="btn-icon danger"
                    onClick={() => deleteChapter(chapter.id)}
                    title="Xóa chương"
                  >
                    <Trash2 size={16} />
                  </button>
                </div>
              </div>
              {(chapter.lessons || []).length === 0 ? (
                <p className="muted">Chưa có bài học</p>
              ) : (
                <ul className="lesson-list">
                  {chapter.lessons.map((lesson, lessonIndex) => (
                    <li key={lesson.id}>
                      <span>{lesson.title}</span>
                      <span className="status-pill neutral">
                        {LESSON_TYPES[getLessonType(lesson.title)].label}
                      </span>
                      <span className="muted">
                        {lesson.id}
                        {lesson.isPreview ? ' - Preview' : ''}
                      </span>
                      <div className="row-actions">
                        <button
                          type="button"
                          className="btn-icon"
                          onClick={() => moveLesson(chapter, lessonIndex, -1)}
                          disabled={lessonIndex === 0}
                          title="Chuyển bài học lên"
                        >
                          <ArrowUp size={14} />
                        </button>
                        <button
                          type="button"
                          className="btn-icon"
                          onClick={() => moveLesson(chapter, lessonIndex, 1)}
                          disabled={lessonIndex === chapter.lessons.length - 1}
                          title="Chuyển bài học xuống"
                        >
                          <ArrowDown size={14} />
                        </button>
                        <button
                          type="button"
                          className="btn-icon danger"
                          onClick={() => deleteLesson(lesson.id)}
                          title="Xóa bài học"
                        >
                          <Trash2 size={14} />
                        </button>
                      </div>
                    </li>
                  ))}
                </ul>
              )}
            </div>
          ))
        )}
      </section>
    </div>
  );
}
