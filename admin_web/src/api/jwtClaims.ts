/**
 * Decode JWT payload (không verify chữ ký) — chỉ dùng cho token do server cấp.
 */
export function decodeJwtPayload(token: string): Record<string, unknown> | null {
  try {
    const parts = token.split('.');
    if (parts.length !== 3 || !parts[1]) return null;
    let base64 = parts[1].replace(/-/g, '+').replace(/_/g, '/');
    while (base64.length % 4) base64 += '=';
    const json = atob(base64);
    return JSON.parse(json) as Record<string, unknown>;
  } catch {
    return null;
  }
}

export function getJwtExpSeconds(accessToken: string): number | null {
  const p = decodeJwtPayload(accessToken);
  if (!p || typeof p.exp !== 'number') return null;
  return p.exp;
}

/** Khớp Role backend (ADMIN | USER) và biến thể ROLE_ADMIN. */
export function isAdminPortalRole(role: string): boolean {
  const r = role.toUpperCase();
  return (
    r === 'ADMIN' ||
    r === 'ROLE_ADMIN' ||
    r === 'SUPER_ADMIN' ||
    r.includes('ADMIN')
  );
}

export type JwtDerivedAdminUser = {
  id: string;
  email: string;
  name: string;
  role: 'admin';
};

/**
 * Trả về user cổng admin từ access token nếu claim role là ADMIN; ngược lại null.
 */
export function buildAdminUserFromAccessToken(
  accessToken: string
): JwtDerivedAdminUser | null {
  const claims = decodeJwtPayload(accessToken);
  if (!claims) return null;
  const role = typeof claims.role === 'string' ? claims.role : '';
  if (!isAdminPortalRole(role)) return null;

  const email =
    typeof claims.sub === 'string' ? claims.sub : '';
  const userId =
    typeof claims.userId === 'string' ? claims.userId : '';
  const id = userId || email;
  const name = email.includes('@') ? email.split('@')[0]! : email || 'Admin';

  if (!email) return null;

  return { id, email, name, role: 'admin' };
}
