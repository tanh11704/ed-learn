import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useState,
} from 'react';
import * as authApi from '../api/auth.js';
import { isAuthenticated } from '../api/auth.js';
import { AUTH_EXPIRED_EVENT } from '../api/client.js';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [authed, setAuthed] = useState(isAuthenticated());

  useEffect(() => {
    function handleAuthExpired() {
      setAuthed(false);
    }

    window.addEventListener(AUTH_EXPIRED_EVENT, handleAuthExpired);
    return () => {
      window.removeEventListener(AUTH_EXPIRED_EVENT, handleAuthExpired);
    };
  }, []);

  const login = useCallback(async (email, password) => {
    await authApi.login(email, password);
    setAuthed(true);
  }, []);

  const logout = useCallback(async () => {
    await authApi.logout();
    setAuthed(false);
  }, []);

  return (
    <AuthContext.Provider value={{ authed, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
}
