import { AI_SERVICE_BASE_URL, AI_SERVICE_KEY } from './config.js';

async function aiRequest(path, options = {}) {
  const { body, headers = {}, ...rest } = options;
  const url = path.startsWith('http') ? path : `${AI_SERVICE_BASE_URL}${path}`;

  const response = await fetch(url, {
    ...rest,
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
      'X-AI-Service-Key': AI_SERVICE_KEY,
      ...headers,
    },
    body: body !== undefined ? JSON.stringify(body) : undefined,
  });

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
    const message =
      data?.message || data?.error || getAiErrorMessage(response.status);
    const err = new Error(message);
    err.status = response.status;
    err.data = data;
    throw err;
  }

  return data;
}

function getAiErrorMessage(status) {
  if (status === 401) return 'Không có quyền gọi AI service.';
  if (status === 422) return 'Nội dung gửi lên chưa đúng định dạng.';
  if (status === 503) return 'AI đang bận hoặc tạm thời chưa sẵn sàng. Vui lòng thử lại.';
  return `AI service trả về HTTP ${status}`;
}

export function ingestLesson(body) {
  return aiRequest('/api/v1/ingest/lesson', {
    method: 'POST',
    body,
  });
}

export function chat(body) {
  return aiRequest('/api/v1/chat', {
    method: 'POST',
    body,
  });
}
