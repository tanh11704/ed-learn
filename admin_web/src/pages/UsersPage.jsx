import { useEffect, useMemo, useState } from 'react';
import {
  Activity,
  BookOpenCheck,
  CalendarClock,
  Search,
  UserPlus,
  Users,
} from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as authApi from '../api/auth.js';
import * as courseProgressApi from '../api/courseProgress.js';
import * as coursesApi from '../api/courses.js';

const emptyForm = { email: '', password: '', fullName: '' };
const ALL_COURSES = 'ALL';

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

function getStudentStatus(items) {
  if (items.some((item) => item.status === 'LEARNING')) return 'LEARNING';
  if (items.length > 0 && items.every((item) => item.status === 'COMPLETED')) return 'COMPLETED';
  return items[0]?.status || 'INACTIVE';
}

function aggregateStudents(items) {
  const byStudent = new Map();
  items.forEach((item) => {
    const key = item.studentId || item.email;
    if (!key) return;
    const current = byStudent.get(key) || {
      studentId: item.studentId,
      studentName: item.studentName,
      email: item.email,
      enrollments: [],
      completedLessons: 0,
      totalLessons: 0,
      lastActivity: null,
      enrolledAt: null,
    };
    current.enrollments.push(item);
    current.completedLessons += item.completedLessons || 0;
    current.totalLessons += item.totalLessons || 0;
    if (!current.enrolledAt || new Date(item.enrolledAt) < new Date(current.enrolledAt)) {
      current.enrolledAt = item.enrolledAt;
    }
    if (!current.lastActivity || new Date(item.lastActivity) > new Date(current.lastActivity)) {
      current.lastActivity = item.lastActivity;
    }
    byStudent.set(key, current);
  });

  return Array.from(byStudent.values()).map((student) => ({
    ...student,
    courseTitles: student.enrollments.map((item) => item.courseTitle).filter(Boolean),
    progressPercent: student.totalLessons
      ? Math.round((student.completedLessons * 100) / student.totalLessons)
      : 0,
    status: getStudentStatus(student.enrollments),
  }));
}

