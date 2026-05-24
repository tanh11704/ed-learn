import { useEffect, useMemo, useState } from 'react';
import {
  BarChart3,
  CalendarClock,
  CheckCircle2,
  FileText,
  Search,
  Trophy,
  Users,
} from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as examAttemptsApi from '../api/examAttempts.js';
import * as examsApi from '../api/exams.js';

const statusMeta = {
  IN_PROGRESS: { label: 'Đang làm', className: 'warning' },
  SUBMITTED: { label: 'Đã nộp', className: 'success' },
  GRADED: { label: 'Đã chấm', className: 'success' },
};

function formatDateTime(value) {
  if (!value) return 'Chưa có';
  return new Intl.DateTimeFormat('vi-VN', {
    dateStyle: 'short',
    timeStyle: 'short',
  }).format(new Date(value));
}

function formatScore(value) {
  return value === null || value === undefined ? '-' : value.toFixed(2);
}

function formatDuration(seconds) {
  if (!seconds) return '-';
  const minutes = Math.floor(seconds / 60);
  const remainSeconds = seconds % 60;
  return `${minutes}p ${remainSeconds}s`;
}

export default function ExamSessionsPage() {
  const [exams, setExams] = useState([]);
  const [selectedExam, setSelectedExam] = useState(null);
  const [summary, setSummary] = useState(null);
  const [students, setStudents] = useState([]);
  const [byGrade, setByGrade] = useState([]);
  const [query, setQuery] = useState('');
  const [error, setError] = useState('');
  const [loadingExams, setLoadingExams] = useState(true);
  const [loadingStats, setLoadingStats] = useState(false);

  useEffect(() => {
    async function loadExams() {
      setLoadingExams(true);
      setError('');
      try {
        const data = await examsApi.getExams();
        setExams(Array.isArray(data) ? data : []);
      } catch (err) {
        setExams([]);
        setError(err.message);
      } finally {
        setLoadingExams(false);
      }
    }
    loadExams();
  }, []);

  async function handleSelectExam(exam) {
    setSelectedExam(exam);
    setSummary(null);
    setStudents([]);
    setByGrade([]);
    setQuery('');
    setLoadingStats(true);
    setError('');
    try {
      const [summaryData, studentData, gradeData] = await Promise.all([
        examAttemptsApi.getExamAttemptSummary(exam.id),
        examAttemptsApi.getExamAttemptStudents(exam.id),
        examAttemptsApi.getExamAttemptsByGrade(exam.id),
      ]);
      setSummary(summaryData);
      setStudents(Array.isArray(studentData) ? studentData : []);
      setByGrade(Array.isArray(gradeData) ? gradeData : []);
    } catch (err) {
      setSummary(null);
      setStudents([]);
      setByGrade([]);
      setError(err.message);
    } finally {
      setLoadingStats(false);
    }
  }

  const filteredStudents = useMemo(() => {
    const keyword = query.trim().toLowerCase();
    if (!keyword) return students;
    return students.filter(
      (item) =>
        item.studentName?.toLowerCase().includes(keyword) ||
        item.email?.toLowerCase().includes(keyword) ||
        item.className?.toLowerCase().includes(keyword),
    );
  }, [query, students]);

  const statCards = [
    {
      label: 'Lượt làm',
      value: summary?.attemptCount ?? 0,
      icon: Users,
    },
    {
      label: 'Đã nộp',
      value: summary?.submittedCount ?? 0,
      icon: CheckCircle2,
    },
    {
      label: 'Điểm trung bình',
      value: formatScore(summary?.averageScore),
      icon: BarChart3,
    },
    {
      label: 'Điểm cao nhất',
      value: formatScore(summary?.highestScore),
      icon: Trophy,
    },
  ];

  return (
    <div>
      <PageHeader
        title="Lượt làm đề"
        subtitle="Chọn một đề thi để xem thống kê làm bài và kết quả của học viên"
      />
      {error && <Alert>{error}</Alert>}

      <section className="panel">
        <div className="panel-head">
          <div>
            <h2>Danh sách đề thi</h2>
            <p className="muted panel-note">
              Admin chọn đề thi trước khi xem thống kê lượt làm.
            </p>
          </div>
        </div>

        {loadingExams ? (
          <p className="muted">Đang tải đề thi...</p>
        ) : exams.length === 0 ? (
          <p className="muted">Chưa có đề thi.</p>
        ) : (
          <div className="exam-picker-grid">
            {exams.map((exam) => (
              <button
                key={exam.id}
                type="button"
                className={`exam-picker-card${
                  selectedExam?.id === exam.id ? ' active' : ''
                }`}
                onClick={() => handleSelectExam(exam)}
              >
                <FileText size={18} />
                <strong>{exam.title}</strong>
                <span>
                  {exam.subject} · {exam.schoolYear}
                </span>
                <span className="table-subtext">
                  {exam.totalQuestions} câu · {exam.durationMinutes} phút
                </span>
                <span
                  className={`status-pill ${
                    exam.status === 'PUBLISHED' ? 'success' : 'warning'
                  }`}
                >
                  {exam.status}
                </span>
              </button>
            ))}
          </div>
        )}
      </section>

      {selectedExam && (
        <div className="stat-grid">
          {statCards.map(({ label, value, icon: Icon }) => (
            <div key={label} className="stat-card">
              <span className="stat-label progress-stat-label">
                <Icon size={17} />
                {label}
              </span>
              <span className="stat-value">
                {loadingStats ? '...' : value}
              </span>
            </div>
          ))}
        </div>
      )}

      <div className="panel-grid">
        <section className="panel">
          <div className="panel-head">
            <div>
              <h2>
                {selectedExam
                  ? `Kết quả học viên: ${selectedExam.title}`
                  : 'Kết quả học viên'}
              </h2>
              <p className="muted panel-note">
                {selectedExam
                  ? 'Danh sách lượt làm đề của học viên trong đề đã chọn.'
                  : 'Chọn một đề thi ở phía trên để xem kết quả học viên.'}
              </p>
            </div>
            {selectedExam && (
              <label className="search-box">
                <Search size={16} />
                <input
                  value={query}
                  onChange={(e) => setQuery(e.target.value)}
                  placeholder="Tìm học viên, email hoặc lớp"
                />
              </label>
            )}
          </div>

          {!selectedExam ? (
            <div className="empty-state">
              <FileText size={32} />
              <h3>Chưa chọn đề thi</h3>
              <p className="muted">
                Thống kê sẽ xuất hiện sau khi admin chọn một đề thi.
              </p>
            </div>
          ) : loadingStats ? (
            <p className="muted">Đang tải thống kê...</p>
          ) : filteredStudents.length === 0 ? (
            <div className="empty-state">
              <CalendarClock size={32} />
              <h3>Chưa có lượt làm phù hợp</h3>
              <p className="muted">
                Đề này chưa có học viên làm bài hoặc bộ lọc không có kết quả.
              </p>
            </div>
          ) : (
            <table className="data-table exam-session-table">
              <thead>
                <tr>
                  <th>Học viên</th>
                  <th>Lớp</th>
                  <th>Điểm</th>
                  <th>Thời lượng</th>
                  <th>Bắt đầu</th>
                  <th>Nộp bài</th>
                  <th>Trạng thái</th>
                </tr>
              </thead>
              <tbody>
                {filteredStudents.map((item) => (
                  <tr key={item.attemptId}>
                    <td>
                      <strong>{item.studentName}</strong>
                      <span className="table-subtext">{item.email}</span>
                    </td>
                    <td>
                      {item.gradeLevel}
                      {item.className ? ` - ${item.className}` : ''}
                    </td>
                    <td>
                      {formatScore(item.score)}/{formatScore(item.maxScore)}
                    </td>
                    <td>{formatDuration(item.durationSeconds)}</td>
                    <td>{formatDateTime(item.startedAt)}</td>
                    <td>{formatDateTime(item.submittedAt)}</td>
                    <td>
                      <span
                        className={`status-pill ${
                          statusMeta[item.status]?.className || ''
                        }`}
                      >
                        {statusMeta[item.status]?.label || item.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </section>

        {selectedExam && (
          <section className="panel">
            <h2>Thống kê theo lớp</h2>
            {loadingStats ? (
              <p className="muted">Đang tải...</p>
            ) : byGrade.length === 0 ? (
              <p className="muted">Chưa có dữ liệu theo lớp.</p>
            ) : (
              <table className="data-table compact-table">
                <thead>
                  <tr>
                    <th>Lớp</th>
                    <th>Lượt làm</th>
                    <th>Đã nộp</th>
                    <th>Điểm TB</th>
                  </tr>
                </thead>
                <tbody>
                  {byGrade.map((item) => (
                    <tr key={item.gradeLevel ?? 'unknown'}>
                      <td>{item.gradeLevel || '-'}</td>
                      <td>{item.attemptCount}</td>
                      <td>{item.submittedCount}</td>
                      <td>{formatScore(item.averageScore)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </section>
        )}
      </div>
    </div>
  );
}
