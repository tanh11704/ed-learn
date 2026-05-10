import { buildApiUrl } from '../config/api';
import { refreshSessionCoalesced } from './refreshSession';
import { clearTokens, getAccessToken, getRefreshToken } from './tokens';
import type { ErrorResponseDto } from './models/error.dto';

export type CustomBaseQueryArgs = {
  url: string;
  method?: string;
  body?: unknown;
  params?: Record<string, string | number | boolean | undefined | null>;
  headers?: HeadersInit;
  skipAuth?: boolean;
  bearerToken?: string | null;
  signal?: AbortSignal;
  /** Tránh vòng lặp khi refresh token cũng 401 */
  skipRefreshRetry?: boolean;
};

export type CustomBaseQueryError = {
  status: number;
  data: unknown;
};

export type CustomBaseQueryResult<T> = { data: T } | { error: CustomBaseQueryError };

function withSearchParams(
  path: string,
  params: CustomBaseQueryArgs['params']
): string {
  if (!params || !Object.keys(params).length) return path;
  const sp = new URLSearchParams();
  for (const [k, v] of Object.entries(params)) {
    if (v === undefined || v === null) continue;
    sp.set(k, String(v));
  }
  const q = sp.toString();
  if (!q) return path;
  const sep = path.includes('?') ? '&' : '?';
  return `${path}${sep}${q}`;
}

function parseJson(text: string): unknown {
  try {
    return JSON.parse(text) as unknown;
  } catch {
    return text;
  }
}

export function isErrorResponseDto(x: unknown): x is ErrorResponseDto {
  if (typeof x !== 'object' || x === null) return false;
  const o = x as Record<string, unknown>;
  return typeof o.message === 'string' && typeof o.status === 'number';
}

export function messageFromErrorBody(data: unknown, fallback: string): string {
  if (isErrorResponseDto(data) && data.message.trim()) return data.message;
  if (typeof data === 'object' && data !== null && 'message' in data) {
    const m = (data as { message?: unknown }).message;
    if (typeof m === 'string' && m.trim()) return m;
  }
  return fallback;
}

export async function customBaseQuery<T>(
  args: CustomBaseQueryArgs
): Promise<CustomBaseQueryResult<T>> {
  const {
    url: path,
    method = 'GET',
    body,
    params,
    headers: initHeaders,
    skipAuth,
    bearerToken,
    signal,
    skipRefreshRetry,
  } = args;

  const pathNorm = path.startsWith('/') ? path : `/${path}`;
  const url = buildApiUrl(withSearchParams(pathNorm, params));

  const headers = new Headers(initHeaders);
  if (!headers.has('Accept')) headers.set('Accept', 'application/json');

  let reqBody: BodyInit | undefined;
  if (body !== undefined && body !== null) {
    if (
      typeof body === 'string' ||
      body instanceof FormData ||
      body instanceof Blob ||
      body instanceof ArrayBuffer
    ) {
      reqBody = body as BodyInit;
    } else {
      if (!headers.has('Content-Type')) {
        headers.set('Content-Type', 'application/json');
      }
      reqBody = JSON.stringify(body);
    }
  }

  if (!skipAuth) {
    const t =
      bearerToken !== undefined ? bearerToken : getAccessToken()?.trim();
    if (t) headers.set('Authorization', `Bearer ${t}`);
  }

  let res: Response;
  try {
    res = await fetch(url, { method, headers, body: reqBody, signal });
  } catch {
    return {
      error: {
        status: 0,
        data: { message: 'Không kết nối được máy chủ.' },
      },
    };
  }

  const text = await res.text();
  const parsed: unknown = text ? parseJson(text) : undefined;

  if (res.status === 204) {
    return { data: undefined as T };
  }

  if (!res.ok) {
    if (
      res.status === 401 &&
      !skipAuth &&
      !skipRefreshRetry &&
      !!getRefreshToken()?.trim()
    ) {
      const refreshed = await refreshSessionCoalesced();
      if (refreshed) {
        return customBaseQuery<T>({ ...args, skipRefreshRetry: true });
      }
      clearTokens();
    }
    return {
      error: {
        status: res.status,
        data: parsed,
      },
    };
  }

  return { data: parsed as T };
}
