import { useEffect, useMemo, useState } from 'react';
import { Bot, MessageSquare, Plus, RefreshCw, Send, Trash2 } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as coursesApi from '../api/courses.js';
import * as chaptersApi from '../api/chapters.js';
import * as ragApi from '../api/rag.js';

const SECTION_TYPES = ['theory', 'method', 'example', 'mistake', 'faq', 'exercise', 'summary'];
const SYNC_STORAGE_KEY = 'edlearn-rag-sync-status';

const emptySection = {
  section_title: '',
  section_type: 'theory',
  text: '',
};

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

function readSyncRecords() {
  try {
    return JSON.parse(localStorage.getItem(SYNC_STORAGE_KEY) || '{}');
  } catch {
    return {};
  }
}

function writeSyncRecords(records) {
  localStorage.setItem(SYNC_STORAGE_KEY, JSON.stringify(records));
}

function getSyncKey(courseId, lessonId) {
  return `${courseId}:${lessonId}`;
}

function slugify(value) {
  return value
    .trim()
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

function getStatusClass(status) {
  if (status === 'synced') return 'success';
  if (status === 'failed') return 'danger';
  if (status === 'syncing') return 'warning';
  return '';
}

function getStatusLabel(status) {
  if (status === 'synced') return 'Synced';
  if (status === 'failed') return 'Failed';
  if (status === 'syncing') return 'Syncing';
  return 'Not synced';
}

function getSectionId(section, index) {
  return slugify(section.section_title) || `section-${index + 1}`;
}

function buildChatHistory(messages) {
  return messages.slice(-6).map((message) => ({
    role: message.role,
    content: message.content,
  }));
}

export default function AiSolverAdminPage() {
  const [courses, setCourses] = useState([]);
  const [chapters, setChapters] = useState([]);
  const [courseId, setCourseId] = useState('');
  const [lessonId, setLessonId] = useState('');
  const [subject, setSubject] = useState('');
  const [gradeLevel, setGradeLevel] = useState(12);
  const [sections, setSections] = useState([{ ...emptySection }]);
  const [syncRecords, setSyncRecords] = useState(() => readSyncRecords());
  const [syncError, setSyncError] = useState('');
  const [chatError, setChatError] = useState('');
  const [loadingCourses, setLoadingCourses] = useState(true);
  const [loadingContent, setLoadingContent] = useState(false);
  const [syncing, setSyncing] = useState(false);
  const [chatScope, setChatScope] = useState('lesson');
  const [question, setQuestion] = useState('');
  const [messages, setMessages] = useState([]);
  const [chatLoading, setChatLoading] = useState(false);

  const selectedCourse = useMemo(
    () => courses.find((course) => course.id === courseId),
    [courses, courseId],
  );

  const lessons = useMemo(
    () => chapters.flatMap((chapter) => chapter.lessons || []),
    [chapters],
  );

  const selectedLesson = useMemo(
    () => lessons.find((lesson) => lesson.id === lessonId),
    [lessons, lessonId],
  );

  const currentSyncKey = courseId && lessonId ? getSyncKey(courseId, lessonId) : '';
  const currentSync = currentSyncKey ? syncRecords[currentSyncKey] : null;
  const syncStatus = syncing ? 'syncing' : currentSync?.status || 'idle';

  useEffect(() => {
    async function loadCourses() {
      setLoadingCourses(true);
      setSyncError('');
      try {
        const data = await coursesApi.getCourses({ page: 0, size: 100, status: 'ACTIVE' });
        const list = data.content || [];
        setCourses(list);
        if (list.length > 0) {
          setCourseId((current) => current || list[0].id);
          setSubject((current) => current || list[0].subject || '');
        }
      } catch (err) {
        setSyncError(err.message);
      } finally {
        setLoadingCourses(false);
      }
    }
    loadCourses();
  }, []);

  useEffect(() => {
    if (!courseId) {
      setChapters([]);
      setLessonId('');
      return;
    }

    async function loadCourseContent() {
      setLoadingContent(true);
      setSyncError('');
      try {
        const chapterList = await chaptersApi.getChaptersByCourse(courseId, { status: 'ACTIVE' });
        const nextChapters = normalizeChapters(Array.isArray(chapterList) ? chapterList : []);
        const nextLessons = nextChapters.flatMap((chapter) => chapter.lessons || []);
        setChapters(nextChapters);
        setLessonId((current) =>
          nextLessons.some((lesson) => lesson.id === current) ? current : nextLessons[0]?.id || '',
        );
        const course = courses.find((item) => item.id === courseId);
        setSubject(course?.subject || '');
        setMessages([]);
      } catch (err) {
        setSyncError(err.message);
      } finally {
        setLoadingContent(false);
      }
    }

    loadCourseContent();
  }, [courseId, courses]);

  function updateSection(index, field, value) {
    setSections((current) =>
      current.map((section, sectionIndex) =>
        sectionIndex === index ? { ...section, [field]: value } : section,
      ),
    );
  }

  function addSection() {
    setSections((current) => [...current, { ...emptySection }]);
  }

  function removeSection(index) {
    setSections((current) => current.filter((_, sectionIndex) => sectionIndex !== index));
  }

  async function handleSync(e) {
    e.preventDefault();
    if (!selectedCourse || !selectedLesson) return;

    const validSections = sections
      .map((section, index) => ({
        section_id: getSectionId(section, index),
        section_title: section.section_title.trim(),
        section_type: section.section_type,
        text: section.text.trim(),
      }))
      .filter((section) => section.section_title && section.text.length >= 20);

    if (validSections.length === 0) {
      setSyncError('Cần ít nhất một section có tiêu đề và nội dung từ 20 ký tự.');
      return;
    }

    setSyncing(true);
    setSyncError('');
    try {
      const result = await ragApi.ingestLesson({
        course_id: String(selectedCourse.id),
        lesson_id: String(selectedLesson.id),
        course_title: selectedCourse.title,
        lesson_title: selectedLesson.title,
        subject: subject.trim() || selectedCourse.subject || undefined,
        grade_level: Number(gradeLevel) || undefined,
        source_url: `manual://${selectedCourse.id}/${selectedLesson.id}`,
        sections: validSections,
      });

      const nextRecords = {
        ...syncRecords,
        [getSyncKey(selectedCourse.id, selectedLesson.id)]: {
          status: 'synced',
          chunkCount: result?.chunk_count ?? 0,
          syncedAt: new Date().toISOString(),
        },
      };
      setSyncRecords(nextRecords);
      writeSyncRecords(nextRecords);
    } catch (err) {
      const nextRecords = {
        ...syncRecords,
        [getSyncKey(selectedCourse.id, selectedLesson.id)]: {
          status: 'failed',
          error: err.message,
          syncedAt: new Date().toISOString(),
        },
      };
      setSyncRecords(nextRecords);
      writeSyncRecords(nextRecords);
      setSyncError(err.message);
    } finally {
      setSyncing(false);
    }
  }

  async function handleChat(e) {
    e.preventDefault();
    if (!selectedCourse || !question.trim()) return;
    if (chatScope === 'lesson' && !selectedLesson) {
      setChatError('Cần chọn lesson khi chat theo bài học.');
      return;
    }

    const userMessage = { role: 'user', content: question.trim() };
    const nextMessages = [...messages, userMessage];
    setMessages(nextMessages);
    setQuestion('');
    setChatLoading(true);
    setChatError('');

    try {
      const result = await ragApi.chat({
        user_id: 'admin-preview',
        course_id: String(selectedCourse.id),
        lesson_id: chatScope === 'lesson' ? String(selectedLesson.id) : undefined,
        question: userMessage.content,
        chat_history: buildChatHistory(messages),
      });

      setMessages([
        ...nextMessages,
        {
          role: 'assistant',
          content: result?.answer || 'AI chưa trả về câu trả lời.',
          sources: result?.sources || [],
          confidence: result?.confidence,
          usedFallback: result?.used_fallback,
        },
      ]);
    } catch (err) {
      setChatError(err.message);
      setMessages(nextMessages);
    } finally {
      setChatLoading(false);
    }
  }

  return (
    <div>
      <PageHeader
        title="AI giải bài"
        subtitle="Đồng bộ nội dung bài học vào RAG và kiểm tra chatbot theo lesson hoặc toàn khóa"
      />

      {syncError && <Alert>{syncError}</Alert>}
      {chatError && <Alert>{chatError}</Alert>}

      <section className="panel">
        <div className="panel-head">
          <div>
            <h2>Ngữ cảnh AI</h2>
            <p className="muted panel-note">Chọn khóa học và bài học trước khi đồng bộ hoặc chat thử.</p>
          </div>
          <span className={`status-pill ${getStatusClass(syncStatus)}`}>
            {getStatusLabel(syncStatus)}
          </span>
        </div>

        <div className="form-grid">
          <label>
            Khóa học
            <select
              value={courseId}
              onChange={(event) => setCourseId(event.target.value)}
              disabled={loadingCourses}
            >
              {courses.map((course) => (
                <option key={course.id} value={course.id}>
                  {course.title}
                </option>
              ))}
            </select>
          </label>
          <label>
            Bài học
            <select
              value={lessonId}
              onChange={(event) => {
                setLessonId(event.target.value);
                setMessages([]);
              }}
              disabled={loadingContent || lessons.length === 0}
            >
              {lessons.length === 0 ? (
                <option value="">Chưa có bài học</option>
              ) : (
                lessons.map((lesson) => (
                  <option key={lesson.id} value={lesson.id}>
                    {lesson.title}
                  </option>
                ))
              )}
            </select>
          </label>
          <label>
            Subject
            <input
              value={subject}
              onChange={(event) => setSubject(event.target.value)}
              placeholder="Ví dụ: Toán"
            />
          </label>
          <label>
            Grade level
            <input
              type="number"
              min="1"
              max="12"
              value={gradeLevel}
              onChange={(event) => setGradeLevel(event.target.value)}
            />
          </label>
        </div>

        {currentSync?.status === 'synced' && (
          <p className="muted panel-note">
            Đã đồng bộ {currentSync.chunkCount} chunks lúc{' '}
            {new Date(currentSync.syncedAt).toLocaleString('vi-VN')}.
          </p>
        )}
      </section>

      <section className="panel">
        <div className="panel-head">
          <div>
            <h2>AI Sync cho lesson</h2>
            <p className="muted panel-note">Nội dung section sẽ được gửi sang ai-service để tạo chunks trong ChromaDB.</p>
          </div>
          <button type="button" className="btn btn-ghost btn-sm" onClick={addSection}>
            <Plus size={16} /> Add section
          </button>
        </div>

        <form onSubmit={handleSync}>
          <div className="rag-section-list">
            {sections.map((section, index) => (
              <div className="rag-section-editor" key={`section-${index}`}>
                <div className="rag-section-head">
                  <h3>Section {index + 1}</h3>
                  {sections.length > 1 && (
                    <button
                      type="button"
                      className="btn-icon danger"
                      onClick={() => removeSection(index)}
                      title="Xóa section"
                    >
                      <Trash2 size={16} />
                    </button>
                  )}
                </div>
                <div className="form-grid">
                  <label>
                    Section title
                    <input
                      value={section.section_title}
                      onChange={(event) =>
                        updateSection(index, 'section_title', event.target.value)
                      }
                      placeholder="Ví dụ: Định nghĩa"
                      required
                    />
                  </label>
                  <label>
                    Section type
                    <select
                      value={section.section_type}
                      onChange={(event) =>
                        updateSection(index, 'section_type', event.target.value)
                      }
                    >
                      {SECTION_TYPES.map((type) => (
                        <option key={type} value={type}>
                          {type}
                        </option>
                      ))}
                    </select>
                  </label>
                  <label className="span-2">
                    Section text
                    <textarea
                      rows={5}
                      value={section.text}
                      onChange={(event) => updateSection(index, 'text', event.target.value)}
                      placeholder="Nhập nội dung bài học, ví dụ, phương pháp hoặc lỗi sai thường gặp..."
                      required
                    />
                  </label>
                </div>
              </div>
            ))}
          </div>

          <div className="form-actions rag-actions">
            <button
              type="submit"
              className="btn btn-primary"
              disabled={syncing || !selectedLesson}
            >
              <RefreshCw size={16} /> {syncing ? 'Đang đồng bộ...' : 'Đồng bộ AI'}
            </button>
          </div>
        </form>
      </section>

      <section className="panel rag-chat-panel">
        <div className="panel-head">
          <div>
            <h2>Chatbot kiểm thử</h2>
            <p className="muted panel-note">
              Chọn lesson để hỏi trong phạm vi bài học, hoặc chọn toàn khóa để bỏ lesson_id.
            </p>
          </div>
          <div className="rag-scope-toggle">
            <button
              type="button"
              className={chatScope === 'lesson' ? 'active' : ''}
              onClick={() => setChatScope('lesson')}
            >
              Lesson
            </button>
            <button
              type="button"
              className={chatScope === 'course' ? 'active' : ''}
              onClick={() => setChatScope('course')}
            >
              Course
            </button>
          </div>
        </div>

        <div className="rag-chat-window">
          {messages.length === 0 ? (
            <div className="empty-state">
              <Bot size={32} />
              <h3>Chưa có câu hỏi</h3>
              <p>Nhập câu hỏi để kiểm tra câu trả lời và sources từ RAG.</p>
            </div>
          ) : (
            messages.map((message, index) => (
              <div className={`rag-message ${message.role}`} key={`${message.role}-${index}`}>
                <div className="rag-message-title">
                  {message.role === 'user' ? <MessageSquare size={16} /> : <Bot size={16} />}
                  <strong>{message.role === 'user' ? 'Admin' : 'AI'}</strong>
                  {message.confidence !== undefined && (
                    <span className="status-pill">Confidence {Number(message.confidence).toFixed(2)}</span>
                  )}
                  {message.usedFallback && (
                    <span className="status-pill warning">Fallback</span>
                  )}
                </div>
                <p>{message.content}</p>
                {message.sources?.length > 0 && (
                  <details className="rag-sources">
                    <summary>Sources ({message.sources.length})</summary>
                    <ul>
                      {message.sources.map((source) => (
                        <li key={source.chunk_id || `${source.lesson_id}-${source.section_id}`}>
                          <strong>{source.section_title || source.lesson_title}</strong>
                          <span>
                            {source.section_type || 'section'} · score{' '}
                            {Number(source.score || 0).toFixed(2)}
                          </span>
                          {source.text && <p>{source.text}</p>}
                        </li>
                      ))}
                    </ul>
                  </details>
                )}
              </div>
            ))
          )}
          {chatLoading && <p className="muted">AI đang tìm trong bài học...</p>}
        </div>

        <form className="rag-chat-form" onSubmit={handleChat}>
          <input
            value={question}
            onChange={(event) => setQuestion(event.target.value)}
            placeholder="Nhập câu hỏi..."
          />
          <button
            type="submit"
            className="btn btn-primary"
            disabled={chatLoading || !selectedCourse || !question.trim()}
          >
            <Send size={16} /> Gửi
          </button>
        </form>
      </section>
    </div>
  );
}
