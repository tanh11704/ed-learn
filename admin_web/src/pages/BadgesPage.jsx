import { useEffect, useState } from 'react';
import { Award, Plus, Pencil, Trash2 } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as badgesApi from '../api/badges.js';

const emptyForm = {
  code: '',
  name: '',
  description: '',
  category: 'STREAK',
  imageUrl: '',
  xpReward: 10,
};

function getBadgeImageUrl(badge) {
  return badge.imageUrl || badge.iconUrl || badge.thumbnailUrl || '';
}

export default function BadgesPage() {
  const [badges, setBadges] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [form, setForm] = useState(emptyForm);

  async function load() {
    setLoading(true);
    setError('');
    try {
      const data = await badgesApi.getBadges({ page: 0, size: 50 });
      setBadges(data.content || []);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
  }, []);

  function openCreate() {
    setEditingId(null);
    setForm(emptyForm);
    setShowForm(true);
  }

  function openEdit(badge) {
    setEditingId(badge.id);
    setForm({
      code: badge.code || '',
      name: badge.name || '',
      description: badge.description || '',
      category: badge.category || 'STREAK',
      imageUrl: badge.imageUrl || '',
      xpReward: badge.xpReward ?? 10,
    });
    setShowForm(true);
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    try {
      const body = { ...form, xpReward: Number(form.xpReward) };
      if (editingId) {
        await badgesApi.updateBadge(editingId, body);
      } else {
        await badgesApi.createBadge(body);
      }
      setShowForm(false);
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  async function handleDelete(id) {
    if (!confirm('Xóa huy hiệu này?')) return;
    try {
      await badgesApi.deleteBadge(id);
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <div>
      <PageHeader
        title="Huy hiệu"
        subtitle="CRUD /admin/badges"
        action={
          <button type="button" className="btn btn-primary" onClick={openCreate}>
            <Plus size={16} /> Tạo huy hiệu
          </button>
        }
      />
      {error && <Alert>{error}</Alert>}

      {showForm && (
        <form className="panel form-panel" onSubmit={handleSubmit}>
          <h2>{editingId ? 'Sửa huy hiệu' : 'Tạo huy hiệu'}</h2>
          <div className="form-grid">
            <label>
              Mã
              <input
                value={form.code}
                onChange={(e) => setForm({ ...form, code: e.target.value })}
                required
              />
            </label>
            <label>
              Tên
              <input
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                required
              />
            </label>
            <label>
              Loại
              <select
                value={form.category}
                onChange={(e) =>
                  setForm({ ...form, category: e.target.value })
                }
              >
                <option value="STREAK">STREAK</option>
                <option value="SOCIAL">SOCIAL</option>
              </select>
            </label>
            <label>
              XP thưởng
              <input
                type="number"
                min={0}
                value={form.xpReward}
                onChange={(e) =>
                  setForm({ ...form, xpReward: e.target.value })
                }
                required
              />
            </label>
            <label className="span-2">
              Mô tả
              <textarea
                value={form.description}
                onChange={(e) =>
                  setForm({ ...form, description: e.target.value })
                }
                rows={2}
              />
            </label>
            <label className="span-2">
              Image URL
              <input
                value={form.imageUrl}
                onChange={(e) =>
                  setForm({ ...form, imageUrl: e.target.value })
                }
              />
            </label>
          </div>
          <div className="form-actions">
            <button type="submit" className="btn btn-primary">
              Lưu
            </button>
            <button
              type="button"
              className="btn btn-ghost"
              onClick={() => setShowForm(false)}
            >
              Hủy
            </button>
          </div>
        </form>
      )}

      <section className="panel">
        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : badges.length === 0 ? (
          <p className="muted">Chưa có huy hiệu</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Ảnh</th>
                <th>Mã</th>
                <th>Tên</th>
                <th>Loại</th>
                <th>XP</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {badges.map((b) => (
                <tr key={b.id}>
                  <td>
                    <div className="badge-thumb">
                      {getBadgeImageUrl(b) ? (
                        <img src={getBadgeImageUrl(b)} alt={b.name || b.code} />
                      ) : (
                        <Award size={22} />
                      )}
                    </div>
                  </td>
                  <td>{b.code}</td>
                  <td>{b.name}</td>
                  <td>{b.category}</td>
                  <td>{b.xpReward}</td>
                  <td className="actions-cell">
                    <button
                      type="button"
                      className="btn-icon"
                      onClick={() => openEdit(b)}
                    >
                      <Pencil size={16} />
                    </button>
                    <button
                      type="button"
                      className="btn-icon danger"
                      onClick={() => handleDelete(b.id)}
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
