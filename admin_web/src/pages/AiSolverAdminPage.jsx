import { useEffect, useState } from 'react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as mockAdminApi from '../api/mockAdmin.js';

export default function AiSolverAdminPage() {
  const [items, setItems] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      setLoading(true);
      try {
        setItems(await mockAdminApi.getMockAiSolverLogs());
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
        title="AI giải bài"
        subtitle="Theo dõi lượt dùng AI solver, AI tutor và notebook"
      />
      {error && <Alert>{error}</Alert>}

      <section className="panel">
        <h2>Lịch sử sử dụng AI</h2>
        <p className="muted">
          Mobile AI solver hiện chưa có remote datasource thật, nên dữ liệu admin
          đang là mock API.
        </p>
        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Học viên</th>
                <th>Chủ đề</th>
                <th>Nguồn</th>
                <th>Trạng thái</th>
                <th>Lưu notebook</th>
                <th>Thời gian</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.id}>
                  <td>{item.studentName}</td>
                  <td>{item.topic}</td>
                  <td>{item.source}</td>
                  <td>{item.status}</td>
                  <td>{item.savedToNotebook ? 'Có' : 'Không'}</td>
                  <td>{item.createdAt}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </div>
  );
}
