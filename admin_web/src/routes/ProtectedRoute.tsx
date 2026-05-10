import type { ReactNode } from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

type ProtectedRouteProps = {
  children: ReactNode;
};

/**
 * Chỉ cho phép admin đã đăng nhập vào shell quản trị.
 */
export function ProtectedRoute({ children }: ProtectedRouteProps) {
  const { user, isBootstrapping, isAdmin } = useAuth();
  const location = useLocation();

  if (isBootstrapping) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center text-muted-foreground text-sm">
        Đang kiểm tra phiên đăng nhập…
      </div>
    );
  }

  if (!user || !isAdmin) {
    return (
      <Navigate to="/login" replace state={{ from: location.pathname }} />
    );
  }

  return <>{children}</>;
}
