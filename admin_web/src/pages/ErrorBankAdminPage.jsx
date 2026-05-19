import { useEffect, useState } from 'react';
import { RotateCcw } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as mockAdminApi from '../api/mockAdmin.js';

export default function ErrorBankAdminPage() {
  const [items, setItems] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      setLoading(true);
      try {
        setItems(await mockAdminApi.getMockErrorBank());
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
        title="Lỗi sai học viên"
        subtitle="Theo dõi ngân hàng lỗi sai và lịch ôn tập đến hạn"
      />
      {error && <Alert>{error}</Alert>}

      <section className="panel">
        <div className="panel-head">
          <h2>Danh sách lỗi sai</h2>
          <button type="button" className="btn btn-ghost btn-sm">
            <RotateCcw size={14} /> Tải lại
          </button>
        </div>
        <p className="muted">
          Dữ liệu đang dùng mock API vì backend hiện chỉ có API lỗi sai cho học
          viên đang đăng nhập.
        </p>
        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Học viên</th>
                <th>Môn</th>
                <th>Câu hỏi</th>
                <th>Số lần sai</th>
                <th>Đến hạn</th>
                <th>Chất lượng gần nhất</th>
                <th>Trạng thái</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.id}>
                  <td>{item.studentName}</td>
                  <td>{item.subject}</td>
                  <td>{item.question}</td>
                  <td>{item.wrongCount}</td>
                  <td>{item.dueAt}</td>
                  <td>{item.lastQuality}/5</td>
                  <td>
                    <span className="status-pill warning">{item.status}</span>
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
