const DEFAULT_API_BASE = 'https://api.phuocanh.me';

/**
 * Gỡ hậu tố `/api/v1` nếu có — tránh URL dạng `.../api/v1/api/v1/...` khi code luôn thêm prefix `/api/v1/...`.
 */
function normalizeApiBase(raw: string): string {
  let b = raw.trim().replace(/\/+$/, '');
  if (b.endsWith('/api/v1')) {
    b = b.slice(0, -'/api/v1'.length).replace(/\/+$/, '');
  }
  return b;
}

/**
 * Base URL API (không dấu / cuối, không gồm `/api/v1`).
 * - Không khai báo `VITE_API_BASE_URL` → mặc định https://api.phuocanh.me (dev & prod).
 * - `VITE_API_BASE_URL=` (rỗng có chủ đích) → cùng origin, dùng proxy Vite `/api`.
 * - `VITE_API_BASE_URL=http://192.168.1.5:8080` (hoặc localhost) → backend LAN/local trực tiếp.
 */
export function getApiBaseUrl(): string {
  const v = import.meta.env.VITE_API_BASE_URL;
  if (v === '') return '';
  if (typeof v === 'string' && v.trim()) return normalizeApiBase(v);
  return DEFAULT_API_BASE;
}

export function buildApiUrl(path: string): string {
  const base = getApiBaseUrl();
  const p = path.startsWith('/') ? path : `/${path}`;
  return `${base}${p}`;
}
