import { useEffect, useState } from 'react';
import { Award, Plus, Trash2 } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as mockAdminApi from '../api/mockAdmin.js';

const emptyForm = {
  studentName: '',
  badgeName: '',
  badgeCode: '',
  imageUrl: '',
  xpReward: 10,
};

export default function UserBadgesPage() {
  const [items, setItems] = useState([]);
  const [form, setForm] = useState(emptyForm);
  const [error, setError] = useState('');
  const [message, setMessage] = useState('');
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    try {
      setItems(await mockAdminApi.getMockAwardedBadges());
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
  }, []);

  async function awardBadge(e) {
    e.preventDefault();
    setError('');
    setMessage('');
    try {
      await mockAdminApi.awardMockBadge({
        ...form,
        xpReward: Number(form.xpReward),
      });
      setForm(emptyForm);
      setMessage('Đã trao huy hiệu cho học viên.');
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  async function revokeBadge(id) {
    await mockAdminApi.revokeMockBadge(id);
    await load();
  }

  return (
    <div>
      <PageHeader
        title="Huy hiệu học viên"
        subtitle="Theo dõi, trao và thu hồi huy hiệu đã cấp cho học viên"
      />
      {error && <Alert>{error}</Alert>}
      {message && <div className="alert alert-success">{message}</div>}

      <section className="panel">
        <h2>Trao huy hiệu</h2>
        <p className="muted">Biểu mẫu này đang dùng mock API.</p>
        <form className="form-grid" onSubmit={awardBadge}>
          <label>
            Học viên
            <input
              value={form.studentName}
              onChange={(e) => setForm({ ...form, studentName: e.target.value })}
              required
            />
          </label>
          <label>
            Tên huy hiệu
            <input
              value={form.badgeName}
              onChange={(e) => setForm({ ...form, badgeName: e.target.value })}
              required
            />
          </label>
          <label>
            Mã huy hiệu
            <input
              value={form.badgeCode}
              onChange={(e) => setForm({ ...form, badgeCode: e.target.value })}
              required
            />
          </label>
          <label>
            XP thưởng
            <input
              type="number"
              min={0}
              value={form.xpReward}
              onChange={(e) => setForm({ ...form, xpReward: e.target.value })}
              required
            />
          </label>
          <label className="span-2">
            Ảnh huy hiệu
            <input
              value={form.imageUrl}
              onChange={(e) => setForm({ ...form, imageUrl: e.target.value })}
              placeholder="URL ảnh"
            />
          </label>
          <div className="form-actions span-2">
            <button type="submit" className="btn btn-primary">
              <Plus size={16} /> Trao huy hiệu
            </button>
          </div>
        </form>
      </section>

      <section className="panel">
        <h2>Huy hiệu đã trao</h2>
        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Ảnh</th>
                <th>Học viên</th>
                <th>Huy hiệu</th>
                <th>Mã</th>
                <th>XP</th>
                <th>Ngày nhận</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.id}>
                  <td>
                    <div className="badge-thumb">
                      {item.imageUrl ? (
                        <img src={item.imageUrl} alt={item.badgeName} />
                      ) : (
                        <Award size={22} />
                      )}
                    </div>
                  </td>
                  <td>{item.studentName}</td>
                  <td>{item.badgeName}</td>
                  <td>{item.badgeCode}</td>
                  <td>{item.xpReward}</td>
                  <td>{item.earnedAt}</td>
                  <td className="actions-cell">
                    <button
                      type="button"
                      className="btn-icon danger"
                      onClick={() => revokeBadge(item.id)}
                      title="Thu hồi"
                    >
                      <Trash2 size={16} />
                    </button>
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
