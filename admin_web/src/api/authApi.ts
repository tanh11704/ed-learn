import { customBaseQuery, messageFromErrorBody } from './customBaseQuery';
import type {
  AuthResponseDto,
  LoginRequestDto,
  RefreshTokenRequestDto,
} from './models/auth.dto';
import { clearTokens, getAccessToken, getRefreshToken, setTokens } from './tokens';

export class AuthApiError extends Error {
  constructor(
    message: string,
    public status: number,
    public body?: unknown
  ) {
    super(message);
    this.name = 'AuthApiError';
  }
}

/**
 * POST /api/v1/auth/login — OpenAPI `login`
 */
export async function loginRequest(
  body: LoginRequestDto,
  options?: { persistTokens?: boolean; signal?: AbortSignal }
): Promise<AuthResponseDto> {
  const persist = options?.persistTokens !== false;
  const res = await customBaseQuery<AuthResponseDto>({
    url: '/api/v1/auth/login',
    method: 'POST',
    body: {
      email: body.email.trim(),
      password: body.password,
    },
    skipAuth: true,
    skipRefreshRetry: true,
    signal: options?.signal,
  });

  if ('error' in res) {
    const { status, data } = res.error;
    const fallback =
      status === 401
        ? 'Sai email hoặc mật khẩu.'
        : status === 0
          ? 'Không kết nối được máy chủ.'
          : `Lỗi ${status}`;
    throw new AuthApiError(messageFromErrorBody(data, fallback), status, data);
  }

  const { accessToken, refreshToken } = res.data;
  if (!accessToken?.trim() || !refreshToken?.trim()) {
    throw new AuthApiError('Phản hồi đăng nhập thiếu token.', 500, res.data);
  }

  if (persist) {
    setTokens(accessToken, refreshToken);
  }

  return res.data;
}

/**
 * POST /api/v1/auth/refresh
 */
export async function refreshTokenRequest(
  body: RefreshTokenRequestDto,
  options?: { persistTokens?: boolean; signal?: AbortSignal }
): Promise<AuthResponseDto> {
  const persist = options?.persistTokens !== false;
  const res = await customBaseQuery<AuthResponseDto>({
    url: '/api/v1/auth/refresh',
    method: 'POST',
    body: { refreshToken: body.refreshToken.trim() },
    skipAuth: true,
    skipRefreshRetry: true,
    signal: options?.signal,
  });

  if ('error' in res) {
    const { status, data } = res.error;
    throw new AuthApiError(
      messageFromErrorBody(data, 'Không làm mới được phiên đăng nhập.'),
      status,
      data
    );
  }

  const { accessToken, refreshToken } = res.data;
  if (!accessToken?.trim() || !refreshToken?.trim()) {
    throw new AuthApiError('Phản hồi refresh thiếu token.', 500, res.data);
  }

  if (persist) {
    setTokens(accessToken, refreshToken);
  }

  return res.data;
}

/**
 * POST /api/v1/auth/logout — luôn xóa token cục bộ sau khi gọi (best-effort).
 */
export async function logoutRequest(): Promise<void> {
  const at = getAccessToken()?.trim();
  const rt = getRefreshToken()?.trim();

  if (at && rt) {
    await customBaseQuery({
      url: '/api/v1/auth/logout',
      method: 'POST',
      body: { refreshToken: rt },
      skipAuth: true,
      skipRefreshRetry: true,
      headers: { Authorization: `Bearer ${at}` },
    });
  }

  clearTokens();
}
