import { Outlet } from 'react-router-dom';
import { Search, Bell, Activity } from 'lucide-react';
import Sidebar from '../components/layout/Sidebar';
import ThemeToggle from '../components/ThemeToggle';
import { useUIStore } from '../store/useUIStore';

export default function AdminLayout() {
  const { isSidebarOpen } = useUIStore();

  return (
    <div className="min-h-screen bg-background">
      <Sidebar />
      
      <div 
        className="transition-all duration-300 ease-in-out flex flex-col min-h-screen"
        style={{ paddingLeft: isSidebarOpen ? '260px' : '80px' }}
      >
        {/* Topbar */}
        <header className="h-16 border-b border-border bg-background/80 backdrop-blur-md sticky top-0 z-40 px-8 flex items-center justify-between">
          <div className="flex items-center gap-4 w-96">
            <div className="relative w-full group">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground group-focus-within:text-primary transition-colors" size={16} />
              <input 
                placeholder="Tìm kiếm học sinh, đề thi (Cmd + K)..." 
                className="w-full bg-muted/50 border border-border rounded-lg py-2 pl-10 pr-4 text-sm text-foreground focus:outline-none focus:ring-1 focus:ring-primary focus:bg-card transition-all placeholder:text-muted-foreground" 
              />
            </div>
          </div>

          <div className="flex items-center gap-2 sm:gap-4">
            <ThemeToggle />
            {/* AI Status */}
            <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-success/10 border border-success/20">
              <Activity size={14} className="text-success animate-pulse" />
              <span className="text-xs font-medium text-success">AI Active</span>
            </div>
            
            <button className="relative p-2 text-muted-foreground hover:bg-muted rounded-full transition-colors">
              <Bell size={18} />
              <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-primary rounded-full"></span>
            </button>
          </div>
        </header>

        {/* Main Content Area */}
        <main className="p-8 flex-1">
          <Outlet /> {/* Các trang con sẽ render ở đây */}
        </main>
      </div>
    </div>
  );
}