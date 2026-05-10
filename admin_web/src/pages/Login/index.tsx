import React, { useState } from 'react';
import { Mail, Lock, LogIn, Loader2, ShieldAlert } from 'lucide-react';
import { useNavigate, Navigate } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';
import { AuthApiError } from '../../api/authApi';
import ThemeToggle from '../../components/ThemeToggle';

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  
  const { login, isBootstrapping, isAdmin } = useAuth();
  const navigate = useNavigate();

  if (isBootstrapping) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center text-muted-foreground text-sm">
        Đang kiểm tra phiên đăng nhập…
      </div>
    );
  }

  if (isAdmin) {
    return <Navigate to="/" replace />;
  }

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');

    try {
      await login(email, password);
      navigate('/'); // Thành công, vào Admin Dashboard
    } catch (err: unknown) {
      if (err instanceof AuthApiError) {
        setError(err.message);
      } else if (err instanceof Error) {
        setError(err.message);
      } else {
        setError('Đăng nhập thất bại.');
      }
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-6 relative overflow-hidden">
      <div className="absolute top-4 right-4 z-20">
        <ThemeToggle />
      </div>
      {/* Background decoration (Tùy chọn cho đẹp) */}
      <div className="absolute top-[-20%] left-[-10%] w-[40%] h-[50%] bg-primary/10 blur-[120px] rounded-full pointer-events-none"></div>
      
      <div className="w-full max-w-md bg-card border border-border rounded-[32px] p-8 shadow-2xl z-10">
        
        {/* Badge Cảnh báo Admin Only */}
        <div className="flex justify-center mb-6">
          <div className="inline-flex items-center gap-2 px-3 py-1.5 bg-danger/10 border border-danger/25 rounded-full text-danger text-xs font-bold uppercase tracking-wider">
            <ShieldAlert size={14} />
            Khu vực nội bộ
          </div>
        </div>

        {/* Logo / Heading */}
        <div className="text-center mb-8">
          <h1 className="text-2xl font-bold text-foreground mb-2">Cổng Quản Trị ExamAI</h1>
          <p className="text-muted-foreground text-sm">Đăng nhập tài khoản Admin để vận hành hệ thống</p>
        </div>

        {error && (
          <div className="mb-6 p-4 bg-danger/10 border border-danger/25 text-danger rounded-xl text-sm text-center">
            {error}
          </div>
        )}

        {/* Login Form */}
        <form onSubmit={handleLogin} className="space-y-5">
          <div className="space-y-2">
            <label className="text-sm font-medium text-muted-foreground pl-1">Email Quản trị viên</label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                <Mail size={20} className="text-muted-foreground" />
              </div>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full bg-muted border border-border rounded-2xl py-4 pl-12 pr-4 text-foreground focus:border-primary outline-none transition-all"
                placeholder="admin@domain.com"
                required
              />
            </div>
          </div>

          <div className="space-y-2">
            <div className="flex justify-between items-center pl-1">
              <label className="text-sm font-medium text-muted-foreground">Mật khẩu</label>
            </div>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                <Lock size={20} className="text-muted-foreground" />
              </div>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full bg-muted border border-border rounded-2xl py-4 pl-12 pr-4 text-foreground focus:border-primary outline-none transition-all"
                placeholder="••••••••"
                required
              />
            </div>
          </div>

          <button
            type="submit"
            disabled={isLoading || !email || !password}
            className="w-full py-4 mt-4 bg-primary hover:bg-primary/90 text-primary-foreground disabled:bg-muted disabled:border disabled:border-border disabled:text-muted-foreground rounded-2xl font-bold flex items-center justify-center gap-2 transition-all active:scale-95 shadow-lg shadow-brand disabled:shadow-none"
          >
            {isLoading ? (
              <Loader2 className="animate-spin" size={20} />
            ) : (
              <><LogIn size={20} /> Truy cập hệ thống</>
            )}
          </button>
        </form>
      </div>
    </div>
  );
}