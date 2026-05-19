import { useEffect, useMemo, useState } from 'react';
import { Search } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as mockAdminApi from '../api/mockAdmin.js';

export default function CourseProgressPage() {
  const [items, setItems] = useState([]);
  const [query, setQuery] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      setLoading(true);
      try {
        setItems(await mockAdminApi.getMockCourseProgress());
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }
    load();
  }, []);

  const filtered = useMemo(() => {
    const keyword = query.trim().toLowerCase();
    if (!keyword) return items;
    return items.filter(
      (item) =>
        item.studentName.toLowerCase().includes(keyword) ||
        item.courseTitle.toLowerCase().includes(keyword),
    );
  }, [items, query]);

  return (
    <div>
      <PageHeader
        title="Đăng ký và tiến độ"
        subtitle="Theo dõi học viên đã đăng ký khóa học và mức độ hoàn thành"
      />
      {error && <Alert>{error}</Alert>}

      <section className="panel">
        <div className="panel-head">
          <h2>Tiến độ học tập</h2>
          <label className="search-box">
            <Search size={16} />
            <input
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Tìm học viên hoặc khóa học"
            />
          </label>
        </div>
        <p className="muted">
          Dữ liệu đang dùng mock API vì backend chưa có endpoint admin cho đăng
          ký khóa học và tiến độ từng học viên.
        </p>
        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : (
          <table className="data-table">
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
                  <td>{item.studentName}</td>
                  <td>{item.courseTitle}</td>
                  <td>
                    <div className="progress-cell">
                      <div className="progress-track">
                        <span style={{ width: `${item.progressPercent}%` }} />
                      </div>
                      <strong>{item.progressPercent}%</strong>
                    </div>
                  </td>
                  <td>
                    {item.completedLessons}/{item.totalLessons}
                  </td>
                  <td>{item.lastActivity}</td>
                  <td>{item.status}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </div>
  );
}
