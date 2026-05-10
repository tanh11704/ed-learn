import { buildApiUrl } from '../config/api';
import type { AuthResponseDto } from './models/auth.dto';
import { getRefreshToken, setTokens } from './tokens';

let refreshPromise: Promise<boolean> | null = null;

function parseAuthResponse(data: unknown): AuthResponseDto | null {
  if (typeof data !== 'object' || data === null) return null;
  const o = data as Record<string, unknown>;
  const accessToken = String(o.accessToken ?? o.access_token ?? '').trim();
  const refreshToken = String(o.refreshToken ?? o.refresh_token ?? '').trim();
  if (!accessToken || !refreshToken) return null;
  return {
    accessToken,
    refreshToken,
    tokenType: typeof o.tokenType === 'string' ? o.tokenType : undefined,
  };
}

async function performRefresh(refreshToken: string): Promise<boolean> {
  try {
    const url = buildApiUrl('/api/v1/auth/refresh');
    const res = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      body: JSON.stringify({ refreshToken }),
    });
    const text = await res.text();
    let parsed: unknown;
    try {
      parsed = text ? JSON.parse(text) : undefined;
    } catch {
      return false;
    }
    if (!res.ok) return false;
    const tokens = parseAuthResponse(parsed);
    if (!tokens) return false;
    setTokens(tokens.accessToken, tokens.refreshToken);
    return true;
  } catch {
    return false;
  }
}

/**
 * Làm mới access token (single-flight). Dùng từ customBaseQuery khi 401.
 */
export async function refreshSessionCoalesced(): Promise<boolean> {
  if (!refreshPromise) {
    refreshPromise = (async () => {
      try {
        const rt = getRefreshToken()?.trim();
        if (!rt) return false;
        return await performRefresh(rt);
      } finally {
        refreshPromise = null;
      }
    })();
  }
  return refreshPromise;
}
