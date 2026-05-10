import { Moon, Sun } from 'lucide-react';
import { useUIStore } from '../store/useUIStore';

export default function ThemeToggle() {
  const { theme, toggleTheme } = useUIStore();
  const isDark = theme === 'dark';

  return (
    <button
      type="button"
      onClick={toggleTheme}
      className="p-2 rounded-full text-muted-foreground hover:bg-muted hover:text-foreground transition-colors border border-transparent hover:border-border"
      title={isDark ? 'Chế độ sáng' : 'Chế độ tối'}
      aria-label={isDark ? 'Chuyển sang giao diện sáng' : 'Chuyển sang giao diện tối'}
    >
      {isDark ? <Sun size={18} /> : <Moon size={18} />}
    </button>
  );
}
