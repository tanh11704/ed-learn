import { API_BASE_URL, REFRESH_KEY, TOKEN_KEY } from './config.js';

export const AUTH_EXPIRED_EVENT = 'edlearn:auth-expired';

function expireAuthSession() {
  localStorage.removeItem(TOKEN_KEY);
  localStorage.removeItem(REFRESH_KEY);
  window.dispatchEvent(new Event(AUTH_EXPIRED_EVENT));
}

async function refreshAccessToken() {
  const refreshToken = localStorage.getItem(REFRESH_KEY);
  if (!refreshToken) return null;

  let res;
  try {
    res = await fetch(`${API_BASE_URL}/auth/refresh`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      body: JSON.stringify({ refreshToken }),
    });
  } catch {
    return null;
  }

  if (!res.ok) return null;
  const data = await res.json();
  if (data.accessToken) {
    localStorage.setItem(TOKEN_KEY, data.accessToken);
    if (data.refreshToken) localStorage.setItem(REFRESH_KEY, data.refreshToken);
    return data.accessToken;
  }
  return null;
}

export async function apiRequest(path, options = {}) {
  const { auth = true, body, headers = {}, ...rest } = options;

  const reqHeaders = {
    Accept: 'application/json',
    ...headers,
  };

  if (body !== undefined && !(body instanceof FormData)) {
    reqHeaders['Content-Type'] = 'application/json';
  }

  if (auth) {
    const token = localStorage.getItem(TOKEN_KEY);
    if (token) reqHeaders.Authorization = `Bearer ${token}`;
  }

  const url = path.startsWith('http') ? path : `${API_BASE_URL}${path}`;

  let response = await fetch(url, {
    ...rest,
    headers: reqHeaders,
    body:
      body instanceof FormData
        ? body
        : body !== undefined
          ? JSON.stringify(body)
          : undefined,
  });

  if (auth && response.status === 401) {
    const newToken = await refreshAccessToken();
    if (newToken) {
      reqHeaders.Authorization = `Bearer ${newToken}`;
      response = await fetch(url, {
        ...rest,
        headers: reqHeaders,
        body:
          body instanceof FormData
            ? body
            : body !== undefined
              ? JSON.stringify(body)
              : undefined,
      });
    } else {
      expireAuthSession();
    }
  }

  if (response.status === 204) return null;

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
      data?.message || data?.error || `HTTP ${response.status}`;
    const err = new Error(message);
    err.status = response.status;
    err.data = data;
    throw err;
  }

  return data;
}
