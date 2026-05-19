import { useEffect, useMemo, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import {
  ArrowLeft,
  BookOpen,
  FileText,
  GraduationCap,
  PlayCircle,
  Settings,
} from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as coursesApi from '../api/courses.js';
import * as chaptersApi from '../api/chapters.js';

function normalizeChapters(course, chapterList) {
  if (Array.isArray(chapterList)) return chapterList;
  if (Array.isArray(course?.chapters)) return course.chapters;
  return [];
}

function countLessons(chapters) {
  return chapters.reduce((total, chapter) => total + (chapter.lessons?.length || 0), 0);
}

export default function CoursePreviewPage() {
  const { id } = useParams();
  const [course, setCourse] = useState(null);
  const [chapters, setChapters] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    let mounted = true;

    async function load() {
      setLoading(true);
      setError('');
      try {
        const [detail, chapterList] = await Promise.all([
          coursesApi.getCourseDetail(id),
          chaptersApi.getChaptersByCourse(id),
        ]);
        if (!mounted) return;
        setCourse(detail);
        setChapters(normalizeChapters(detail, chapterList));
      } catch (err) {
        if (mounted) setError(err.message);
      } finally {
        if (mounted) setLoading(false);
      }
    }

    load();
    return () => {
      mounted = false;
    };
  }, [id]);

  const lessonTotal = useMemo(() => countLessons(chapters), [chapters]);
  const previewLessonTotal = useMemo(
    () =>
      chapters.reduce(
        (total, chapter) =>
          total + (chapter.lessons || []).filter((lesson) => lesson.isPreview).length,
        0,
      ),
    [chapters],
  );

  if (loading) return <p className="muted">Đang tải khóa học...</p>;
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
          <Link to={`/courses/${id}/manage`} className="btn btn-primary">
            <Settings size={16} /> Quản lý nội dung
          </Link>
        }
      />
      {error && <Alert>{error}</Alert>}

      <section className="course-hero-panel">
        <div className="course-hero-copy">
          <span className="course-kicker">
            <GraduationCap size={16} /> Khóa học
          </span>
          <h2>{course.title}</h2>
          <p>{course.description || 'Chưa có mô tả cho khóa học này.'}</p>
          <div className="course-stat-row">
            <div>
              <strong>{chapters.length}</strong>
              <span>Chương</span>
            </div>
            <div>
              <strong>{lessonTotal}</strong>
              <span>Bài học</span>
            </div>
            <div>
              <strong>{previewLessonTotal}</strong>
              <span>Bài học thử</span>
            </div>
          </div>
        </div>
        <div className="course-hero-media">
          {course.thumbnailUrl ? (
            <img src={course.thumbnailUrl} alt={course.title} />
          ) : (
            <div className="course-thumbnail-placeholder">
              <BookOpen size={44} />
              <span>{course.subject || 'EdLearn'}</span>
            </div>
          )}
        </div>
      </section>

      <section className="panel">
        <div className="panel-head">
          <h2>Nội dung khóa học</h2>
          <span className="muted">
            {chapters.length} chương / {lessonTotal} bài học
          </span>
        </div>

        {chapters.length === 0 ? (
          <p className="muted">Khóa học chưa có chương nào.</p>
        ) : (
          <div className="course-curriculum">
            {chapters.map((chapter, chapterIndex) => (
              <article key={chapter.id || chapterIndex} className="curriculum-chapter">
                <div className="curriculum-chapter-head">
                  <span>Chương {chapterIndex + 1}</span>
                  <h3>{chapter.title}</h3>
                  <p>{chapter.lessons?.length || 0} bài học</p>
                </div>
                {(chapter.lessons || []).length > 0 ? (
                  <ul className="curriculum-lessons">
                    {chapter.lessons.map((lesson, lessonIndex) => (
                      <li key={lesson.id || lessonIndex}>
                        <span className="lesson-index">{lessonIndex + 1}</span>
                        <div>
                          <strong>{lesson.title}</strong>
                          <span>
                            {lesson.isPreview ? 'Cho phép học thử' : 'Bài học chính thức'}
                            {lesson.videoUrl ? ' / Có video' : ''}
                            {lesson.pdfUrl ? ' / Có PDF' : ''}
                          </span>
                        </div>
                        {lesson.videoUrl ? <PlayCircle size={18} /> : <FileText size={18} />}
                      </li>
                    ))}
                  </ul>
                ) : (
                  <p className="muted">Chương này chưa có bài học.</p>
                )}
              </article>
            ))}
          </div>
        )}
      </section>
    </div>
  );
}
