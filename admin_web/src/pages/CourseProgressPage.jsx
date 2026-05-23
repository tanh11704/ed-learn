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
  const [items, setItems] = useState([]);
  const [query, setQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('ALL');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      setLoading(true);
      setError('');
      try {
        const data = await courseProgressApi.getCourseProgress();
        setItems(Array.isArray(data) ? data : []);
      } catch (err) {
        setItems([]);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }
    load();
  }, []);

  const filtered = useMemo(() => {
    const keyword = query.trim().toLowerCase();
    return items.filter((item) => {
      const matchesKeyword =
        !keyword ||
        item.studentName?.toLowerCase().includes(keyword) ||
        item.email?.toLowerCase().includes(keyword) ||
        item.courseTitle?.toLowerCase().includes(keyword);
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
      { label: 'Tiến độ trung bình', value: `${avgProgress}%`, icon: BookOpenCheck },
      { label: 'Khóa hoàn thành', value: completed, icon: CheckCircle2 },
    ];
  }, [items]);

  return (
    <div>
      <PageHeader
        title="Quản lý tiến độ học"
        subtitle="Theo dõi khóa học đã đăng ký, mức độ hoàn thành và hoạt động gần nhất của học viên"
      />
      {error && <Alert>{error}</Alert>}

      <div className="stat-grid">
        {stats.map(({ label, value, icon: Icon }) => (
          <div key={label} className="stat-card">
            <span className="stat-label progress-stat-label">
              <Icon size={17} />
              {label}
            </span>
            <span className="stat-value">{loading ? '...' : value}</span>
          </div>
        ))}
      </div>

      <section className="panel">
        <div className="panel-head">
          <div>
            <h2>Danh sách tiến độ</h2>
            <p className="muted panel-note">
              Dữ liệu lấy từ API quản trị /management/course-progress.
            </p>
          </div>
          <div className="progress-toolbar">
            <label className="search-box">
              <Search size={16} />
              <input
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder="Tìm học viên, email hoặc khóa học"
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
        </div>

        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : filtered.length === 0 ? (
          <div className="empty-state">
            <CalendarClock size={32} />
            <h3>Không tìm thấy tiến độ phù hợp</h3>
            <p className="muted">
              Thử đổi từ khóa tìm kiếm hoặc chọn lại bộ lọc trạng thái.
            </p>
          </div>
        ) : (
          <table className="data-table course-progress-table">
            <thead>
              <tr>
                <th>Học viên</th>
                <th>Khóa học</th>
                <th>Tiến độ</th>
                <th>Bài học</th>
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
                    <strong>{item.courseTitle}</strong>
                    <span className="table-subtext">
                      Đăng ký: {formatDate(item.enrolledAt)}
                    </span>
                  </td>
                  <td>
                    <div
                      className={`progress-cell progress-${getProgressLevel(
                        item.progressPercent,
                      )}`}
                    >
                      <div className="progress-track">
                        <span style={{ width: `${item.progressPercent || 0}%` }} />
                      </div>
                      <strong>{item.progressPercent || 0}%</strong>
                    </div>
                  </td>
                  <td>
                    {item.completedLessons}/{item.totalLessons}
                  </td>
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