export default function UsersPage() {
  const [courses, setCourses] = useState([]);
  const [students, setStudents] = useState([]);
  const [form, setForm] = useState(emptyForm);
  const [query, setQuery] = useState('');
  const [courseId, setCourseId] = useState(ALL_COURSES);
  const [statusFilter, setStatusFilter] = useState('ALL');
  const [createdUser, setCreatedUser] = useState(null);
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');
  const [loadingCourses, setLoadingCourses] = useState(true);
  const [loadingStudents, setLoadingStudents] = useState(false);

  useEffect(() => {
    async function loadCourses() {
      setLoadingCourses(true);
      setError('');
      try {
        const data = await coursesApi.getCourses({ page: 0, size: 100, status: 'ACTIVE' });
        const list = Array.isArray(data?.content) ? data.content : [];
        setCourses(list);
      } catch (err) {
        setCourses([]);
        setError(err.message);
      } finally {
        setLoadingCourses(false);
      }
    }
    loadCourses();
  }, []);

  useEffect(() => {
    if (loadingCourses) return;
    async function loadStudents() {
      setLoadingStudents(true);
      setError('');
      try {
        const selectedCourses =
          courseId === ALL_COURSES ? courses : courses.filter((course) => course.id === courseId);
        const progressGroups = await Promise.all(
          selectedCourses.map((course) => courseProgressApi.getCourseProgress(course.id)),
        );
        const progressItems = progressGroups.flatMap((group) => (Array.isArray(group) ? group : []));
        setStudents(aggregateStudents(progressItems));
      } catch (err) {
        setStudents([]);
        setError(err.message);
      } finally {
        setLoadingStudents(false);
      }
    }
    loadStudents();
  }, [courseId, courses, loadingCourses]);

  const filteredStudents = useMemo(() => {
    const keyword = query.trim().toLowerCase();
    return students.filter((student) => {
      const matchesKeyword =
        !keyword ||
        student.studentName?.toLowerCase().includes(keyword) ||
        student.email?.toLowerCase().includes(keyword) ||
        student.courseTitles.some((title) => title.toLowerCase().includes(keyword));
      const matchesStatus = statusFilter === 'ALL' || student.status === statusFilter;
      return matchesKeyword && matchesStatus;
    });
  }, [query, statusFilter, students]);

  const stats = useMemo(() => {
    const totalStudents = students.length;
    const totalEnrollments = students.reduce(
      (sum, student) => sum + student.enrollments.length,
      0,
    );
    const completedStudents = students.filter((student) => student.status === 'COMPLETED').length;
    const avgProgress = totalStudents
      ? Math.round(
          students.reduce((sum, student) => sum + (student.progressPercent || 0), 0) /
            totalStudents,
        )
      : 0;

    return [
      { label: 'Học viên', value: totalStudents, icon: Users },
      { label: 'Lượt đăng ký', value: totalEnrollments, icon: Activity },
      { label: 'Tiến độ TB', value: `${avgProgress}%`, icon: BookOpenCheck },
      { label: 'Đã hoàn thành', value: completedStudents, icon: CalendarClock },
    ];
  }, [students]);

  async function handleCreateStudent(e) {
    e.preventDefault();
    setError('');
    setMessage('');
    setCreatedUser(null);
    try {
      const data = await authApi.register(form);
      setCreatedUser({
        email: form.email,
        fullName: form.fullName,
        tokenType: data.tokenType,
      });
      setForm(emptyForm);
      setMessage('Đã tạo tài khoản học viên.');
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <div>
      <PageHeader
        title="Học viên"
        subtitle="Theo dõi danh sách học viên và tiến độ học tập theo khóa học"
      />
      {error && <Alert>{error}</Alert>}
      {message && <div className="alert alert-success">{message}</div>}

      <section className="panel">
        <h2>Tạo tài khoản học viên</h2>
        <form className="form-grid" onSubmit={handleCreateStudent}>
          <label>
            Email
            <input
              type="email"
              value={form.email}
              onChange={(e) => setForm({ ...form, email: e.target.value })}
              required
            />
          </label>
          <label>
            Họ tên
            <input
              value={form.fullName}
              onChange={(e) => setForm({ ...form, fullName: e.target.value })}
              required
            />
          </label>
          <label className="span-2">
            Mật khẩu
            <input
              type="password"
              minLength={6}
              value={form.password}
              onChange={(e) => setForm({ ...form, password: e.target.value })}
              required
            />
          </label>
          <div className="form-actions span-2">
            <button type="submit" className="btn btn-primary">
              <UserPlus size={16} /> Tạo học viên
            </button>
          </div>
        </form>
        {createdUser && (
          <p className="muted">
            Vừa tạo: {createdUser.fullName} ({createdUser.email})
          </p>
        )}
      </section>

      <section className="panel">
        <div className="panel-head">
          <div>
            <h2>Danh sách học viên</h2>
            <p className="muted panel-note">
              Dữ liệu lấy từ tiến độ đăng ký khóa học của học viên.
            </p>
          </div>
          <div className="progress-toolbar">
            <label className="field-label progress-filter">
              <span className="sr-only">Lọc theo khóa học</span>
              <select
                value={courseId}
                onChange={(e) => {
                  setCourseId(e.target.value);
                  setQuery('');
                }}
                disabled={loadingCourses}
              >
                <option value={ALL_COURSES}>Tất cả khóa học</option>
                {courses.map((course) => (
                  <option key={course.id} value={course.id}>
                    {course.title}
                  </option>
                ))}
              </select>
            </label>
            <label className="field-label progress-filter">
              <span className="sr-only">Lọc theo trạng thái</span>
              <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)}>
                {statusOptions.map((option) => (
                  <option key={option.value} value={option.value}>
                    {option.label}
                  </option>
                ))}
              </select>
            </label>
            <label className="search-box">
              <Search size={16} />
              <input
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder="Tìm học viên, email hoặc khóa học"
              />
            </label>
          </div>
        </div>

        {loadingCourses || loadingStudents ? (
          <p className="muted">Đang tải học viên...</p>
        ) : courses.length === 0 ? (
          <div className="empty-state">
            <BookOpenCheck size={32} />
            <h3>Chưa có khóa học</h3>
            <p className="muted">Tạo khóa học trước khi theo dõi danh sách học viên.</p>
          </div>
        ) : filteredStudents.length === 0 ? (
          <div className="empty-state">
            <Users size={32} />
            <h3>Không tìm thấy học viên</h3>
            <p className="muted">Khóa học hoặc bộ lọc hiện tại chưa có học viên phù hợp.</p>
          </div>
        ) : (
          <>
            <div className="stat-grid">
              {stats.map(({ label, value, icon: Icon }) => (
                <div key={label} className="stat-card">
                  <span className="stat-label progress-stat-label">
                    <Icon size={17} />
                    {label}
                  </span>
                  <span className="stat-value">{value}</span>
                </div>
              ))}
            </div>
            <table className="data-table course-progress-table">
              <thead>
                <tr>
                  <th>Học viên</th>
                  <th>Khóa học</th>
                  <th>Tiến độ</th>
                  <th>Bài học</th>
                  <th>Ngày đăng ký</th>
                  <th>Hoạt động gần nhất</th>
                  <th>Trạng thái</th>
                </tr>
              </thead>
              <tbody>
                {filteredStudents.map((student) => (
                  <tr key={student.studentId || student.email}>
                    <td>
                      <strong>{student.studentName || 'Chưa có tên'}</strong>
                      <span className="table-subtext">{student.email}</span>
                    </td>
                    <td>
                      <strong>{student.enrollments.length}</strong>
                      <span className="table-subtext">
                        {student.courseTitles.slice(0, 2).join(', ')}
                        {student.courseTitles.length > 2
                          ? ` +${student.courseTitles.length - 2}`
                          : ''}
                      </span>
                    </td>
                    <td>
                      <div
                        className={`progress-cell progress-${getProgressLevel(
                          student.progressPercent,
                        )}`}
                      >
                        <div className="progress-track">
                          <span style={{ width: `${student.progressPercent || 0}%` }} />
                        </div>
                        <strong>{student.progressPercent || 0}%</strong>
                      </div>
                    </td>
                    <td>
                      {student.completedLessons}/{student.totalLessons}
                    </td>
                    <td>{formatDate(student.enrolledAt)}</td>
                    <td>{formatDate(student.lastActivity)}</td>
                    <td>
                      <span className={`status-pill ${statusMeta[student.status]?.className || ''}`}>
                        {statusMeta[student.status]?.label || student.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </>
        )}
      </section>
    </div>
  );
}
