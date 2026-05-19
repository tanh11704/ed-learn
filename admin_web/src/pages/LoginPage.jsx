import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Box } from 'lucide-react';
import { useAuth } from '../context/AuthContext.jsx';
import Alert from '../components/Alert.jsx';

export default function LoginPage() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      await login(email.trim(), password);
      navigate('/');
    } catch (err) {
      setError(err.message || 'Đăng nhập thất bại');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="login-page">
      <div className="login-app-brand" aria-label="EdLearn Admin">
        <span className="login-app-logo">
          <Box size={25} strokeWidth={2.7} />
        </span>
        <span>EdLearn</span>
      </div>

      <form className="login-card" onSubmit={handleSubmit}>
        <p className="login-kicker">Vui lòng nhập thông tin</p>
        <h1>Chào mừng trở lại</h1>

        {error && <Alert>{error}</Alert>}

        <label className="login-field">
          <span className="sr-only">Địa chỉ email</span>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Địa chỉ email"
            required
            autoComplete="username"
          />
        </label>

        <label className="login-field">
          <span className="sr-only">Mật khẩu</span>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Mật khẩu"
            required
            autoComplete="current-password"
          />
        </label>

        <div className="login-options">
          <label className="login-remember">
            <input type="checkbox" />
            <span>Ghi nhớ trong 30 ngày</span>
          </label>
          <a href="#forgot-password">Quên mật khẩu</a>
        </div>

        <button type="submit" className="btn btn-primary" disabled={loading}>
          {loading ? 'Đang đăng nhập...' : 'Đăng nhập'}
        </button>
      </form>
    </div>
  );
}
