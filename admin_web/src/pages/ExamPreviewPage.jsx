import { useEffect, useMemo, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { ArrowLeft, FileQuestion, Settings } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import MathText from '../components/MathText.jsx';
import * as examsApi from '../api/exams.js';
import { readStoredExamQuestions } from '../utils/examStorage.js';
import { resolveAssetUrl } from '../utils/assets.js';

const optionLabels = ['A', 'B', 'C', 'D'];

function extractList(data) {
  if (Array.isArray(data)) return data;
  if (Array.isArray(data?.content)) return data.content;
  if (Array.isArray(data?.data)) return data.data;
  if (Array.isArray(data?.items)) return data.items;
  return [];
}

function sortQuestions(questions) {
  return [...questions].sort(
    (a, b) => Number(a.orderIndex || 0) - Number(b.orderIndex || 0),
  );
}

function questionImageUrl(question) {
  return resolveAssetUrl(question.imageUrl || question.image || question.mediaUrl || '');
}

function questionTypeLabel(type) {
  if (type === 'MULTIPLE_CHOICE') return 'Trắc nghiệm';
  if (type === 'TRUE_FALSE') return 'Đúng/Sai';
  if (type === 'SHORT_ANSWER') return 'Tự luận ngắn';
  return type || 'Câu hỏi';
}

function formatScore(value) {
  const rounded = Math.round(Number(value || 0) * 100) / 100;
  return Number.isInteger(rounded) ? String(rounded) : rounded.toFixed(2);
}

export default function ExamPreviewPage() {
  const { id: examId } = useParams();
  const [exam, setExam] = useState(null);
  const [questions, setQuestions] = useState(() =>
    sortQuestions(readStoredExamQuestions(examId)),
  );
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    let mounted = true;

    async function load() {
      setLoading(true);
      setError('');

      try {
        const detail = await examsApi.getExam(examId);
        if (!mounted) return;
        setExam((current) => detail || current);
        const detailQuestions = extractList(detail?.questions);
        if (detailQuestions.length > 0) {
          setQuestions(sortQuestions(detailQuestions));
          return;
        }
      } catch {
        // Endpoint chi tiết đề thi chưa có trong OpenAPI, nên bỏ qua nếu backend không hỗ trợ.
      }

      try {
        const apiQuestions = extractList(await examsApi.getExamQuestions(examId));
        if (mounted && apiQuestions.length > 0) {
          setQuestions(sortQuestions(apiQuestions));
        }
      } catch {
        // Endpoint danh sách câu hỏi theo đề cũng chưa có trong OpenAPI.
      } finally {
        if (mounted) setLoading(false);
      }
    }

    load();
    return () => {
      mounted = false;
    };
  }, [examId]);

  const title = exam?.title || 'Đề thi';
  const totalScore = useMemo(
    () => questions.reduce((sum, question) => sum + Number(question.score || 0), 0),
    [questions],
  );
  const scoreIsComplete = Math.abs(totalScore - 10) < 0.001;
  const subtitle = useMemo(() => {
    const parts = [
      exam?.subject,
      exam?.durationMinutes ? `${exam.durationMinutes} phút` : '',
      exam?.totalQuestions ? `${exam.totalQuestions} câu` : '',
    ].filter(Boolean);
    return parts.length > 0 ? parts.join(' / ') : `Exam ID: ${examId}`;
  }, [exam, examId]);

  return (
    <div>
      <Link to="/exams" className="back-link">
        <ArrowLeft size={16} /> Danh sách đề thi
      </Link>
      <PageHeader
        title={title}
        subtitle={subtitle}
        action={
          <Link to={`/exams/${examId}/manage`} className="btn btn-primary">
            <Settings size={16} /> Quản lý câu hỏi
          </Link>
        }
      />

      {error && <Alert>{error}</Alert>}

      {!loading && questions.length > 0 && (
        <section
          className={`panel exam-score-panel ${
            scoreIsComplete ? 'is-complete' : 'is-incomplete'
          }`}
        >
          <div>
            <span className="stat-label">Tổng điểm đề thi</span>
            <strong>{formatScore(totalScore)} / 10</strong>
          </div>
          {!scoreIsComplete && (
            <p>
              Tổng điểm chưa đủ 10. Admin cần kiểm tra lại điểm từng câu trước
              khi xuất bản đề.
            </p>
          )}
        </section>
      )}

      {loading ? (
        <section className="panel">
          <p className="muted">Đang tải đề thi...</p>
        </section>
      ) : questions.length === 0 ? (
        <section className="panel empty-exam-panel">
          <FileQuestion size={36} />
          <h2>Chưa có câu hỏi để hiển thị</h2>
          <p className="muted">
            Hãy vào mục Quản lý câu hỏi để thêm câu hỏi. Các câu hỏi vừa tạo
            trong admin sẽ được hiển thị tại màn hình này.
          </p>
          <Link to={`/exams/${examId}/manage`} className="btn btn-primary">
            Quản lý câu hỏi
          </Link>
        </section>
      ) : (
        <div className="exam-preview-list">
          {questions.map((question, index) => (
            <section key={question.id || `${question.orderIndex}-${index}`} className="exam-question-card">
              <div className="question-badge">Câu {index + 1}</div>
              <div className="question-divider" />
              <MathText as="div" className="question-content">
                {question.content}
              </MathText>
              {questionImageUrl(question) && (
                <img
                  src={questionImageUrl(question)}
                  alt={`Hình minh họa câu ${index + 1}`}
                  className="question-image"
                />
              )}
              {question.options?.length > 0 && (
                <div className="answer-list">
                  {question.options.map((option, optionIndex) => (
                    <div
                      key={option.id || option.orderIndex || optionIndex}
                      className={`answer-item ${option.correct ? 'is-correct' : ''}`}
                    >
                      <span className="answer-prefix">
                        {question.questionType === 'TRUE_FALSE'
                          ? option.correct
                            ? 'Đúng'
                            : 'Sai'
                          : optionLabels[optionIndex] || optionIndex + 1}
                      </span>
                      <MathText>{option.content}</MathText>
                    </div>
                  ))}
                </div>
              )}
              {question.questionType === 'SHORT_ANSWER' && question.correctAnswer && (
                <div className="answer-item is-correct short-answer-preview">
                  <span className="answer-prefix">Đáp án</span>
                  <MathText>{question.correctAnswer}</MathText>
                </div>
              )}
              <p className="question-meta">
                {questionTypeLabel(question.questionType)}
                {question.score ? ` / ${question.score} điểm` : ''}
              </p>
            </section>
          ))}
        </div>
      )}
    </div>
  );
}
