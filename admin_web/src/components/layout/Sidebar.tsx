import { motion } from 'framer-motion';
import { NavLink } from 'react-router-dom';
import { Settings, ChevronLeft } from 'lucide-react';
import { useUIStore } from '../../store/useUIStore';
import { ADMIN_SETTINGS_PATH, ADMIN_SIDEBAR_GROUPS } from '../../constants/navigation';

const badgeClass: Record<'neutral' | 'info', string> = {
  neutral:
    'text-[10px] font-semibold uppercase tracking-wide px-1.5 py-0.5 rounded-md border border-border text-muted-foreground bg-muted',
  info: 'text-[10px] font-semibold uppercase tracking-wide px-1.5 py-0.5 rounded-md border border-primary/30 text-primary bg-primary-subtle',
};

export default function Sidebar() {
  const { isSidebarOpen, toggleSidebar } = useUIStore();

  return (
    <motion.aside
      animate={{ width: isSidebarOpen ? 260 : 80 }}
      className="fixed left-0 top-0 h-screen bg-sidebar border-r border-sidebar-border z-50 flex flex-col overflow-hidden transition-colors duration-300"
    >
      <div className="h-16 flex items-center justify-between px-4 border-b border-sidebar-border shrink-0">
        <div className="flex items-center gap-3 overflow-hidden">
          <div className="w-8 h-8 bg-primary rounded-xl flex items-center justify-center text-primary-foreground font-bold shrink-0 shadow-brand">
            E
          </div>
          {isSidebarOpen && (
            <motion.span
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="font-bold text-lg text-foreground tracking-tight whitespace-nowrap"
            >
              ExamAI
            </motion.span>
          )}
        </div>

        <button
          type="button"
          onClick={toggleSidebar}
          className="p-1.5 rounded-lg bg-muted hover:bg-sidebar-hover text-muted-foreground border border-border transition-colors absolute right-[-12px] top-4 z-50"
        >
          <ChevronLeft size={16} className={`transition-transform ${!isSidebarOpen ? 'rotate-180' : ''}`} />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto py-6 space-y-6 scrollbar-hide">
        {ADMIN_SIDEBAR_GROUPS.map((group, groupIndex) => (
          <div key={groupIndex} className="px-3">
            {isSidebarOpen ? (
              <h3 className="px-3 mb-2 text-[11px] font-bold uppercase text-sidebar-muted tracking-wider">
                {group.title}
              </h3>
            ) : (
              <div className="h-4 border-b border-sidebar-border mb-4 mx-2" />
            )}

            <div className="space-y-1">
              {group.items.map((item, itemIndex) => {
                const Icon = item.icon;
                const tone = item.badge?.tone ?? 'neutral';
                return (
                  <NavLink
                    key={`${item.path}-${itemIndex}`}
                    to={item.path}
                    className={({ isActive }) =>
                      `flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all group min-h-[2.75rem] ${
                        isActive
                          ? 'bg-primary-subtle text-primary font-medium'
                          : 'text-sidebar-muted hover:text-foreground hover:bg-sidebar-hover'
                      }`
                    }
                    title={!isSidebarOpen ? item.label : undefined}
                  >
                    <Icon size={20} className="shrink-0 transition-colors group-hover:text-primary" />
                    {isSidebarOpen && (
                      <span className="text-sm truncate flex-1 min-w-0">{item.label}</span>
                    )}
                    {isSidebarOpen && item.badge && (
                      <span className={`shrink-0 ${badgeClass[tone]}`}>{item.badge.text}</span>
                    )}
                  </NavLink>
                );
              })}
            </div>
          </div>
        ))}
      </div>

      <div className="p-4 border-t border-sidebar-border shrink-0">
        <div className={`flex items-center gap-3 ${!isSidebarOpen && 'justify-center'}`}>
          <div className="w-9 h-9 rounded-full bg-muted flex items-center justify-center shrink-0 border border-border">
            <span className="text-sm font-bold text-foreground">AD</span>
          </div>

          {isSidebarOpen && (
            <div className="flex-1 overflow-hidden">
              <p className="text-sm font-medium text-foreground truncate">System Admin</p>
              <p className="text-xs text-muted-foreground truncate">admin@examai.vn</p>
            </div>
          )}

          <NavLink
            to={ADMIN_SETTINGS_PATH}
            className={({ isActive }) =>
              `p-2 rounded-xl transition-all shrink-0 ${
                isActive
                  ? 'bg-primary-subtle text-primary'
                  : 'text-sidebar-muted hover:bg-sidebar-hover hover:text-foreground'
              }`
            }
            title="Cài đặt hệ thống"
          >
            <Settings size={20} />
          </NavLink>
        </div>
      </div>
    </motion.aside>
  );
}
