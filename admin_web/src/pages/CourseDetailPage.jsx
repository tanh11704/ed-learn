import { useEffect, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { ArrowLeft, Plus, Trash2 } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as coursesApi from '../api/courses.js';
import * as chaptersApi from '../api/chapters.js';
import * as lessonsApi from '../api/lessons.js';

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
  const [uploadLessonId, setUploadLessonId] = useState('');
  const [uploadFile, setUploadFile] = useState(null);

  async function load() {
    setLoading(true);
    setError('');
    try {
      const [detail, chapterList] = await Promise.all([
        coursesApi.getCourseDetail(id),
        chaptersApi.getChaptersByCourse(id),
      ]);
      setCourse(detail);
      setChapters(Array.isArray(chapterList) ? chapterList : detail.chapters || []);
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
      setUploadLessonId('');
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
            <h2>{ch.title}</h2>
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
                <span className="muted">
                  {ls.isPreview ? 'Preview' : ''}{' '}
                  {ls.videoUrl ? '• Video' : ''}{' '}
                  {ls.pdfUrl ? '• PDF' : ''}
                </span>
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
            Lesson ID
            <input
              value={uploadLessonId}
              onChange={(e) => setUploadLessonId(e.target.value)}
              placeholder="UUID bài học"
              required
            />
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
              Upload
            </button>
          </div>
        </form>
      </section>
    </div>
  );
}
