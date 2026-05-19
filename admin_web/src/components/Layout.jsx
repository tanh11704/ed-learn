import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import {
  Award,
  BookOpen,
  Brain,
  ClipboardCheck,
  FileText,
  LayoutDashboard,
  LogOut,
  Medal,
  NotebookTabs,
  Repeat,
  Target,
  UserRound,
} from 'lucide-react';
import { useAuth } from '../context/AuthContext.jsx';

const nav = [
  { to: '/', icon: LayoutDashboard, label: 'Tổng quan' },
  { to: '/courses', icon: BookOpen, label: 'Khóa học' },
  { to: '/course-progress', icon: ClipboardCheck, label: 'Tiến độ học' },
  { to: '/exams', icon: FileText, label: 'Đề thi' },
  { to: '/exam-sessions', icon: NotebookTabs, label: 'Lượt làm đề' },
  { to: '/badges', icon: Award, label: 'Huy hiệu' },
  { to: '/user-badges', icon: Medal, label: 'Huy hiệu học viên' },
  { to: '/users', icon: UserRound, label: 'Học viên' },
  { to: '/error-bank', icon: Repeat, label: 'Lỗi sai' },
  { to: '/streak-tasks', icon: Target, label: 'Streak/Nhiệm vụ' },
  { to: '/assessment', icon: ClipboardCheck, label: 'Đánh giá đầu vào' },
  { to: '/ai-solver', icon: Brain, label: 'AI giải bài' },
];

export default function Layout() {
  const { logout } = useAuth();
  const navigate = useNavigate();

  async function handleLogout() {
    await logout();
    navigate('/login');
  }

  return (
    <div className="admin-shell">
      <aside className="admin-sidebar">
        <div className="admin-brand">
          <span className="admin-brand-dot" />
          EdLearn Admin
        </div>
        <nav className="admin-nav">
          {nav.map(({ to, icon: Icon, label }) => (
            <NavLink
              key={to}
              to={to}
              end={to === '/'}
              className={({ isActive }) =>
                `admin-nav-link${isActive ? ' active' : ''}`
              }
            >
              <Icon size={18} />
              {label}
            </NavLink>
          ))}
        </nav>
        <button type="button" className="admin-logout" onClick={handleLogout}>
          <LogOut size={18} />
          Đăng xuất
        </button>
      </aside>
      <main className="admin-main">
        <Outlet />
      </main>
    </div>
  );
}
