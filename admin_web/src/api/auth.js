import { REFRESH_KEY, TOKEN_KEY } from './config.js';
import { apiRequest } from './client.js';

export async function login(email, password) {
  const data = await apiRequest('/auth/login', {
    method: 'POST',
    auth: false,
    body: { email, password },
  });
  localStorage.setItem(TOKEN_KEY, data.accessToken);
  if (data.refreshToken) localStorage.setItem(REFRESH_KEY, data.refreshToken);
  return data;
}

export function register({ email, password, fullName }) {
  return apiRequest('/auth/register', {
    method: 'POST',
    auth: false,
    body: { email, password, fullName },
  });
}

export function refresh(refreshToken) {
  return apiRequest('/auth/refresh', {
    method: 'POST',
    auth: false,
    body: { refreshToken },
  });
}

export async function logout() {
  const refreshToken = localStorage.getItem(REFRESH_KEY);
  const accessToken = localStorage.getItem(TOKEN_KEY);
  try {
    if (refreshToken && accessToken) {
      await apiRequest('/auth/logout', {
        method: 'POST',
        body: { refreshToken },
      });
    }
  } finally {
    localStorage.removeItem(TOKEN_KEY);
    localStorage.removeItem(REFRESH_KEY);
  }
}

export function isAuthenticated() {
  return Boolean(localStorage.getItem(TOKEN_KEY));
}
