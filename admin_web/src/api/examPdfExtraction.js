import { AI_SERVICE_BASE_URL, AI_SERVICE_KEY } from './config.js';

function errorMessage(status, data) {
  const detail = data?.detail || data?.message || data?.error;

  if (status === 401) return 'Khong co quyen goi AI service.';
  if (status === 400) return detail || 'Vui long chon file PDF.';
  if (status === 422) {
    return (
      detail ||
      'File PDF nay co the la anh scan. MVP hien chua ho tro OCR/vision.'
    );
  }
  if (status === 502) {
    return 'AI chua trich xuat duoc dung dinh dang. Vui long thu lai.';
  }
  if (status === 503) {
    return 'AI dang ban hoac qua thoi gian xu ly. Vui long thu lai sau.';
  }

  return detail || `HTTP ${status}`;
}

export async function extractExamPdf({
  file,
  examId,
  subject,
  gradeLevel,
  profile = 'THPT_2026',
}) {
  const formData = new FormData();
  formData.append('file', file);
  if (examId) formData.append('exam_id', examId);
  if (subject) formData.append('subject', subject);
  if (gradeLevel) formData.append('grade_level', String(gradeLevel));
  if (profile) formData.append('profile', profile);

  const response = await fetch(
    `${AI_SERVICE_BASE_URL}/api/v1/exams/extract-pdf`,
    {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'X-AI-Service-Key': AI_SERVICE_KEY,
      },
      body: formData,
    },
  );

  const text = await response.text();
  let data = null;
  if (text) {
    try {
      data = JSON.parse(text);
    } catch {
      data = text;
    }
  }

  if (!response.ok) {
    const err = new Error(errorMessage(response.status, data));
    err.status = response.status;
    err.data = data;
    throw err;
  }

  return data;
}
