import { create } from 'zustand';

export const THEME_STORAGE_KEY = 'examai-admin-theme';

export type ThemeMode = 'light' | 'dark';

export function applyThemeClass(mode: ThemeMode) {
  document.documentElement.classList.toggle('dark', mode === 'dark');
}

function getStoredTheme(): ThemeMode {
  try {
    return localStorage.getItem(THEME_STORAGE_KEY) === 'dark' ? 'dark' : 'light';
  } catch {
    return 'light';
  }
}

const initialTheme: ThemeMode =
  typeof document !== 'undefined' ? getStoredTheme() : 'light';

if (typeof document !== 'undefined') {
  applyThemeClass(initialTheme);
}

interface UIState {
  isSidebarOpen: boolean;
  toggleSidebar: () => void;
  theme: ThemeMode;
  setTheme: (mode: ThemeMode) => void;
  toggleTheme: () => void;
}

export const useUIStore = create<UIState>((set, get) => ({
  isSidebarOpen: true,
  toggleSidebar: () => set((s) => ({ isSidebarOpen: !s.isSidebarOpen })),
  theme: initialTheme,
  setTheme: (mode) => {
    try {
      localStorage.setItem(THEME_STORAGE_KEY, mode);
    } catch {
      /* ignore */
    }
    applyThemeClass(mode);
    set({ theme: mode });
  },
  toggleTheme: () => {
    const next = get().theme === 'dark' ? 'light' : 'dark';
    get().setTheme(next);
  },
}));
