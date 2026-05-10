import { customBaseQuery } from './customBaseQuery';
import type { UserProfileDto } from './models/user.dto';
import { isAdminPortalRole } from './jwtClaims';

export async function getCurrentUser(options?: {
  signal?: AbortSignal;
}): Promise<UserProfileDto | null> {
  const res = await customBaseQuery<UserProfileDto>({
    url: '/api/v1/users/me',
    method: 'GET',
    signal: options?.signal,
  });

  if ('error' in res) return null;

  const r = res.data;
  return {
    id: String(r.id ?? ''),
    email: String(r.email ?? ''),
    fullName: String(r.fullName ?? ''),
    role: String(r.role ?? ''),
  };
}

/** Tránh treo UI khi backend không phản hồi (sai IP, firewall, v.v.). */
export async function getCurrentUserWithTimeout(
  ms = 12_000
): Promise<UserProfileDto | null> {
  const ac = new AbortController();
  const t = setTimeout(() => ac.abort(), ms);
  try {
    return await getCurrentUser({ signal: ac.signal });
  } finally {
    clearTimeout(t);
  }
}

export function profileToUser(p: UserProfileDto): {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'student';
} {
  return {
    id: p.id,
    email: p.email,
    name: p.fullName?.trim() ? p.fullName : p.email,
    role: isAdminPortalRole(p.role) ? 'admin' : 'student',
  };
}
