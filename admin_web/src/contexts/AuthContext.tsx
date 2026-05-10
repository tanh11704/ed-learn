import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import {
  loginRequest,
  logoutRequest,
  AuthApiError,
} from '../api/authApi';
import {
  buildAdminUserFromAccessToken,
  isAdminPortalRole,
} from '../api/jwtClaims';
import { getAccessToken, clearTokens } from '../api/tokens';
import { getCurrentUserWithTimeout, profileToUser } from '../api/userApi';

export interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'student';
}

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  /** Chỉ true khi user là admin cổng quản trị */
  isAdmin: boolean;
  isBootstrapping: boolean;
  login: (email: string, pass: string) => Promise<void>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

const ADMIN_ONLY_MSG =
  'Chỉ tài khoản ADMIN được vào cổng quản trị.';

async function resolveUserAfterTokens(): Promise<User | null> {
  const access = getAccessToken()?.trim();
  if (!access) return null;

  const fromJwt = buildAdminUserFromAccessToken(access);
  if (!fromJwt) {
    clearTokens();
    return null;
  }

  const profile = await getCurrentUserWithTimeout();
  if (profile) {
    if (!isAdminPortalRole(profile.role)) {
      clearTokens();
      return null;
    }
    return profileToUser(profile);
  }

  return {
    id: fromJwt.id,
    name: fromJwt.name,
    email: fromJwt.email,
    role: 'admin',
  };
}

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isBootstrapping, setIsBootstrapping] = useState(true);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        const u = await resolveUserAfterTokens();
        if (!cancelled) setUser(u);
      } catch {
        if (!cancelled) setUser(null);
      } finally {
        if (!cancelled) setIsBootstrapping(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  const login = async (email: string, pass: string) => {
    const e = email.trim();
    if (!e || !pass) {
      throw new Error('Nhập email và mật khẩu.');
    }

    await loginRequest({ email: e, password: pass });

    const access = getAccessToken()?.trim();
    if (!access) {
      throw new AuthApiError('Thiếu access token sau đăng nhập.', 500);
    }

    const fromJwt = buildAdminUserFromAccessToken(access);
    if (!fromJwt) {
      clearTokens();
      throw new Error(ADMIN_ONLY_MSG);
    }

    const profile = await getCurrentUserWithTimeout();
    if (profile && !isAdminPortalRole(profile.role)) {
      clearTokens();
      throw new Error(ADMIN_ONLY_MSG);
    }

    const nextUser: User = profile
      ? profileToUser(profile)
      : {
          id: fromJwt.id,
          name: fromJwt.name,
          email: fromJwt.email,
          role: 'admin',
        };

    if (nextUser.role !== 'admin') {
      clearTokens();
      throw new Error(ADMIN_ONLY_MSG);
    }

    setUser(nextUser);
  };

  const logout = useCallback(async () => {
    setUser(null);
    await logoutRequest();
  }, []);

  const isAdmin = user?.role === 'admin';

  return (
    <AuthContext.Provider
      value={{
        user,
        isAuthenticated: !!user,
        isAdmin,
        isBootstrapping,
        login,
        logout,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth phải được sử dụng trong AuthProvider');
  }
  return context;
};
