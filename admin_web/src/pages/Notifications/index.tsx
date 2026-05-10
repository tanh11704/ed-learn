import { useMemo, useState } from 'react';
import { Bell, CreditCard, GraduationCap, Megaphone, Settings2 } from 'lucide-react';
import { MOCK_NOTIFICATIONS, type NotificationRow } from '../../mock/placeholders';

const typeMeta: Record<
  NotificationRow['type'],
  { label: string; Icon: typeof Bell; className: string }
> = {
  system: { label: 'Hệ thống', Icon: Settings2, className: 'text-sky-400 bg-sky-500/10 border-sky-500/25' },
  billing: { label: 'Thanh toán', Icon: CreditCard, className: 'text-emerald-400 bg-emerald-500/10 border-emerald-500/25' },
  community: { label: 'Cộng đồng', Icon: Megaphone, className: 'text-violet-400 bg-violet-500/10 border-violet-500/25' },
  exam: { label: 'Đề thi', Icon: GraduationCap, className: 'text-amber-400 bg-amber-500/10 border-amber-500/25' },
};

export default function NotificationsPage() {
  const [items, setItems] = useState(MOCK_NOTIFICATIONS);
  const unread = useMemo(() => items.filter((i) => !i.read).length, [items]);

  const markRead = (id: string) => {
    setItems((prev) => prev.map((n) => (n.id === id ? { ...n, read: true } : n)));
  };

  const markAllRead = () => {
    setItems((prev) => prev.map((n) => ({ ...n, read: true })));
  };

  return (
    <div className="space-y-6 max-w-3xl mx-auto pb-10">
      <div className="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-foreground tracking-tight flex items-center gap-2">
            <Bell className="text-primary" size={28} />
            Thông báo hệ thống
          </h1>
          <p className="text-muted-foreground text-sm mt-1">
            {unread > 0 ? `${unread} chưa đọc` : 'Không có thông báo chưa đọc'} — dữ liệu mẫu.
          </p>
        </div>
        {unread > 0 && (
          <button
            type="button"
            onClick={markAllRead}
            className="text-sm font-medium text-primary hover:text-primary"
          >
            Đánh dấu đã đọc tất cả
          </button>
        )}
      </div>

      <ul className="space-y-3">
        {items.map((n) => {
          const meta = typeMeta[n.type];
          const Icon = meta.Icon;
          return (
            <li key={n.id}>
              <button
                type="button"
                onClick={() => markRead(n.id)}
                className={`w-full text-left rounded-2xl border p-4 transition-colors ${
                  n.read
                    ? 'border-border bg-muted/40 hover:bg-muted/50'
                    : 'border-primary/30 bg-primary-subtle hover:bg-primary-subtle'
                }`}
              >
                <div className="flex gap-3">
                  <div
                    className={`shrink-0 w-10 h-10 rounded-xl border flex items-center justify-center ${meta.className}`}
                  >
                    <Icon size={18} />
                  </div>
                  <div className="min-w-0 flex-1">
                    <div className="flex items-start justify-between gap-2">
                      <p className={`font-medium ${n.read ? 'text-foreground/90' : 'text-foreground'}`}>{n.title}</p>
                      <span className="text-[11px] text-muted-foreground shrink-0">{n.createdAt}</span>
                    </div>
                    <p className="text-sm text-muted-foreground mt-1">{n.body}</p>
                    <div className="mt-2 flex items-center gap-2">
                      <span className="text-[11px] uppercase tracking-wide text-muted-foreground font-semibold">
                        {meta.label}
                      </span>
                      {!n.read && (
                        <span className="w-2 h-2 rounded-full bg-primary" aria-hidden />
                      )}
                    </div>
                  </div>
                </div>
              </button>
            </li>
          );
        })}
      </ul>
    </div>
  );
}
