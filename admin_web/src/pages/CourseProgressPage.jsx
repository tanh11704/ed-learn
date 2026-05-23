import { useEffect, useMemo, useState } from 'react';
import {
  Activity,
  BookOpenCheck,
  CalendarClock,
  CheckCircle2,
  Search,
  UserRoundCheck,
} from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as courseProgressApi from '../api/courseProgress.js';
import * as coursesApi from '../api/courses.js';

const statusOptions = [
  { value: 'ALL', label: 'Tất cả trạng thái' },
  { value: 'LEARNING', label: 'Đang học' },
  { value: 'COMPLETED', label: 'Hoàn thành' },
  { value: 'INACTIVE', label: 'Ít hoạt động' },
];

const statusMeta = {
  COMPLETED: { label: 'Hoàn thành', className: 'success' },
  LEARNING: { label: 'Đang học', className: 'warning' },
  INACTIVE: { label: 'Ít hoạt động', className: 'danger' },
};

function formatDate(value) {
  if (!value) return 'Chưa có';
  return new Intl.DateTimeFormat('vi-VN').format(new Date(value));
}

function getProgressLevel(progressPercent) {
  if (progressPercent >= 80) return 'high';
  if (progressPercent >= 40) return 'medium';
  return 'low';
}

export default function CourseProgressPage() {
  const [courses, setCourses] = useState([]);
  const [selectedCourse, setSelectedCourse] = useState(null);
  const [items, setItems] = useState([]);
  const [query, setQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('ALL');
  const [error, setError] = useState('');
  const [loadingCourses, setLoadingCourses] = useState(true);
  const [loadingProgress, setLoadingProgress] = useState(false);

  useEffect(() => {
    async function loadCourses() {
      setLoadingCourses(true);
      setError('');
      try {
        const data = await coursesApi.getCourses({ page: 0, size: 100 });
        setCourses(Array.isArray(data?.content) ? data.content : []);
      } catch (err) {
        setCourses([]);
        setError(err.message);
      } finally {
        setLoadingCourses(false);
      }
    }
    loadCourses();
  }, []);

  async function handleSelectCourse(course) {
    setSelectedCourse(course);
    setItems([]);
    setQuery('');
    setStatusFilter('ALL');
    setLoadingProgress(true);
    setError('');
    try {
      const data = await courseProgressApi.getCourseProgress(course.id);
      setItems(Array.isArray(data) ? data : []);
    } catch (err) {
      setItems([]);
      setError(err.message);
    } finally {
      setLoadingProgress(false);
    }
  }

  const filtered = useMemo(() => {
    const keyword = query.trim().toLowerCase();
    return items.filter((item) => {
      const matchesKeyword =
        !keyword ||
        item.studentName?.toLowerCase().includes(keyword) ||
        item.email?.toLowerCase().includes(keyword);
      const matchesStatus =
        statusFilter === 'ALL' || item.status === statusFilter;
      return matchesKeyword && matchesStatus;
    });
  }, [items, query, statusFilter]);

  const stats = useMemo(() => {
    const totalEnrollments = items.length;
    const activeStudents = new Set(items.map((item) => item.studentId)).size;
    const completed = items.filter((item) => item.status === 'COMPLETED').length;
    const avgProgress = totalEnrollments
      ? Math.round(
          items.reduce((sum, item) => sum + (item.progressPercent || 0), 0) /
            totalEnrollments,
        )
      : 0;

    return [
      { label: 'Lượt đăng ký', value: totalEnrollments, icon: UserRoundCheck },
      { label: 'Học viên', value: activeStudents, icon: Activity },
      {
        label: 'Tiến độ trung bình',
        value: `${avgProgress}%`,
        icon: BookOpenCheck,
      },
      { label: 'Đã hoàn thành', value: completed, icon: CheckCircle2 },
    ];
  }, [items]);

  return (
    <div>
      <PageHeader
        title="Quản lý tiến độ học"
        subtitle="Chọn một khóa học để xem tiến trình học tập của học viên trong khóa đó"
      />
      {error && <Alert>{error}</Alert>}

      <section className="panel">
        <div className="panel-head">
          <div>
            <h2>Danh sách khóa học</h2>
            <p className="muted panel-note">
              Admin chọn một khóa học trước khi xem tiến độ của học viên.
            </p>
          </div>
        </div>

        {loadingCourses ? (
          <p className="muted">Đang tải khóa học...</p>
        ) : courses.length === 0 ? (
          <p className="muted">Chưa có khóa học để theo dõi.</p>
        ) : (
          <div className="course-picker-grid">
            {courses.map((course) => (
              <button
                key={course.id}
                type="button"
                className={`course-picker-card${
                  selectedCourse?.id === course.id ? ' active' : ''
                }`}
                onClick={() => handleSelectCourse(course)}
              >
                <strong>{course.title}</strong>
                <span>{course.subject || 'Chưa phân loại'}</span>
                <span
                  className={`status-pill ${
                    course.isDeleted ? 'danger' : 'success'
                  }`}
                >
                  {course.isDeleted ? 'Đã xóa' : 'Đang hoạt động'}
                </span>
              </button>
            ))}
          </div>
        )}
      </section>

      {selectedCourse && (
        <div className="stat-grid">
          {stats.map(({ label, value, icon: Icon }) => (
            <div key={label} className="stat-card">
              <span className="stat-label progress-stat-label">
                <Icon size={17} />
                {label}
              </span>
              <span className="stat-value">
                {loadingProgress ? '...' : value}
              </span>
            </div>
          ))}
        </div>
      )}

      <section className="panel">
        <div className="panel-head">
          <div>
            <h2>
              {selectedCourse
                ? `Tiến độ: ${selectedCourse.title}`
                : 'Tiến độ học viên'}
            </h2>
            <p className="muted panel-note">
              {selectedCourse
                ? 'Dữ liệu lấy từ API quản trị /management/course-progress theo khóa học đã chọn.'
                : 'Chọn một khóa học ở phía trên để xem danh sách học viên và tiến độ.'}
            </p>
          </div>
          {selectedCourse && (
            <div className="progress-toolbar">
              <label className="search-box">
                <Search size={16} />
                <input
                  value={query}
                  onChange={(e) => setQuery(e.target.value)}
                  placeholder="Tìm học viên hoặc email"
                />
              </label>
              <label className="field-label progress-filter">
                <span className="sr-only">Lọc theo trạng thái</span>
                <select
                  value={statusFilter}
                  onChange={(e) => setStatusFilter(e.target.value)}
                >
                  {statusOptions.map((option) => (
                    <option key={option.value} value={option.value}>
                      {option.label}
                    </option>
                  ))}
                </select>
              </label>
            </div>
          )}
        </div>

        {!selectedCourse ? (
          <div className="empty-state">
            <BookOpenCheck size={32} />
            <h3>Chưa chọn khóa học</h3>
            <p className="muted">
              Danh sách tiến độ sẽ xuất hiện sau khi admin chọn một khóa học.
            </p>
          </div>
        ) : loadingProgress ? (
          <p className="muted">Đang tải tiến độ...</p>
        ) : filtered.length === 0 ? (
          <div className="empty-state">
            <CalendarClock size={32} />
            <h3>Không tìm thấy tiến độ phù hợp</h3>
            <p className="muted">
              Khóa học này chưa có học viên hoặc bộ lọc hiện tại không có kết quả.
            </p>
          </div>
        ) : (
          <table className="data-table course-progress-table">
            <thead>
              <tr>
                <th>Học viên</th>
                <th>Tiến độ</th>
                <th>Bài học</th>
                <th>Ngày đăng ký</th>
                <th>Hoạt động gần nhất</th>
                <th>Trạng thái</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((item) => (
                <tr key={item.id}>
                  <td>
                    <strong>{item.studentName}</strong>
                    <span className="table-subtext">{item.email}</span>
                  </td>
                  <td>
                    <div
                      className={`progress-cell progress-${getProgressLevel(
                        item.progressPercent,
                      )}`}
                    >
                      <div className="progress-track">
                        <span
                          style={{ width: `${item.progressPercent || 0}%` }}
                        />
                      </div>
                      <strong>{item.progressPercent || 0}%</strong>
                    </div>
                  </td>
                  <td>
                    {item.completedLessons}/{item.totalLessons}
                  </td>
                  <td>{formatDate(item.enrolledAt)}</td>
                  <td>{formatDate(item.lastActivity)}</td>
                  <td>
                    <span
                      className={`status-pill ${
                        statusMeta[item.status]?.className || ''
                      }`}
                    >
                      {statusMeta[item.status]?.label || item.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </div>
  );
}
