import { useEffect, useState } from 'react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as statsApi from '../api/statistics.js';

export default function DashboardPage() {
  const [summary, setSummary] = useState(null);
  const [topCourses, setTopCourses] = useState([]);
  const [enrollments, setEnrollments] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      setLoading(true);
      setError('');
      try {
        const [s, top, monthly] = await Promise.all([
          statsApi.getDashboardSummary(),
          statsApi.getTopCourses().catch(() => []),
          statsApi.getMonthlyEnrollments(new Date().getFullYear()).catch(
            () => [],
          ),
        ]);
        setSummary(s);
        setTopCourses(Array.isArray(top) ? top : []);
        setEnrollments(Array.isArray(monthly) ? monthly : []);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }
    load();
  }, []);

  const cards = summary
    ? [
        { label: 'Tổng học viên', value: summary.totalStudents },
        { label: 'Khóa học active', value: summary.totalActiveCourses },
        {
          label: 'Đăng ký tháng này',
          value: summary.currentMonthEnrollments,
        },
        {
          label: 'Doanh thu tháng (VNĐ)',
          value: summary.currentMonthRevenue?.toLocaleString('vi-VN'),
        },
      ]
    : [];

  return (
    <div>
      <PageHeader
        title="Tổng quan"
        subtitle="Số liệu thống kê từ API /statistics"
      />
      {error && <Alert>{error}</Alert>}
      {loading ? (
        <p className="muted">Đang tải...</p>
      ) : (
        <>
          <div className="stat-grid">
            {cards.map((c) => (
              <div key={c.label} className="stat-card">
                <span className="stat-label">{c.label}</span>
                <span className="stat-value">{c.value ?? '—'}</span>
              </div>
            ))}
          </div>

          <div className="panel-grid">
            <section className="panel">
              <h2>Top khóa học</h2>
              {topCourses.length === 0 ? (
                <p className="muted">Chưa có dữ liệu</p>
              ) : (
                <table className="data-table">
                  <thead>
                    <tr>
                      <th>Khóa học</th>
                      <th>Học viên</th>
                    </tr>
                  </thead>
                  <tbody>
                    {topCourses.map((c) => (
                      <tr key={c.courseId}>
                        <td>{c.title}</td>
                        <td>{c.totalStudents}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </section>

            <section className="panel">
              <h2>Đăng ký theo tháng</h2>
              {enrollments.length === 0 ? (
                <p className="muted">Chưa có dữ liệu</p>
              ) : (
                <table className="data-table">
                  <thead>
                    <tr>
                      <th>Tháng</th>
                      <th>Lượt ĐK</th>
                    </tr>
                  </thead>
                  <tbody>
                    {enrollments.map((e) => (
                      <tr key={`${e.year}-${e.month}`}>
                        <td>
                          {e.month}/{e.year}
                        </td>
                        <td>{e.enrollments}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </section>
          </div>
        </>
      )}
    </div>
  );
}
