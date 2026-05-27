import { useEffect, useMemo, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { ArrowLeft, ExternalLink, FileText, FileUp, PlayCircle, Plus, Trash2 } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import { API_BASE_URL } from '../api/config.js';
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

function getFileUrl(path) {
  if (!path) return '';
  if (path.startsWith('http')) return path;
  const apiRoot = API_BASE_URL.replace(/\/api\/v1\/?$/, '');
  return `${apiRoot}/uploads/${path.replace(/^\/+/, '')}`;
}

function readLessonAdminData(courseId, type) {
  try {
    return JSON.parse(localStorage.getItem(`lesson-${type}-${courseId}`) || '[]');
  } catch {
    return [];
  }
}

function writeLessonAdminData(courseId, type, items) {
  localStorage.setItem(`lesson-${type}-${courseId}`, JSON.stringify(items));
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
    type: 'VIDEO',
    title: '',
    isPreview: false,
  });
  const [uploadChapterId, setUploadChapterId] = useState('');
  const [uploadLessonId, setUploadLessonId] = useState('');
  const [uploadFile, setUploadFile] = useState(null);
  const [videoChapterId, setVideoChapterId] = useState('');
  const [videoLessonId, setVideoLessonId] = useState('');
  const [videoUrl, setVideoUrl] = useState('');
  const [flashcardChapterId, setFlashcardChapterId] = useState('');
  const [flashcardLessonId, setFlashcardLessonId] = useState('');
  const [flashcardForm, setFlashcardForm] = useState({
    front: '',
    back: '',
    explanation: '',
  });
  const [flashcards, setFlashcards] = useState(() => readLessonAdminData(id, 'flashcards'));
  const [exerciseChapterId, setExerciseChapterId] = useState('');
  const [exerciseLessonId, setExerciseLessonId] = useState('');
  const [exerciseForm, setExerciseForm] = useState({
    question: '',
    optionA: '',
    optionB: '',
    optionC: '',
    optionD: '',
    correctOption: 'A',
    explanation: '',
  });
  const [exercises, setExercises] = useState(() => readLessonAdminData(id, 'exercises'));

  const uploadChapter = useMemo(
    () => chapters.find((chapter) => chapter.id === uploadChapterId),
    [chapters, uploadChapterId],
  );
  const uploadLessons = (uploadChapter?.lessons || []).filter(
    (lesson) => getLessonType(lesson.title) === 'VIDEO',
  );
  const videoChapter = useMemo(
    () => chapters.find((chapter) => chapter.id === videoChapterId),
    [chapters, videoChapterId],
  );
  const videoLessons = (videoChapter?.lessons || []).filter(
    (lesson) => getLessonType(lesson.title) === 'VIDEO',
  );
  const flashcardChapter = useMemo(
    () => chapters.find((chapter) => chapter.id === flashcardChapterId),
    [chapters, flashcardChapterId],
  );
  const flashcardLessons = (flashcardChapter?.lessons || []).filter(
    (lesson) => getLessonType(lesson.title) === 'FLASHCARD',
  );
  const exerciseChapter = useMemo(
    () => chapters.find((chapter) => chapter.id === exerciseChapterId),
    [chapters, exerciseChapterId],
  );
  const exerciseLessons = (exerciseChapter?.lessons || []).filter(
    (lesson) => getLessonType(lesson.title) === 'EXERCISE',
  );
  const selectedLessonType = LESSON_TYPES[lessonForm.type] || LESSON_TYPES.VIDEO;

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
      if (flashcardChapterId && !nextChapters.some((chapter) => chapter.id === flashcardChapterId)) {
        setFlashcardChapterId('');
        setFlashcardLessonId('');
      }
      if (exerciseChapterId && !nextChapters.some((chapter) => chapter.id === exerciseChapterId)) {
        setExerciseChapterId('');
        setExerciseLessonId('');
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
        orderIndex: getNextOrderIndex(chapters),
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
        title: getTypedLessonTitle(lessonForm.type, lessonForm.title),
        isPreview: lessonForm.isPreview,
      });
      setLessonForm({ chapterId: '', type: 'VIDEO', title: '', isPreview: false });
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

  function handleFlashcardSubmit(e) {
    e.preventDefault();
    if (!flashcardLessonId || !flashcardForm.front.trim() || !flashcardForm.back.trim()) return;

    const lesson = flashcardLessons.find((item) => item.id === flashcardLessonId);
    const nextFlashcards = [
      ...flashcards,
      {
        id: crypto.randomUUID(),
        lessonId: flashcardLessonId,
        lessonTitle: lesson?.title || '',
        front: flashcardForm.front.trim(),
        back: flashcardForm.back.trim(),
        explanation: flashcardForm.explanation.trim(),
      },
    ];
    // TODO: Replace this local draft save with the flashcard API call.
    setFlashcards(nextFlashcards);
    writeLessonAdminData(id, 'flashcards', nextFlashcards);
    setFlashcardForm({ front: '', back: '', explanation: '' });
  }

  function handleExerciseSubmit(e) {
    e.preventDefault();
    if (
      !exerciseLessonId ||
      !exerciseForm.question.trim() ||
      !exerciseForm.optionA.trim() ||
      !exerciseForm.optionB.trim() ||
      !exerciseForm.optionC.trim() ||
      !exerciseForm.optionD.trim()
    ) {
      return;
    }

    const lesson = exerciseLessons.find((item) => item.id === exerciseLessonId);
    const nextExercises = [
      ...exercises,
      {
        id: crypto.randomUUID(),
        lessonId: exerciseLessonId,
        lessonTitle: lesson?.title || '',
        question: exerciseForm.question.trim(),
        options: [
          { key: 'A', content: exerciseForm.optionA.trim() },
          { key: 'B', content: exerciseForm.optionB.trim() },
          { key: 'C', content: exerciseForm.optionC.trim() },
          { key: 'D', content: exerciseForm.optionD.trim() },
        ],
        correctOption: exerciseForm.correctOption,
        explanation: exerciseForm.explanation.trim(),
      },
    ];
    // TODO: Replace this local draft save with the exercise API call.
    setExercises(nextExercises);
    writeLessonAdminData(id, 'exercises', nextExercises);
    setExerciseForm({
      question: '',
      optionA: '',
      optionB: '',
      optionC: '',
      optionD: '',
      correctOption: 'A',
      explanation: '',
    });
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
                <span className="status-pill neutral">
                  {LESSON_TYPES[getLessonType(ls.title)].label}
                </span>
                <span className={`status-pill ${ls.isPreview ? 'success' : 'warning'}`}>
                  {ls.isPreview ? 'Cho phép học thử' : 'Không học thử'}
                </span>
                <span className={`status-pill ${ls.isDeleted ? 'danger' : 'success'}`}>
                  {ls.isDeleted ? 'Đã xóa' : 'Đang hoạt động'}
                </span>
                <div className="lesson-media-links">
                  {getLessonType(ls.title) !== 'VIDEO' ? (
                    <span className="status-pill neutral">Không cần video</span>
                  ) : ls.videoUrl ? (
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
                  {getLessonType(ls.title) !== 'VIDEO' ? (
                    <span className="status-pill neutral">Không cần PDF</span>
                  ) : ls.pdfUrl ? (
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
        <h2>Flashcard bài học</h2>
        <form className="form-grid" onSubmit={handleFlashcardSubmit}>
          <label>
            Chương
            <select
              value={flashcardChapterId}
              onChange={(e) => {
                setFlashcardChapterId(e.target.value);
                setFlashcardLessonId('');
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
            Bài học flashcard
            <select
              value={flashcardLessonId}
              onChange={(e) => setFlashcardLessonId(e.target.value)}
              required
              disabled={!flashcardChapterId || flashcardLessons.length === 0}
            >
              <option value="">
                {flashcardChapterId && flashcardLessons.length === 0
                  ? '-- Chương chưa có bài flashcard --'
                  : '-- Chọn bài flashcard --'}
              </option>
              {flashcardLessons.map((lesson) => (
                <option key={lesson.id} value={lesson.id}>
                  {lesson.title}
                </option>
              ))}
            </select>
          </label>
          <label>
            Mặt trước
            <input
              value={flashcardForm.front}
              onChange={(e) =>
                setFlashcardForm({ ...flashcardForm, front: e.target.value })
              }
              placeholder="Ví dụ: Đạo hàm là gì?"
              required
            />
          </label>
          <label>
            Mặt sau
            <input
              value={flashcardForm.back}
              onChange={(e) =>
                setFlashcardForm({ ...flashcardForm, back: e.target.value })
              }
              placeholder="Ví dụ: Tốc độ biến thiên tức thời của hàm số"
              required
            />
          </label>
          <label className="span-2">
            Giải thích thêm
            <textarea
              value={flashcardForm.explanation}
              onChange={(e) =>
                setFlashcardForm({ ...flashcardForm, explanation: e.target.value })
              }
              placeholder="Ghi chú hoặc ví dụ minh họa"
              rows={3}
            />
          </label>
          <div className="form-actions span-2">
            <button type="submit" className="btn btn-primary btn-sm">
              Lưu flashcard
            </button>
          </div>
        </form>
        {flashcards.length > 0 && (
          <ul className="admin-data-list">
            {flashcards.map((item) => (
              <li key={item.id}>
                <strong>{item.lessonTitle}</strong>
                <span>{item.front} → {item.back}</span>
              </li>
            ))}
          </ul>
        )}
      </section>

      <section className="panel">
        <h2>Exercise bài học</h2>
        <form className="form-grid" onSubmit={handleExerciseSubmit}>
          <label>
            Chương
            <select
              value={exerciseChapterId}
              onChange={(e) => {
                setExerciseChapterId(e.target.value);
                setExerciseLessonId('');
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
            Bài học exercise
            <select
              value={exerciseLessonId}
              onChange={(e) => setExerciseLessonId(e.target.value)}
              required
              disabled={!exerciseChapterId || exerciseLessons.length === 0}
            >
              <option value="">
                {exerciseChapterId && exerciseLessons.length === 0
                  ? '-- Chương chưa có bài exercise --'
                  : '-- Chọn bài exercise --'}
              </option>
              {exerciseLessons.map((lesson) => (
                <option key={lesson.id} value={lesson.id}>
                  {lesson.title}
                </option>
              ))}
            </select>
          </label>
          <label className="span-2">
            Câu hỏi
            <textarea
              value={exerciseForm.question}
              onChange={(e) =>
                setExerciseForm({ ...exerciseForm, question: e.target.value })
              }
              placeholder="Nhập nội dung câu hỏi bài tập"
              rows={3}
              required
            />
          </label>
          <label>
            Lựa chọn A
            <input
              value={exerciseForm.optionA}
              onChange={(e) =>
                setExerciseForm({ ...exerciseForm, optionA: e.target.value })
              }
              placeholder="Nhập lựa chọn A"
              required
            />
          </label>
          <label>
            Lựa chọn B
            <input
              value={exerciseForm.optionB}
              onChange={(e) =>
                setExerciseForm({ ...exerciseForm, optionB: e.target.value })
              }
              placeholder="Nhập lựa chọn B"
              required
            />
          </label>
          <label>
            Lựa chọn C
            <input
              value={exerciseForm.optionC}
              onChange={(e) =>
                setExerciseForm({ ...exerciseForm, optionC: e.target.value })
              }
              placeholder="Nhập lựa chọn C"
              required
            />
          </label>
          <label>
            Lựa chọn D
            <input
              value={exerciseForm.optionD}
              onChange={(e) =>
                setExerciseForm({ ...exerciseForm, optionD: e.target.value })
              }
              placeholder="Nhập lựa chọn D"
              required
            />
          </label>
          <label>
            Đáp án đúng
            <select
              value={exerciseForm.correctOption}
              onChange={(e) =>
                setExerciseForm({ ...exerciseForm, correctOption: e.target.value })
              }
              required
            >
              <option value="A">A</option>
              <option value="B">B</option>
              <option value="C">C</option>
              <option value="D">D</option>
            </select>
          </label>
          <label>
            Giải thích
            <input
              value={exerciseForm.explanation}
              onChange={(e) =>
                setExerciseForm({ ...exerciseForm, explanation: e.target.value })
              }
              placeholder="Lời giải ngắn"
            />
          </label>
          <div className="form-actions span-2">
            <button type="submit" className="btn btn-primary btn-sm">
              Lưu bài tập
            </button>
          </div>
        </form>
        {exercises.length > 0 && (
          <ul className="admin-data-list">
            {exercises.map((item) => (
              <li key={item.id}>
                <strong>{item.lessonTitle}</strong>
                <span>{item.question} → Đáp án {item.correctOption}</span>
              </li>
            ))}
          </ul>
        )}
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
