import { useEffect, useState } from 'react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as mockAdminApi from '../api/mockAdmin.js';

export default function AssessmentAdminPage() {
  const [items, setItems] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      setLoading(true);
      try {
        setItems(await mockAdminApi.getMockAssessments());
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
        title="Đánh giá đầu vào"
        subtitle="Quản lý kết quả assessment, mục tiêu trường và lịch học"
      />
      {error && <Alert>{error}</Alert>}

      <section className="panel">
        <h2>Hồ sơ assessment</h2>
        <p className="muted">
          Mobile hiện đang dùng mock/local data cho assessment, nên admin cũng
          dùng mock API đến khi backend có endpoint chính thức.
        </p>
        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Học viên</th>
                <th>Trường mục tiêu</th>
                <th>Điểm mục tiêu</th>
                <th>Trình độ</th>
                <th>Lịch học</th>
                <th>Ngày hoàn tất</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.id}>
                  <td>{item.studentName}</td>
                  <td>{item.targetUniversity}</td>
                  <td>{item.targetScore}</td>
                  <td>{item.currentLevel}</td>
                  <td>{item.studyDays}</td>
                  <td>{item.completedAt}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </div>
  );
}
