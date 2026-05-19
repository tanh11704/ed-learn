import { useEffect, useState } from 'react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as mockAdminApi from '../api/mockAdmin.js';

export default function StreakTasksPage() {
  const [items, setItems] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      setLoading(true);
      try {
        setItems(await mockAdminApi.getMockStreakTasks());
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
        title="Streak và nhiệm vụ"
        subtitle="Theo dõi chuỗi học tập, freeze và nhiệm vụ ngày của học viên"
      />
      {error && <Alert>{error}</Alert>}

      <section className="panel">
        <h2>Theo dõi hôm nay</h2>
        <p className="muted">
          Dữ liệu đang dùng mock API vì backend hiện chỉ có API streak/nhiệm vụ
          cho chính học viên đang đăng nhập.
        </p>
        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Học viên</th>
                <th>Streak hiện tại</th>
                <th>Dài nhất</th>
                <th>Freeze</th>
                <th>Nhiệm vụ hôm nay</th>
                <th>Hoạt động gần nhất</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.id}>
                  <td>{item.studentName}</td>
                  <td>{item.currentStreak} ngày</td>
                  <td>{item.longestStreak} ngày</td>
                  <td>{item.freezeCount}</td>
                  <td>
                    {item.tasksDoneToday}/{item.tasksTotalToday}
                  </td>
                  <td>{item.lastActiveDate}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </div>
  );
}
