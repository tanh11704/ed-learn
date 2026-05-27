import { useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { ArrowLeft, FileUp, Pencil, Save, Trash2, X } from 'lucide-react';
import PageHeader from '../components/PageHeader.jsx';
import Alert from '../components/Alert.jsx';
import MathText from '../components/MathText.jsx';
import * as examsApi from '../api/exams.js';
import * as examPdfExtractionApi from '../api/examPdfExtraction.js';
import { resolveAssetUrl } from '../utils/assets.js';
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

function makeClientId() {
  if (window.crypto?.randomUUID) return window.crypto.randomUUID();
  return `${Date.now()}-${Math.random().toString(16).slice(2)}`;
}

function normalizeImportedQuestion(question, index, examId) {
  return {
    clientId: makeClientId(),
    examId,
    questionType: question.questionType || 'MULTIPLE_CHOICE',
    paperPart: question.paperPart || 'PART_I',
    content: question.content || '',
    orderIndex: Number(question.orderIndex || index + 1),
    score: Number(question.score || 0.25),
    correctAnswer: question.correctAnswer || '',
    imageUrl: question.imageUrl || '',
    imageFile: null,
    options: Array.isArray(question.options)
      ? question.options.map((option, optionIndex) => ({
          content: option.content || '',
          correct: Boolean(option.correct),
          orderIndex: Number(option.orderIndex || optionIndex + 1),
        }))
      : [],
  };
}

export default function ExamDetailPage() {
  const { id: examId } = useParams();
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [questions, setQuestions] = useState(() =>
    readStoredExamQuestions(examId),
  );
  const [importForm, setImportForm] = useState({
    file: null,
    subject: '',
    gradeLevel: 12,
    profile: 'THPT_2026',
  });
  const [importing, setImporting] = useState(false);
  const [importWarnings, setImportWarnings] = useState([]);
  const [importedQuestions, setImportedQuestions] = useState([]);
  const [savingImport, setSavingImport] = useState(false);
  const [saveProgress, setSaveProgress] = useState({ current: 0, total: 0 });
  const [failedImportIndex, setFailedImportIndex] = useState(null);
  const [questionForm, setQuestionForm] = useState({
    content: '',
    questionType: 'MULTIPLE_CHOICE',
    paperPart: 'PART_I',
    score: 0.25,
    orderIndex: 1,
    correctAnswer: '',
    imageFile: null,
  });
  const [newOptions, setNewOptions] = useState(multipleChoiceOptions);
  const [trueFalseItems, setTrueFalseItems] = useState(trueFalseOptions);
  const [optionForms, setOptionForms] = useState({});
  const [editingQuestionId, setEditingQuestionId] = useState(null);
  const [editQuestionForm, setEditQuestionForm] = useState(null);

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

  async function extractQuestionsFromPdf(e) {
    e.preventDefault();
    setError('');
    setSuccess('');
    setImportWarnings([]);
    setImportedQuestions([]);
    setFailedImportIndex(null);

    if (!importForm.file) {
      setError('Vui lòng chọn file PDF.');
      return;
    }

    setImporting(true);
    try {
      const data = await examPdfExtractionApi.extractExamPdf({
        file: importForm.file,
        examId,
        subject: importForm.subject,
        gradeLevel: importForm.gradeLevel,
        profile: importForm.profile,
      });
      const extracted = Array.isArray(data?.questions) ? data.questions : [];
      setImportWarnings(Array.isArray(data?.warnings) ? data.warnings : []);
      setImportedQuestions(
        extracted.map((question, index) =>
          normalizeImportedQuestion(question, index, examId),
        ),
      );
      if (extracted.length === 0) {
        setError('AI không trích xuất được câu hỏi nào từ file này.');
      }
    } catch (err) {
      setError(err.message);
    } finally {
      setImporting(false);
    }
  }

  function updateImportedQuestion(index, patch) {
    setImportedQuestions((prev) =>
      prev.map((question, idx) =>
        idx === index ? { ...question, ...patch } : question,
      ),
    );
  }

  function updateImportedOption(questionIndex, optionIndex, patch) {
    setImportedQuestions((prev) =>
      prev.map((question, idx) => {
        if (idx !== questionIndex) return question;
        return {
          ...question,
          options: question.options.map((option, optIdx) =>
            optIdx === optionIndex ? { ...option, ...patch } : option,
          ),
        };
      }),
    );
  }

  function setImportedCorrectOption(questionIndex, optionIndex) {
    setImportedQuestions((prev) =>
      prev.map((question, idx) => {
        if (idx !== questionIndex) return question;
        return {
          ...question,
          options: question.options.map((option, optIdx) => ({
            ...option,
            correct: optIdx === optionIndex,
          })),
        };
      }),
    );
  }

  function addImportedOption(questionIndex) {
    setImportedQuestions((prev) =>
      prev.map((question, idx) => {
        if (idx !== questionIndex) return question;
        return {
          ...question,
          options: [
            ...question.options,
            {
              content: '',
              correct: false,
              orderIndex: question.options.length + 1,
            },
          ],
        };
      }),
    );
  }

  function removeImportedQuestion(index) {
    setImportedQuestions((prev) => prev.filter((_, idx) => idx !== index));
  }

  function buildImportedQuestionPayload(question) {
    const payload = {
      examId,
      questionType: question.questionType,
      paperPart: question.paperPart,
      content: question.content.trim(),
      imageUrl: question.imageUrl || '',
      imageFile: question.imageFile || null,
      score: Number(question.score),
      orderIndex: Number(question.orderIndex),
      correctAnswer: question.correctAnswer?.trim() || null,
      options: [],
    };

    if (!payload.content) throw new Error('Nội dung câu hỏi không được trống.');

    if (payload.questionType === 'MULTIPLE_CHOICE') {
      const options = question.options.map((option, index) => ({
        content: option.content.trim(),
        correct: Boolean(option.correct),
        orderIndex: index + 1,
      }));
      if (options.length < 2 || options.some((option) => !option.content)) {
        throw new Error('Câu trắc nghiệm phải có đáp án hợp lệ.');
      }
      if (options.filter((option) => option.correct).length !== 1) {
        throw new Error('Câu trắc nghiệm phải có đúng 1 đáp án đúng.');
      }
      payload.options = options;
      payload.correctAnswer = null;
      return payload;
    }

    if (payload.questionType === 'TRUE_FALSE') {
      const options = question.options.map((option, index) => ({
        content: option.content.trim(),
        correct: Boolean(option.correct),
        orderIndex: index + 1,
      }));
      if (options.length === 0 || options.some((option) => !option.content)) {
        throw new Error('Câu đúng/sai phải có các ý hợp lệ.');
      }
      payload.options = options;
      payload.correctAnswer = null;
      return payload;
    }

    if (!payload.correctAnswer) {
      throw new Error('Câu tự luận ngắn phải có đáp án chuẩn.');
    }

    return payload;
  }

  async function saveImportedQuestions() {
    setError('');
    setSuccess('');
    setFailedImportIndex(null);
    setSaveProgress({ current: 0, total: importedQuestions.length });
    setSavingImport(true);

    const savedQuestions = [];
    try {
      for (let index = 0; index < importedQuestions.length; index += 1) {
        setSaveProgress({ current: index + 1, total: importedQuestions.length });
        const payload = buildImportedQuestionPayload(importedQuestions[index]);
        const q = await examsApi.createQuestion(payload);
        savedQuestions.push({
          ...payload,
          ...(q || {}),
          options: q?.options || payload.options || [],
        });
      }

      setQuestions((prev) => {
        const next = [...prev, ...savedQuestions];
        writeStoredExamQuestions(examId, next);
        return next;
      });
      setImportedQuestions([]);
      setImportWarnings([]);
      setSuccess(`Đã lưu ${savedQuestions.length} câu hỏi vào đề thi.`);
    } catch (err) {
      setFailedImportIndex(Math.max(saveProgress.current - 1, 0));
      setError(`Lưu câu ${saveProgress.current} thất bại: ${err.message}`);
    } finally {
      setSavingImport(false);
    }
  }

  function buildQuestionPayload() {
    const base = {
      examId,
      questionType: questionForm.questionType,
      paperPart: questionForm.paperPart,
      content: questionForm.content,
      imageFile: questionForm.imageFile,
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
        imageFile: null,
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

  function openEditQuestion(question) {
    setEditingQuestionId(question.id);
    setEditQuestionForm({
      content: question.content || '',
      imageUrl: question.imageUrl || '',
      imageFile: null,
      orderIndex: question.orderIndex || 1,
      score: question.score || 0.25,
      correctAnswer: question.correctAnswer || '',
      options: Array.isArray(question.options)
        ? question.options.map((option, index) => ({
            id: option.id,
            content: option.content || '',
            correct: Boolean(option.correct),
            orderIndex: option.orderIndex || index + 1,
          }))
        : [],
    });
  }

  function updateEditOption(index, patch) {
    setEditQuestionForm((form) => ({
      ...form,
      options: form.options.map((option, idx) =>
        idx === index ? { ...option, ...patch } : option,
      ),
    }));
  }

  async function saveQuestionEdit(question) {
    setError('');
    setSuccess('');
    try {
      const payload = {
        content: editQuestionForm.content.trim(),
        imageUrl: editQuestionForm.imageUrl || '',
        imageFile: editQuestionForm.imageFile,
        orderIndex: Number(editQuestionForm.orderIndex),
        score: Number(editQuestionForm.score),
        correctAnswer:
          question.questionType === 'SHORT_ANSWER'
            ? editQuestionForm.correctAnswer.trim()
            : null,
      };

      const updatedQuestion = await examsApi.updateQuestion(question.id, payload);

      for (const option of editQuestionForm.options) {
        if (!option.id) continue;
        await examsApi.updateOption(question.id, option.id, {
          content: option.content.trim(),
          correct: Boolean(option.correct),
          orderIndex: Number(option.orderIndex),
        });
      }

      let nextOptions = editQuestionForm.options;
      if (nextOptions.some((option) => option.id)) {
        nextOptions = await examsApi.getQuestionOptions(question.id);
      }

      setQuestions((prev) => {
        const next = prev.map((item) =>
          item.id === question.id
            ? {
                ...item,
                ...payload,
                ...(updatedQuestion || {}),
                options: nextOptions,
              }
            : item,
        );
        writeStoredExamQuestions(examId, next);
        return next;
      });
      setEditingQuestionId(null);
      setEditQuestionForm(null);
      setSuccess('Đã cập nhật câu hỏi.');
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
      {success && <Alert type="success">{success}</Alert>}

      <section className="panel">
        <div className="panel-head">
          <div>
            <h2>Import đề thi từ PDF bằng AI</h2>
            <p className="muted panel-note">
              AI chỉ trích xuất nháp. Admin cần review, sửa đáp án và xác nhận
              trước khi lưu vào đề thi.
            </p>
          </div>
        </div>
        <form className="form-grid" onSubmit={extractQuestionsFromPdf}>
          <label>
            Môn thi
            <input
              value={importForm.subject}
              onChange={(e) =>
                setImportForm({ ...importForm, subject: e.target.value })
              }
              placeholder="Toán"
            />
          </label>
          <label>
            Khối lớp
            <input
              type="number"
              min={1}
              value={importForm.gradeLevel}
              onChange={(e) =>
                setImportForm({ ...importForm, gradeLevel: e.target.value })
              }
            />
          </label>
          <label>
            Profile
            <select
              value={importForm.profile}
              onChange={(e) =>
                setImportForm({ ...importForm, profile: e.target.value })
              }
            >
              <option value="THPT_2026">THPT_2026</option>
            </select>
          </label>
          <label>
            File PDF
            <input
              type="file"
              accept="application/pdf,.pdf"
              onChange={(e) =>
                setImportForm({
                  ...importForm,
                  file: e.target.files?.[0] || null,
                })
              }
              required
            />
          </label>
          <div className="form-actions span-2">
            <button type="submit" className="btn btn-primary" disabled={importing}>
              <FileUp size={16} />
              {importing ? 'Đang đọc PDF và trích xuất...' : 'Trích xuất câu hỏi'}
            </button>
          </div>
        </form>
      </section>

      {(importWarnings.length > 0 || importedQuestions.length > 0) && (
        <section className="panel">
          <div className="panel-head">
            <div>
              <h2>Kết quả trích xuất: {importedQuestions.length} câu</h2>
              {importWarnings.map((warning) => (
                <p key={warning} className="muted panel-note">
                  {warning}
                </p>
              ))}
            </div>
            {importedQuestions.length > 0 && (
              <button
                type="button"
                className="btn btn-primary"
                onClick={saveImportedQuestions}
                disabled={savingImport}
              >
                <Save size={16} />
                {savingImport
                  ? `Đang lưu ${saveProgress.current}/${saveProgress.total}`
                  : 'Lưu vào đề thi'}
              </button>
            )}
          </div>

          <div className="import-review-list">
            {importedQuestions.map((question, questionIndex) => (
              <div
                key={question.clientId}
                className={`import-question-card ${
                  failedImportIndex === questionIndex ? 'has-error' : ''
                }`}
              >
                <div className="import-question-head">
                  <strong>Câu {questionIndex + 1}</strong>
                  <button
                    type="button"
                    className="btn-icon danger"
                    onClick={() => removeImportedQuestion(questionIndex)}
                    title="Xóa câu hỏi"
                  >
                    <Trash2 size={16} />
                  </button>
                </div>
                <div className="form-grid">
                  <label className="span-2">
                    Nội dung
                    <textarea
                      value={question.content}
                      onChange={(e) =>
                        updateImportedQuestion(questionIndex, {
                          content: e.target.value,
                        })
                      }
                      rows={3}
                    />
                  </label>
                  <label className="span-2">
                    Hình ảnh minh họa (không bắt buộc)
                    <input
                      type="file"
                      accept="image/*"
                      onChange={(e) =>
                        updateImportedQuestion(questionIndex, {
                          imageFile: e.target.files?.[0] || null,
                        })
                      }
                    />
                  </label>
                  {(question.imageFile || question.imageUrl) && (
                    <div className="span-2 question-image-preview">
                      <img
                        src={
                          question.imageFile
                            ? URL.createObjectURL(question.imageFile)
                            : resolveAssetUrl(question.imageUrl)
                        }
                        alt={`Hình minh họa câu ${questionIndex + 1}`}
                      />
                    </div>
                  )}
                  <label>
                    Loại
                    <select
                      value={question.questionType}
                      onChange={(e) =>
                        updateImportedQuestion(questionIndex, {
                          questionType: e.target.value,
                          options:
                            e.target.value === 'SHORT_ANSWER'
                              ? []
                              : question.options.length > 0
                                ? question.options
                                : multipleChoiceOptions,
                        })
                      }
                    >
                      <option value="MULTIPLE_CHOICE">Trắc nghiệm</option>
                      <option value="TRUE_FALSE">Đúng/Sai</option>
                      <option value="SHORT_ANSWER">Tự luận ngắn</option>
                    </select>
                  </label>
                  <label>
                    Phần đề
                    <select
                      value={question.paperPart}
                      onChange={(e) =>
                        updateImportedQuestion(questionIndex, {
                          paperPart: e.target.value,
                        })
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
                      value={question.score}
                      onChange={(e) =>
                        updateImportedQuestion(questionIndex, {
                          score: e.target.value,
                        })
                      }
                    />
                  </label>
                  <label>
                    Thứ tự
                    <input
                      type="number"
                      value={question.orderIndex}
                      onChange={(e) =>
                        updateImportedQuestion(questionIndex, {
                          orderIndex: e.target.value,
                        })
                      }
                    />
                  </label>

                  {question.questionType === 'SHORT_ANSWER' ? (
                    <label className="span-2">
                      Đáp án chuẩn
                      <input
                        value={question.correctAnswer || ''}
                        onChange={(e) =>
                          updateImportedQuestion(questionIndex, {
                            correctAnswer: e.target.value,
                          })
                        }
                      />
                    </label>
                  ) : (
                    <div className="span-2 option-editor">
                      <h3>Đáp án / ý trả lời</h3>
                      {question.options.map((option, optionIndex) => (
                        <div
                          key={`${question.clientId}-${optionIndex}`}
                          className={
                            question.questionType === 'TRUE_FALSE'
                              ? 'option-row true-false-row'
                              : 'option-row'
                          }
                        >
                          {question.questionType === 'TRUE_FALSE' ? (
                            <select
                              value={option.correct ? 'true' : 'false'}
                              onChange={(e) =>
                                updateImportedOption(
                                  questionIndex,
                                  optionIndex,
                                  { correct: e.target.value === 'true' },
                                )
                              }
                            >
                              <option value="true">Đúng</option>
                              <option value="false">Sai</option>
                            </select>
                          ) : (
                            <label className="checkbox-label inline">
                              <input
                                type="radio"
                                name={`import-correct-${question.clientId}`}
                                checked={option.correct}
                                onChange={() =>
                                  setImportedCorrectOption(
                                    questionIndex,
                                    optionIndex,
                                  )
                                }
                              />
                              Đúng
                            </label>
                          )}
                          <input
                            value={option.content}
                            onChange={(e) =>
                              updateImportedOption(
                                questionIndex,
                                optionIndex,
                                { content: e.target.value },
                              )
                            }
                          />
                        </div>
                      ))}
                      <button
                        type="button"
                        className="btn btn-ghost btn-sm"
                        onClick={() => addImportedOption(questionIndex)}
                      >
                        Thêm đáp án
                      </button>
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        </section>
      )}

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
          <label className="span-2">
            Hình ảnh minh họa (không bắt buộc)
            <input
              type="file"
              accept="image/*"
              onChange={(e) =>
                setQuestionForm({
                  ...questionForm,
                  imageFile: e.target.files?.[0] || null,
                })
              }
            />
          </label>
          {questionForm.imageFile && (
            <div className="span-2 question-image-preview">
              <img
                src={URL.createObjectURL(questionForm.imageFile)}
                alt="Hình minh họa câu hỏi"
              />
            </div>
          )}
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
            Câu {idx + 1}: <MathText>{q.content}</MathText>
          </h3>
          {q.imageUrl && (
            <img
              src={resolveAssetUrl(q.imageUrl)}
              alt={`Hình minh họa câu ${idx + 1}`}
              className="question-image"
            />
          )}
          <div className="row-actions">
          <button
            type="button"
            className="btn btn-ghost btn-sm"
            onClick={() => loadOptions(q.id)}
          >
            Tải đáp án
          </button>
            <button
              type="button"
              className="btn btn-ghost btn-sm"
              onClick={() => openEditQuestion(q)}
            >
              <Pencil size={14} /> Sửa câu hỏi
            </button>
          </div>
          {q.options?.length > 0 && (
            <ul className="option-list">
              {q.options.map((o) => (
                <li key={o.id}>
                  <MathText>{o.content}</MathText> {o.correct ? '✓' : ''}
                </li>
              ))}
            </ul>
          )}
          {editingQuestionId === q.id && editQuestionForm && (
            <form
              className="form-grid edit-question-form"
              onSubmit={(e) => {
                e.preventDefault();
                saveQuestionEdit(q);
              }}
            >
              <label className="span-2">
                Nội dung
                <textarea
                  value={editQuestionForm.content}
                  onChange={(e) =>
                    setEditQuestionForm({
                      ...editQuestionForm,
                      content: e.target.value,
                    })
                  }
                  rows={3}
                  required
                />
              </label>
              <label className="span-2">
                Thay hình ảnh minh họa
                <input
                  type="file"
                  accept="image/*"
                  onChange={(e) =>
                    setEditQuestionForm({
                      ...editQuestionForm,
                      imageFile: e.target.files?.[0] || null,
                    })
                  }
                />
              </label>
              {(editQuestionForm.imageFile || editQuestionForm.imageUrl) && (
                <div className="span-2 question-image-preview">
                  <img
                    src={
                      editQuestionForm.imageFile
                        ? URL.createObjectURL(editQuestionForm.imageFile)
                        : resolveAssetUrl(editQuestionForm.imageUrl)
                    }
                    alt="Hình minh họa câu hỏi"
                  />
                  <button
                    type="button"
                    className="btn btn-ghost btn-sm"
                    onClick={() =>
                      setEditQuestionForm({
                        ...editQuestionForm,
                        imageUrl: '',
                        imageFile: null,
                      })
                    }
                  >
                    Bỏ ảnh
                  </button>
                </div>
              )}
              <label>
                Điểm
                <input
                  type="number"
                  step="0.01"
                  min="0.01"
                  value={editQuestionForm.score}
                  onChange={(e) =>
                    setEditQuestionForm({
                      ...editQuestionForm,
                      score: e.target.value,
                    })
                  }
                  required
                />
              </label>
              <label>
                Thứ tự
                <input
                  type="number"
                  value={editQuestionForm.orderIndex}
                  onChange={(e) =>
                    setEditQuestionForm({
                      ...editQuestionForm,
                      orderIndex: e.target.value,
                    })
                  }
                />
              </label>
              {q.questionType === 'SHORT_ANSWER' && (
                <label className="span-2">
                  Đáp án chuẩn
                  <input
                    value={editQuestionForm.correctAnswer}
                    onChange={(e) =>
                      setEditQuestionForm({
                        ...editQuestionForm,
                        correctAnswer: e.target.value,
                      })
                    }
                  />
                </label>
              )}
              {q.questionType !== 'SHORT_ANSWER' &&
                editQuestionForm.options.length > 0 && (
                  <div className="span-2 option-editor">
                    <h3>Sửa đáp án</h3>
                    {editQuestionForm.options.map((option, optionIndex) => (
                      <div
                        key={option.id || optionIndex}
                        className={
                          q.questionType === 'TRUE_FALSE'
                            ? 'option-row true-false-row'
                            : 'option-row'
                        }
                      >
                        {q.questionType === 'TRUE_FALSE' ? (
                          <select
                            value={option.correct ? 'true' : 'false'}
                            onChange={(e) =>
                              updateEditOption(optionIndex, {
                                correct: e.target.value === 'true',
                              })
                            }
                          >
                            <option value="true">Đúng</option>
                            <option value="false">Sai</option>
                          </select>
                        ) : (
                          <label className="checkbox-label inline">
                            <input
                              type="radio"
                              name={`edit-correct-${q.id}`}
                              checked={option.correct}
                              onChange={() =>
                                setEditQuestionForm((form) => ({
                                  ...form,
                                  options: form.options.map((item, idx) => ({
                                    ...item,
                                    correct: idx === optionIndex,
                                  })),
                                }))
                              }
                            />
                            Đúng
                          </label>
                        )}
                        <input
                          value={option.content}
                          onChange={(e) =>
                            updateEditOption(optionIndex, {
                              content: e.target.value,
                            })
                          }
                          required
                        />
                      </div>
                    ))}
                  </div>
                )}
              <div className="form-actions span-2">
                <button type="submit" className="btn btn-primary btn-sm">
                  <Save size={14} /> Lưu thay đổi
                </button>
                <button
                  type="button"
                  className="btn btn-ghost btn-sm"
                  onClick={() => {
                    setEditingQuestionId(null);
                    setEditQuestionForm(null);
                  }}
                >
                  <X size={14} /> Hủy
                </button>
              </div>
            </form>
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
