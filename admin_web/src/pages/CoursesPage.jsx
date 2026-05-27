import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { BookOpen, ImagePlus, Plus, Pencil, Trash2 } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as coursesApi from '../api/courses.js';
import { resolveAssetUrl } from '../utils/assets.js';

const DEFAULT_COURSE_THUMBNAIL_URL =
  'https://i.pinimg.com/736x/b6/de/f7/b6def776cbfebaa567515710933e1e93.jpg';

const emptyForm = {
  title: '',
  description: '',
  subject: '',
  thumbnailUrl: '',
  thumbnailFile: null,
};

export default function CoursesPage() {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [form, setForm] = useState(emptyForm);
  const [thumbnailPreview, setThumbnailPreview] = useState('');
  const [statusFilter, setStatusFilter] = useState('ACTIVE');

  async function load() {
    setLoading(true);
    setError('');
    try {
      const data = await coursesApi.getCourses({
        page: 0,
        size: 50,
        status: statusFilter,
      });
      setCourses(data.content || []);
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
    setThumbnailPreview('');
    setShowForm(true);
  }

  function openEdit(course) {
    setEditingId(course.id);
    setForm({
      title: course.title || '',
      description: course.description || '',
      subject: course.subject || '',
      thumbnailUrl: course.thumbnailUrl || '',
      thumbnailFile: null,
    });
    setThumbnailPreview(resolveAssetUrl(course.thumbnailUrl) || DEFAULT_COURSE_THUMBNAIL_URL);
    setShowForm(true);
  }

  function handleThumbnailChange(e) {
    const file = e.target.files?.[0] || null;
    setForm({ ...form, thumbnailFile: file });
    setThumbnailPreview(
      file
        ? URL.createObjectURL(file)
        : resolveAssetUrl(form.thumbnailUrl) || DEFAULT_COURSE_THUMBNAIL_URL,
    );
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    try {
      if (editingId) {
        await coursesApi.updateCourse(editingId, form);
      } else {
        await coursesApi.createCourse(form);
      }
      setShowForm(false);
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  async function handleDelete(id) {
    if (!confirm('Xóa khóa học này?')) return;
    try {
      await coursesApi.deleteCourse(id);
      await load();
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <div>
      <PageHeader
        title="Khóa học"
        subtitle="CRUD qua /courses/admin"
        action={
          <button type="button" className="btn btn-primary" onClick={openCreate}>
            <Plus size={16} /> Tạo khóa học
          </button>
        }
      />
      {error && <Alert>{error}</Alert>}

      <section className="panel">
        <label className="field-label">
          Trạng thái
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
          >
            <option value="ACTIVE">Đang hoạt động</option>
            <option value="DELETED">Đã xóa</option>
            <option value="ALL">Tất cả</option>
          </select>
        </label>
      </section>

      {showForm && (
        <form className="panel form-panel" onSubmit={handleSubmit}>
          <h2>{editingId ? 'Sửa khóa học' : 'Tạo khóa học mới'}</h2>
          <div className="form-grid">
            <label>
              Tiêu đề
              <input
                value={form.title}
                onChange={(e) => setForm({ ...form, title: e.target.value })}
                required
              />
            </label>
            <label>
              Chủ đề
              <input
                value={form.subject}
                onChange={(e) => setForm({ ...form, subject: e.target.value })}
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
                required
                rows={3}
              />
            </label>
            <label className="span-2">
              Ảnh đại diện
              <input
                type="file"
                accept="image/*"
                onChange={handleThumbnailChange}
              />
            </label>
            {thumbnailPreview && (
              <div className="span-2 course-thumbnail-preview">
                <img src={thumbnailPreview} alt={form.title || 'Ảnh khóa học'} />
                <span>
                  <ImagePlus size={14} />
                  {form.thumbnailFile ? form.thumbnailFile.name : 'Ảnh hiện tại'}
                </span>
              </div>
            )}
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
        ) : courses.length === 0 ? (
          <p className="muted">Chưa có khóa học</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Tiêu đề</th>
                <th>Chủ đề</th>
                <th>Trạng thái</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {courses.map((c) => (
                <tr key={c.id}>
                  <td>
                    <Link to={`/courses/${c.id}`} className="link">
                      {c.title}
                    </Link>
                  </td>
                  <td>{c.subject}</td>
                  <td>
                    <span className={`status-pill ${c.isDeleted ? 'danger' : 'success'}`}>
                      {c.isDeleted ? 'Đã xóa' : 'Đang hoạt động'}
                    </span>
                  </td>
                  <td className="actions-cell">
                    <Link
                      to={`/courses/${c.id}/manage`}
                      className="btn btn-ghost btn-sm"
                      title="Quản lý nội dung"
                    >
                      <BookOpen size={14} /> Nội dung
                    </Link>
                    <button
                      type="button"
                      className="btn-icon"
                      onClick={() => openEdit(c)}
                      title="Sửa"
                    >
                      <Pencil size={16} />
                    </button>
                    <button
                      type="button"
                      className="btn-icon danger"
                      onClick={() => handleDelete(c.id)}
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
