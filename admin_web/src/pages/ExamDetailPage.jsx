import { useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { ArrowLeft } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import * as examsApi from '../api/exams.js';
import {
  readStoredExamQuestions,
  writeStoredExamQuestions,
} from '../utils/examStorage.js';

const multipleChoiceOptions = [
  { content: '', correct: true, orderIndex: 1 },
  { content: '', correct: false, orderIndex: 2 },
  { content: '', correct: false, orderIndex: 3 },
  { content: '', correct: false, orderIndex: 4 },
];

const trueFalseOptions = [
  { content: '', correct: true, orderIndex: 1 },
  { content: '', correct: true, orderIndex: 2 },
  { content: '', correct: true, orderIndex: 3 },
  { content: '', correct: true, orderIndex: 4 },
];

export default function ExamDetailPage() {
  const { id: examId } = useParams();
  const [error, setError] = useState('');
  const [questions, setQuestions] = useState(() =>
    readStoredExamQuestions(examId),
  );
  const [questionForm, setQuestionForm] = useState({
    content: '',
    questionType: 'MULTIPLE_CHOICE',
    paperPart: 'PART_I',
    score: 0.25,
    orderIndex: 1,
    correctAnswer: '',
  });
  const [newOptions, setNewOptions] = useState(multipleChoiceOptions);
  const [trueFalseItems, setTrueFalseItems] = useState(trueFalseOptions);
  const [optionForms, setOptionForms] = useState({});

  function changeQuestionType(type) {
    setQuestionForm((form) => ({
      ...form,
      questionType: type,
      correctAnswer: '',
    }));
    setNewOptions(multipleChoiceOptions);
    setTrueFalseItems(trueFalseOptions);
  }

  function updateNewOption(index, patch) {
    setNewOptions((prev) =>
      prev.map((option, idx) =>
        idx === index ? { ...option, ...patch } : option,
      ),
    );
  }

  function setCorrectOption(index) {
    setNewOptions((prev) =>
      prev.map((option, idx) => ({ ...option, correct: idx === index })),
    );
  }

  function updateTrueFalseItem(index, patch) {
    setTrueFalseItems((prev) =>
      prev.map((item, idx) => (idx === index ? { ...item, ...patch } : item)),
    );
  }

  function buildQuestionPayload() {
    const base = {
      examId,
      questionType: questionForm.questionType,
      paperPart: questionForm.paperPart,
      content: questionForm.content,
      score: Number(questionForm.score),
      orderIndex: Number(questionForm.orderIndex),
    };

    if (questionForm.questionType === 'MULTIPLE_CHOICE') {
      const options = newOptions.map((option, index) => ({
        content: option.content.trim(),
        correct: Boolean(option.correct),
        orderIndex: index + 1,
      }));

      if (options.some((option) => !option.content)) {
        throw new Error('Câu trắc nghiệm phải có đủ 4 đáp án.');
      }
      if (options.filter((option) => option.correct).length !== 1) {
        throw new Error('Câu trắc nghiệm phải có đúng 1 đáp án đúng.');
      }

      return { ...base, options };
    }

    if (questionForm.questionType === 'TRUE_FALSE') {
      const options = trueFalseItems.map((item, index) => ({
        content: item.content.trim(),
        correct: Boolean(item.correct),
        orderIndex: index + 1,
      }));

      if (options.some((option) => !option.content)) {
        throw new Error('Câu đúng/sai phải có đủ 4 ý.');
      }

      return {
        ...base,
        options,
      };
    }

    return {
      ...base,
      correctAnswer: questionForm.correctAnswer.trim(),
      options: [],
    };
  }

  async function addQuestion(e) {
    e.preventDefault();
    setError('');
    try {
      const payload = buildQuestionPayload();
      const q = await examsApi.createQuestion(payload);
      const savedQuestion = {
        ...payload,
        ...(q || {}),
        options: q?.options || payload.options || [],
      };
      setQuestions((prev) => {
        const next = [...prev, savedQuestion];
        writeStoredExamQuestions(examId, next);
        return next;
      });
      setQuestionForm((form) => ({
        ...form,
        content: '',
        correctAnswer: '',
        orderIndex: Number(form.orderIndex) + 1,
      }));
      setNewOptions(multipleChoiceOptions);
      setTrueFalseItems(trueFalseOptions);
    } catch (err) {
      setError(err.message);
    }
  }

  async function loadOptions(questionId) {
    try {
      const opts = await examsApi.getQuestionOptions(questionId);
      setQuestions((prev) => {
        const next = prev.map((q) =>
          q.id === questionId ? { ...q, options: opts } : q,
        );
        writeStoredExamQuestions(examId, next);
        return next;
      });
    } catch (err) {
      setError(err.message);
    }
  }

  async function addOption(questionId, e) {
    e.preventDefault();
    const form = optionForms[questionId] || {
      content: '',
      correct: false,
      orderIndex: 1,
    };
    setError('');
    try {
      await examsApi.createOption(questionId, {
        ...form,
        orderIndex: Number(form.orderIndex),
      });
      setOptionForms((prev) => ({
        ...prev,
        [questionId]: { content: '', correct: false, orderIndex: 1 },
      }));
      await loadOptions(questionId);
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <div>
      <Link to="/exams" className="back-link">
        <ArrowLeft size={16} /> Danh sách đề thi
      </Link>
      <PageHeader
        title="Quản lý câu hỏi"
        subtitle={`Exam ID: ${examId}`}
        action={
          <Link to={`/exams/${examId}`} className="btn btn-ghost">
            Xem đề thi
          </Link>
        }
      />
      {error && <Alert>{error}</Alert>}

      <section className="panel">
        <h2>Thêm câu hỏi</h2>
        <form className="form-grid" onSubmit={addQuestion}>
          <label className="span-2">
            Nội dung
            <textarea
              value={questionForm.content}
              onChange={(e) =>
                setQuestionForm({ ...questionForm, content: e.target.value })
              }
              required
              rows={3}
            />
          </label>
          <label>
            Loại
            <select
              value={questionForm.questionType}
              onChange={(e) => changeQuestionType(e.target.value)}
            >
              <option value="MULTIPLE_CHOICE">Trắc nghiệm</option>
              <option value="TRUE_FALSE">Đúng/Sai</option>
              <option value="SHORT_ANSWER">Tự luận ngắn</option>
            </select>
          </label>
          <label>
            Phần đề
            <select
              value={questionForm.paperPart}
              onChange={(e) =>
                setQuestionForm({ ...questionForm, paperPart: e.target.value })
              }
            >
              <option value="PART_I">Phần I</option>
              <option value="PART_II">Phần II</option>
              <option value="PART_III">Phần III</option>
            </select>
          </label>
          <label>
            Điểm
            <input
              type="number"
              step="0.01"
              min="0.01"
              value={questionForm.score}
              onChange={(e) =>
                setQuestionForm({ ...questionForm, score: e.target.value })
              }
            />
          </label>
          <label>
            Thứ tự
            <input
              type="number"
              value={questionForm.orderIndex}
              onChange={(e) =>
                setQuestionForm({
                  ...questionForm,
                  orderIndex: e.target.value,
                })
              }
            />
          </label>

          {questionForm.questionType === 'MULTIPLE_CHOICE' && (
            <div className="span-2 option-editor">
              <h3>Đáp án trắc nghiệm</h3>
              {newOptions.map((option, index) => (
                <div key={option.orderIndex} className="option-row">
                  <label className="checkbox-label inline">
                    <input
                      type="radio"
                      name="correct-option"
                      checked={option.correct}
                      onChange={() => setCorrectOption(index)}
                    />
                    Đúng
                  </label>
                  <input
                    value={option.content}
                    onChange={(e) =>
                      updateNewOption(index, { content: e.target.value })
                    }
                    placeholder={`Đáp án ${index + 1}`}
                    required
                  />
                </div>
              ))}
            </div>
          )}

          {questionForm.questionType === 'TRUE_FALSE' && (
            <div className="span-2 option-editor">
              <h3>Đáp án đúng/sai</h3>
              {trueFalseItems.map((item, index) => (
                <div key={item.orderIndex} className="option-row true-false-row">
                  <input
                    value={item.content}
                    onChange={(e) =>
                      updateTrueFalseItem(index, { content: e.target.value })
                    }
                    placeholder={`Ý ${index + 1}`}
                    required
                  />
                  <select
                    value={item.correct ? 'true' : 'false'}
                    onChange={(e) =>
                      updateTrueFalseItem(index, {
                        correct: e.target.value === 'true',
                      })
                    }
                  >
                    <option value="true">Đúng</option>
                    <option value="false">Sai</option>
                  </select>
                </div>
              ))}
            </div>
          )}

          {questionForm.questionType === 'SHORT_ANSWER' && (
            <label className="span-2">
              Đáp án chuẩn
              <input
                value={questionForm.correctAnswer}
                onChange={(e) =>
                  setQuestionForm({
                    ...questionForm,
                    correctAnswer: e.target.value,
                  })
                }
                placeholder="Nhập đáp án mẫu cho câu tự luận ngắn"
                required
              />
            </label>
          )}

          <div className="form-actions span-2">
            <button type="submit" className="btn btn-primary btn-sm">
              Tạo câu hỏi
            </button>
          </div>
        </form>
      </section>

      {questions.map((q, idx) => (
        <section key={q.id} className="panel">
          <h3>
            Câu {idx + 1}: {q.content}
          </h3>
          <button
            type="button"
            className="btn btn-ghost btn-sm"
            onClick={() => loadOptions(q.id)}
          >
            Tải đáp án
          </button>
          {q.options?.length > 0 && (
            <ul className="option-list">
              {q.options.map((o) => (
                <li key={o.id}>
                  {o.content} {o.correct ? '✓' : ''}
                </li>
              ))}
            </ul>
          )}
          <form className="inline-form" onSubmit={(e) => addOption(q.id, e)}>
            <input
              placeholder="Nội dung đáp án"
              value={optionForms[q.id]?.content || ''}
              onChange={(e) =>
                setOptionForms((prev) => ({
                  ...prev,
                  [q.id]: {
                    ...(prev[q.id] || {
                      correct: false,
                      orderIndex: (q.options?.length || 0) + 1,
                    }),
                    content: e.target.value,
                  },
                }))
              }
              required
            />
            <label className="checkbox-label inline">
              <input
                type="checkbox"
                checked={optionForms[q.id]?.correct || false}
                onChange={(e) =>
                  setOptionForms((prev) => ({
                    ...prev,
                    [q.id]: {
                      ...(prev[q.id] || { content: '', orderIndex: 1 }),
                      correct: e.target.checked,
                    },
                  }))
                }
              />
              Đúng
            </label>
            <button type="submit" className="btn btn-primary btn-sm">
              Thêm đáp án
            </button>
          </form>
        </section>
      ))}
    </div>
  );
}
