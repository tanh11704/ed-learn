import { useEffect, useMemo, useState } from 'react';
import {
  AlertTriangle,
  CheckCircle2,
  Clock3,
  RotateCcw,
  Search,
  Users,
} from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as errorBankApi from '../api/errorBank.js';

function formatDate(value) {
  if (!value) return 'Chưa có';
  return new Intl.DateTimeFormat('vi-VN', {
    dateStyle: 'short',
    timeStyle: 'short',
  }).format(new Date(value));
}

function formatNumber(value, digits = 1) {
  if (value === null || value === undefined) return '-';
  return Number(value).toFixed(digits);
}

function getClassLabel(item) {
  if (!item.gradeLevel && !item.className) return 'Chưa có lớp';
  return `Lớp ${item.gradeLevel || '-'}${item.className ? ` - ${item.className}` : ''}`;
}

export default function ErrorBankAdminPage() {
  const [items, setItems] = useState([]);
  const [query, setQuery] = useState('');
  const [classFilter, setClassFilter] = useState('ALL');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    setError('');
    try {
      const data = await errorBankApi.getErrorBankStudentStatistics();
      setItems(Array.isArray(data) ? data : []);
    } catch (err) {
      setItems([]);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
  }, []);

  const classOptions = useMemo(() => {
    const labels = new Set(items.map(getClassLabel));
    return ['ALL', ...Array.from(labels).sort((a, b) => a.localeCompare(b, 'vi'))];
  }, [items]);

  const filtered = useMemo(() => {
    const keyword = query.trim().toLowerCase();
    return items.filter((item) => {
      const classLabel = getClassLabel(item);
      const matchesStudent =
        !keyword ||
        item.studentName?.toLowerCase().includes(keyword) ||
        item.email?.toLowerCase().includes(keyword);
      const matchesClass = classFilter === 'ALL' || classLabel === classFilter;
      return matchesStudent && matchesClass;
    });
  }, [classFilter, items, query]);

  const stats = useMemo(() => {
    const totalStudents = filtered.length;
    const totalErrors = filtered.reduce((sum, item) => sum + item.totalErrors, 0);
    const dueErrors = filtered.reduce((sum, item) => sum + item.dueErrors, 0);
    const masteredErrors = filtered.reduce(
      (sum, item) => sum + item.masteredErrors,
      0,
    );

    return [
      { label: 'Học viên có lỗi', value: totalStudents, icon: Users },
      { label: 'Tổng lỗi sai', value: totalErrors, icon: AlertTriangle },
      { label: 'Đến hạn ôn', value: dueErrors, icon: Clock3 },
      { label: 'Đã nắm vững', value: masteredErrors, icon: CheckCircle2 },
    ];
  }, [filtered]);

  return (
    <div>
      <PageHeader
        title="Lỗi sai học viên"
        subtitle="Thống kê ngân hàng lỗi sai theo học viên, lớp học và lịch ôn tập"
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
            <h2>Thống kê lỗi sai</h2>
            <p className="muted panel-note">
              Dữ liệu lấy từ API quản trị /management/error-bank/students/statistics.
            </p>
          </div>
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
              <span className="sr-only">Lọc theo lớp học</span>
              <select
                value={classFilter}
                onChange={(e) => setClassFilter(e.target.value)}
              >
                {classOptions.map((option) => (
                  <option key={option} value={option}>
                    {option === 'ALL' ? 'Tất cả lớp học' : option}
                  </option>
                ))}
              </select>
            </label>
            <button
              type="button"
              className="btn btn-ghost btn-sm"
              onClick={load}
              disabled={loading}
            >
              <RotateCcw size={14} /> Tải lại
            </button>
          </div>
        </div>

        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : filtered.length === 0 ? (
          <div className="empty-state">
            <AlertTriangle size={32} />
            <h3>Không có dữ liệu phù hợp</h3>
            <p className="muted">
              Thử đổi học viên, email hoặc bộ lọc lớp học.
            </p>
          </div>
        ) : (
          <table className="data-table error-bank-table">
            <thead>
              <tr>
                <th>Học viên</th>
                <th>Lớp học</th>
                <th>Tổng lỗi</th>
                <th>Đến hạn ôn</th>
                <th>Đã ôn</th>
                <th>Đã nắm vững</th>
                <th>Ease TB</th>
                <th>Chu kỳ TB</th>
                <th>Lịch ôn gần nhất</th>
                <th>Cập nhật cuối</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((item) => (
                <tr key={item.studentId}>
                  <td>
                    <strong>{item.studentName}</strong>
                    <span className="table-subtext">{item.email}</span>
                  </td>
                  <td>{getClassLabel(item)}</td>
                  <td>{item.totalErrors}</td>
                  <td>
                    <span
                      className={`status-pill ${
                        item.dueErrors > 0 ? 'warning' : 'success'
                      }`}
                    >
                      {item.dueErrors}
                    </span>
                  </td>
                  <td>{item.reviewedErrors}</td>
                  <td>{item.masteredErrors}</td>
                  <td>{formatNumber(item.averageEaseFactor, 2)}</td>
                  <td>{formatNumber(item.averageIntervalDays, 1)} ngày</td>
                  <td>{formatDate(item.nextReviewDate)}</td>
                  <td>{formatDate(item.lastUpdatedAt)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </div>
  );
}
