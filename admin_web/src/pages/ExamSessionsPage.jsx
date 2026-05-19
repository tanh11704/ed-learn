import { useEffect, useState } from 'react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as mockAdminApi from '../api/mockAdmin.js';

export default function ExamSessionsPage() {
  const [items, setItems] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      setLoading(true);
      try {
        setItems(await mockAdminApi.getMockExamSessions());
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }
    load();
  }, []);

  return (
    <div>
      <PageHeader
        title="Lượt làm đề"
        subtitle="Theo dõi phiên làm bài, điểm số và kết quả nộp bài"
      />
      {error && <Alert>{error}</Alert>}

      <section className="panel">
        <h2>Kết quả làm đề</h2>
        <p className="muted">
          Dữ liệu đang dùng mock API vì backend chưa có endpoint admin để xem
          toàn bộ exam session.
        </p>
        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Học viên</th>
                <th>Đề thi</th>
                <th>Điểm</th>
                <th>Đúng/Tổng</th>
                <th>Trạng thái</th>
                <th>Thời gian nộp</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.id}>
                  <td>{item.studentName}</td>
                  <td>{item.examTitle}</td>
                  <td>{item.score}</td>
                  <td>
                    {item.correctAnswers}/{item.totalQuestions}
                  </td>
                  <td>
                    <span className="status-pill success">{item.status}</span>
                  </td>
                  <td>{item.submittedAt}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </div>
  );
}
