import { useEffect, useMemo, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import {
  ArrowDown,
  ArrowLeft,
  ArrowUp,
  ExternalLink,
  FileText,
  FileUp,
  PlayCircle,
  Plus,
  Trash2,
} from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import { API_BASE_URL } from '../api/config.js';
import * as coursesApi from '../api/courses.js';
import * as chaptersApi from '../api/chapters.js';
import * as lessonsApi from '../api/lessons.js';

function byOrderIndex(left, right) {
  const leftOrder = Number(left.orderIndex ?? Number.MAX_SAFE_INTEGER);
  const rightOrder = Number(right.orderIndex ?? Number.MAX_SAFE_INTEGER);
  if (leftOrder !== rightOrder) return leftOrder - rightOrder;
  return String(left.id || left.title || '').localeCompare(String(right.id || right.title || ''));
}

function normalizeChapters(chapters) {
  return [...chapters]
    .sort(byOrderIndex)
    .map((chapter) => ({
      ...chapter,
      lessons: [...(chapter.lessons || [])].sort(byOrderIndex),
    }));
}

function getFileUrl(path) {
  if (!path) return '';
  if (path.startsWith('http')) return path;
  const apiRoot = API_BASE_URL.replace(/\/api\/v1\/?$/, '');
  return `${apiRoot}/uploads/${path.replace(/^\/+/, '')}`;
}

function moveItem(items, index, direction) {
  const nextIndex = index + direction;
  if (nextIndex < 0 || nextIndex >= items.length) return items;
  const nextItems = [...items];
  [nextItems[index], nextItems[nextIndex]] = [nextItems[nextIndex], nextItems[index]];
  return nextItems;
}

export default function CourseDetailPage() {
  const { id } = useParams();
  const [course, setCourse] = useState(null);
  const [chapters, setChapters] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  const [chapterTitle, setChapterTitle] = useState('');
  const [lessonForm, setLessonForm] = useState({
    chapterId: '',
    title: '',
    isPreview: false,
  });
  const [uploadChapterId, setUploadChapterId] = useState('');
  const [uploadLessonId, setUploadLessonId] = useState('');
  const [uploadFile, setUploadFile] = useState(null);
  const [videoChapterId, setVideoChapterId] = useState('');
  const [videoLessonId, setVideoLessonId] = useState('');
  const [videoUrl, setVideoUrl] = useState('');

  const uploadChapter = useMemo(
    () => chapters.find((chapter) => chapter.id === uploadChapterId),
    [chapters, uploadChapterId],
  );
  const uploadLessons = uploadChapter?.lessons || [];
  const videoChapter = useMemo(
    () => chapters.find((chapter) => chapter.id === videoChapterId),
    [chapters, videoChapterId],
  );
  const videoLessons = videoChapter?.lessons || [];

  async function load() {
    setLoading(true);
    setError('');
    try {
      const [detail, chapterList] = await Promise.all([
        coursesApi.getCourseDetail(id),
        chaptersApi.getChaptersByCourse(id, { status: 'ACTIVE' }),
      ]);
      setCourse(detail);
      const nextChapters = normalizeChapters(
        Array.isArray(chapterList) ? chapterList : detail.chapters || [],
      );
      setChapters(nextChapters);
      if (uploadChapterId && !nextChapters.some((chapter) => chapter.id === uploadChapterId)) {
        setUploadChapterId('');
        setUploadLessonId('');
      }
      if (videoChapterId && !nextChapters.some((chapter) => chapter.id === videoChapterId)) {
        setVideoChapterId('');
        setVideoLessonId('');
      }
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
  }, [id]);

  async function addChapter(e) {
    e.preventDefault();
    try {
      await chaptersApi.createChapter({
        courseId: id,
        title: chapterTitle,
      });
      setChapterTitle('');
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  async function deleteChapter(chapterId) {
    if (!confirm('Xóa chương này?')) return;
    try {
      await chaptersApi.deleteChapter(chapterId);
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  async function moveChapter(chapterIndex, direction) {
    const nextChapters = moveItem(chapters, chapterIndex, direction);
    if (nextChapters === chapters) return;
    try {
      await chaptersApi.reorderChapters(id, nextChapters.map((chapter) => chapter.id));
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  async function moveLesson(chapter, lessonIndex, direction) {
    const lessons = chapter.lessons || [];
    const nextLessons = moveItem(lessons, lessonIndex, direction);
    if (nextLessons === lessons) return;
    try {
      await lessonsApi.reorderLessons(chapter.id, nextLessons.map((lesson) => lesson.id));
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  async function addLesson(e) {
    e.preventDefault();
    if (!lessonForm.chapterId) return;
    try {
      await lessonsApi.createLesson({
        chapterId: lessonForm.chapterId,
        title: lessonForm.title,
        isPreview: lessonForm.isPreview,
      });
      setLessonForm({ chapterId: '', title: '', isPreview: false });
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  async function deleteLesson(lessonId) {
    if (!confirm('Xóa bài học này?')) return;
    try {
      await lessonsApi.deleteLesson(lessonId);
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  async function handleUpload(e) {
    e.preventDefault();
    if (!uploadLessonId || !uploadFile) return;
    try {
      await lessonsApi.uploadLessonMedia(uploadLessonId, uploadFile, 'PDF');
      setUploadFile(null);
      setUploadChapterId('');
      setUploadLessonId('');
      e.target.reset();
      await load();
      alert('Upload thành công');
    } catch (err) {
      setError(err.message);
    }
  }

  async function handleVideoUrlSubmit(e) {
    e.preventDefault();
    if (!videoLessonId || !videoUrl.trim()) return;
    try {
      await lessonsApi.updateLessonVideoUrl(videoLessonId, videoUrl.trim());
      setVideoChapterId('');
      setVideoLessonId('');
      setVideoUrl('');
      await load();
      alert('Cập nhật link video thành công');
    } catch (err) {
      setError(err.message);
    }
  }

  if (loading) return <p className="muted">Đang tải...</p>;
  if (!course) return <Alert>Không tìm thấy khóa học</Alert>;

  return (
    <div>
      <Link to="/courses" className="back-link">
        <ArrowLeft size={16} /> Danh sách khóa học
      </Link>
      <PageHeader
        title={course.title}
        subtitle={course.subject}
        action={
          <Link to={`/courses/${id}`} className="btn btn-ghost">
            Xem khóa học
          </Link>
        }
      />
      {error && <Alert>{error}</Alert>}

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

      {chapters.map((ch, chapterIndex) => (
        <section key={ch.id} className="panel">
          <div className="panel-head">
            <div>
              <h2>{ch.title}</h2>
              {ch.isDeleted && <span className="status-pill danger">Chương đã xóa</span>}
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
                onClick={() => deleteChapter(ch.id)}
              >
                <Trash2 size={16} />
              </button>
            </div>
          </div>
          <ul className="lesson-list">
            {(ch.lessons || []).map((ls, lessonIndex) => (
              <li key={ls.id}>
                <span>{ls.title}</span>
                <span className={`status-pill ${ls.isPreview ? 'success' : 'warning'}`}>
                  {ls.isPreview ? 'Cho phép học thử' : 'Không học thử'}
                </span>
                <span className={`status-pill ${ls.isDeleted ? 'danger' : 'success'}`}>
                  {ls.isDeleted ? 'Đã xóa' : 'Đang hoạt động'}
                </span>
                <div className="lesson-media-links">
                  {ls.videoUrl ? (
                    <a
                      href={getFileUrl(ls.videoUrl)}
                      target="_blank"
                      rel="noreferrer"
                      className="media-link"
                    >
                      <PlayCircle size={14} /> Video <ExternalLink size={12} />
                    </a>
                  ) : (
                    <span className="status-pill warning">Thiếu video</span>
                  )}
                  {ls.pdfUrl ? (
                    <a
                      href={getFileUrl(ls.pdfUrl)}
                      target="_blank"
                      rel="noreferrer"
                      className="media-link"
                    >
                      <FileText size={14} /> PDF <ExternalLink size={12} />
                    </a>
                  ) : (
                    <span className="status-pill warning">Thiếu PDF</span>
                  )}
                </div>
                <div className="row-actions">
                  <button
                    type="button"
                    className="btn-icon"
                    onClick={() => moveLesson(ch, lessonIndex, -1)}
                    disabled={lessonIndex === 0}
                    title="Chuyển bài học lên"
                  >
                    <ArrowUp size={14} />
                  </button>
                  <button
                    type="button"
                    className="btn-icon"
                    onClick={() => moveLesson(ch, lessonIndex, 1)}
                    disabled={lessonIndex === (ch.lessons || []).length - 1}
                    title="Chuyển bài học xuống"
                  >
                    <ArrowDown size={14} />
                  </button>
                  <button
                    type="button"
                    className="btn-icon danger"
                    onClick={() => deleteLesson(ls.id)}
                  >
                    <Trash2 size={14} />
                  </button>
                </div>
              </li>
            ))}
          </ul>
        </section>
      ))}

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
              {chapters.map((ch) => (
                <option key={ch.id} value={ch.id}>
                  {ch.title}
                </option>
              ))}
            </select>
          </label>
          <label>
            Tiêu đề bài
            <input
              value={lessonForm.title}
              onChange={(e) =>
                setLessonForm({ ...lessonForm, title: e.target.value })
              }
              required
            />
          </label>
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
              Tạo bài học
            </button>
          </div>
        </form>
      </section>

      <section className="panel">
        <h2>Video bài học</h2>
        <form className="form-grid" onSubmit={handleVideoUrlSubmit}>
          <label>
            Chương
            <select
              value={videoChapterId}
              onChange={(e) => {
                setVideoChapterId(e.target.value);
                setVideoLessonId('');
              }}
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
            Bài học
            <select
              value={videoLessonId}
              onChange={(e) => setVideoLessonId(e.target.value)}
              required
              disabled={!videoChapterId || videoLessons.length === 0}
            >
              <option value="">
                {videoChapterId && videoLessons.length === 0
                  ? '-- Chương chưa có bài học --'
                  : '-- Chọn bài học --'}
              </option>
              {videoLessons.map((lesson) => (
                <option key={lesson.id} value={lesson.id}>
                  {lesson.title}
                </option>
              ))}
            </select>
          </label>
          <label className="span-2">
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
            Chương
            <select
              value={uploadChapterId}
              onChange={(e) => {
                setUploadChapterId(e.target.value);
                setUploadLessonId('');
              }}
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
            Bài học
            <select
              value={uploadLessonId}
              onChange={(e) => setUploadLessonId(e.target.value)}
              required
              disabled={!uploadChapterId || uploadLessons.length === 0}
            >
              <option value="">
                {uploadChapterId && uploadLessons.length === 0
                  ? '-- Chương chưa có bài học --'
                  : '-- Chọn bài học --'}
              </option>
              {uploadLessons.map((lesson) => (
                <option key={lesson.id} value={lesson.id}>
                  {lesson.title}{lesson.isDeleted ? ' (Đã xóa)' : ''}
                </option>
              ))}
            </select>
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
    </div>
  );
}
