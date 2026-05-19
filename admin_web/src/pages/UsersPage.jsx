import { useEffect, useMemo, useState } from 'react';
import { Lock, Search, Unlock, UserPlus } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as authApi from '../api/auth.js';
import * as mockAdminApi from '../api/mockAdmin.js';

const emptyForm = { email: '', password: '', fullName: '' };

export default function UsersPage() {
  const [students, setStudents] = useState([]);
  const [form, setForm] = useState(emptyForm);
  const [query, setQuery] = useState('');
  const [createdUser, setCreatedUser] = useState(null);
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  async function loadStudents() {
    setLoading(true);
    try {
      setStudents(await mockAdminApi.getMockStudents());
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    loadStudents();
  }, []);

  const filteredStudents = useMemo(() => {
    const keyword = query.trim().toLowerCase();
    if (!keyword) return students;
    return students.filter(
      (student) =>
        student.fullName.toLowerCase().includes(keyword) ||
        student.email.toLowerCase().includes(keyword),
    );
  }, [query, students]);

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

  async function toggleStatus(student) {
    const nextStatus = student.status === 'ACTIVE' ? 'LOCKED' : 'ACTIVE';
    await mockAdminApi.updateMockStudentStatus(student.id, nextStatus);
    await loadStudents();
  }

  return (
    <div>
      <PageHeader
        title="Học viên"
        subtitle="Quản lý tài khoản học viên, trạng thái và thông tin học tập"
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
      </section>

      <section className="panel">
        <div className="panel-head">
          <h2>Danh sách học viên</h2>
          <label className="search-box">
            <Search size={16} />
            <input
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Tìm theo tên hoặc email"
            />
          </label>
        </div>
        <p className="muted">
          Danh sách đang dùng mock API vì backend chưa có endpoint admin để lấy
          toàn bộ học viên.
        </p>
        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Học viên</th>
                <th>Email</th>
                <th>Trạng thái</th>
                <th>Khóa đã đăng ký</th>
                <th>Bài hoàn thành</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {filteredStudents.map((student) => (
                <tr key={student.id}>
                  <td>{student.fullName}</td>
                  <td>{student.email}</td>
                  <td>
                    <span className={`status-pill ${student.status === 'ACTIVE' ? 'success' : 'danger'}`}>
                      {student.status === 'ACTIVE' ? 'Đang hoạt động' : 'Đã khóa'}
                    </span>
                  </td>
                  <td>{student.enrolledCourses}</td>
                  <td>{student.completedLessons}</td>
                  <td className="actions-cell">
                    <button
                      type="button"
                      className="btn btn-ghost btn-sm"
                      onClick={() => toggleStatus(student)}
                    >
                      {student.status === 'ACTIVE' ? <Lock size={14} /> : <Unlock size={14} />}
                      {student.status === 'ACTIVE' ? 'Khóa' : 'Mở khóa'}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
        {createdUser && (
          <p className="muted">
            Vừa tạo: {createdUser.fullName} ({createdUser.email})
          </p>
        )}
      </section>
    </div>
  );
}
