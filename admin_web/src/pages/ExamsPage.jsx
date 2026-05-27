import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { HelpCircle, Pencil, Plus, Send, Trash2 } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as examsApi from '../api/exams.js';

const emptyForm = {
  title: '',
  subject: '',
  schoolYear: new Date().getFullYear(),
  durationMinutes: 60,
  totalQuestions: 10,
  description: '',
};

export default function ExamsPage() {
  const [exams, setExams] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [form, setForm] = useState(emptyForm);
  const [statusFilter, setStatusFilter] = useState('ACTIVE');

  async function load() {
    setLoading(true);
    setError('');
    try {
      const data = await examsApi.getExams({ status: statusFilter });
      setExams(Array.isArray(data) ? data : []);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
  }, [statusFilter]);

  function openCreate() {
    setEditingId(null);
    setForm(emptyForm);
    setShowForm(true);
  }

  function openEdit(exam) {
    setEditingId(exam.id);
    setForm({
      title: exam.title || '',
      subject: exam.subject || '',
      schoolYear: exam.schoolYear || new Date().getFullYear(),
      durationMinutes: exam.durationMinutes || 60,
      totalQuestions: exam.totalQuestions || 10,
      description: exam.description || '',
    });
    setShowForm(true);
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    const body = {
      ...form,
      schoolYear: Number(form.schoolYear),
      durationMinutes: Number(form.durationMinutes),
      totalQuestions: Number(form.totalQuestions),
    };
    try {
      if (editingId) {
        await examsApi.updateExam(editingId, body);
      } else {
        await examsApi.createExam(body);
      }
      setShowForm(false);
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  async function handleDelete(id) {
    if (!confirm('Xóa đề thi này?')) return;
    try {
      await examsApi.deleteExam(id);
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  async function handlePublish(exam) {
    if (!confirm('Xuất bản đề thi này? Học sinh sẽ có thể bắt đầu làm đề.')) {
      return;
    }

    setError('');
    try {
      await examsApi.updateExam(exam.id, {
        title: exam.title,
        subject: exam.subject,
        schoolYear: Number(exam.schoolYear),
        durationMinutes: Number(exam.durationMinutes),
        totalQuestions: Number(exam.totalQuestions),
        description: exam.description || '',
        status: 'PUBLISHED',
      });
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <div>
      <PageHeader
        title="Đề thi"
        subtitle="Tạo đề thi và quản lý câu hỏi"
        action={
          <button type="button" className="btn btn-primary" onClick={openCreate}>
            <Plus size={16} /> Tạo đề thi
          </button>
        }
      />
      {error && <Alert>{error}</Alert>}

      <section className="panel">
        <h2>Hướng dẫn</h2>
        <p className="muted">
          Sau khi tạo đề thi, đề sẽ xuất hiện trong bảng bên dưới. Bấm vào tên
          đề để xem giao diện đề thi, hoặc bấm “Quản lý câu hỏi” để thêm câu hỏi
          và đáp án.
        </p>
        <p className="muted">
          Chức năng làm thử đề thi hiện chưa có API riêng trong admin web. Mobile
          app có màn Thư viện đề thi, nhưng API làm bài/session chưa xuất hiện
          đầy đủ trong OpenAPI production.
        </p>
      </section>

      {showForm && (
        <form className="panel form-panel" onSubmit={handleSubmit}>
          <h2>{editingId ? 'Sửa đề thi' : 'Tạo đề thi mới'}</h2>
          <div className="form-grid">
            <label>
              Tên đề
              <input
                value={form.title}
                onChange={(e) => setForm({ ...form, title: e.target.value })}
                required
              />
            </label>
            <label>
              Môn
              <input
                value={form.subject}
                onChange={(e) => setForm({ ...form, subject: e.target.value })}
                required
              />
            </label>
            <label>
              Năm học
              <input
                type="number"
                value={form.schoolYear}
                onChange={(e) =>
                  setForm({ ...form, schoolYear: e.target.value })
                }
                required
              />
            </label>
            <label>
              Thời gian (phút)
              <input
                type="number"
                min={1}
                value={form.durationMinutes}
                onChange={(e) =>
                  setForm({ ...form, durationMinutes: e.target.value })
                }
                required
              />
            </label>
            <label>
              Số câu
              <input
                type="number"
                min={0}
                value={form.totalQuestions}
                onChange={(e) =>
                  setForm({ ...form, totalQuestions: e.target.value })
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
        <div className="table-toolbar">
          <label className="field-label">
            Trạng thái đề thi
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
            >
              <option value="ACTIVE">Tất cả đề chưa lưu trữ</option>
              <option value="DRAFT">Bản nháp</option>
              <option value="PUBLISHED">Đã xuất bản</option>
              <option value="ARCHIVED">Đã xóa / lưu trữ</option>
            </select>
          </label>
        </div>
        {loading ? (
          <p className="muted">Đang tải...</p>
        ) : exams.length === 0 ? (
          <p className="muted">Chưa có đề thi</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Tên đề</th>
                <th>Môn</th>
                <th>Thời gian</th>
                <th>Trạng thái</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {exams.map((exam) => (
                <tr key={exam.id}>
                  <td>
                    <Link to={`/exams/${exam.id}`} className="link">
                      {exam.title}
                    </Link>
                  </td>
                  <td>{exam.subject}</td>
                  <td>{exam.durationMinutes} phút</td>
                  <td>{exam.status || '-'}</td>
                  <td className="actions-cell">
                    <Link
                      to={`/exams/${exam.id}/manage`}
                      className="btn btn-ghost btn-sm"
                      title="Quản lý câu hỏi"
                    >
                      <HelpCircle size={14} /> Quản lý câu hỏi
                    </Link>
                    {exam.status === 'DRAFT' && (
                      <button
                        type="button"
                        className="btn btn-primary btn-sm"
                        onClick={() => handlePublish(exam)}
                        title="Xuất bản đề thi"
                      >
                        <Send size={14} /> Xuất bản
                      </button>
                    )}
                    <button
                      type="button"
                      className="btn-icon"
                      onClick={() => openEdit(exam)}
                      title="Sửa"
                    >
                      <Pencil size={16} />
                    </button>
                    <button
                      type="button"
                      className="btn-icon danger"
                      onClick={() => handleDelete(exam.id)}
                      title="Xóa"
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
