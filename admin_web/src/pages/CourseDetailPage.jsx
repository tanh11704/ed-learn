import { useEffect, useMemo, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { ArrowLeft, ExternalLink, FileText, FileUp, PlayCircle, Plus, Trash2 } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import { API_BASE_URL } from '../api/config.js';
import * as coursesApi from '../api/courses.js';
import * as chaptersApi from '../api/chapters.js';
import * as lessonsApi from '../api/lessons.js';

function byOrderIndex(left, right) {
  return (left.orderIndex ?? Number.MAX_SAFE_INTEGER) - (right.orderIndex ?? Number.MAX_SAFE_INTEGER);
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

  const uploadChapter = useMemo(
    () => chapters.find((chapter) => chapter.id === uploadChapterId),
    [chapters, uploadChapterId],
  );
  const uploadLessons = uploadChapter?.lessons || [];

  async function load() {
    setLoading(true);
    setError('');
    try {
      const [detail, chapterList] = await Promise.all([
        coursesApi.getCourseDetail(id),
        chaptersApi.getChaptersByCourse(id),
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
        orderIndex: chapters.length,
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
      const type = uploadFile.type.includes('pdf') ? 'PDF' : 'VIDEO';
      await lessonsApi.uploadLessonMedia(uploadLessonId, uploadFile, type);
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

      {chapters.map((ch) => (
        <section key={ch.id} className="panel">
          <div className="panel-head">
            <div>
              <h2>{ch.title}</h2>
              {ch.isDeleted && <span className="status-pill danger">Chương đã xóa</span>}
            </div>
            <button
              type="button"
              className="btn-icon danger"
              onClick={() => deleteChapter(ch.id)}
            >
              <Trash2 size={16} />
            </button>
          </div>
          <ul className="lesson-list">
            {(ch.lessons || []).map((ls) => (
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
                <button
                  type="button"
                  className="btn-icon danger"
                  onClick={() => deleteLesson(ls.id)}
                >
                  <Trash2 size={14} />
                </button>
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
        <h2>Upload media bài học</h2>
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
            File (VIDEO / PDF)
            <input
              type="file"
              accept="video/*,application/pdf"
              onChange={(e) => setUploadFile(e.target.files?.[0] || null)}
              required
            />
          </label>
          <div className="form-actions span-2">
            <button type="submit" className="btn btn-primary btn-sm">
              <FileUp size={14} /> Upload
            </button>
          </div>
        </form>
      </section>
    </div>
  );
}
