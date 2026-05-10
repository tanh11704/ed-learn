import { useMemo, useState } from 'react';
import { Shield, Search, Users } from 'lucide-react';
import { MOCK_ROLES } from '../../mock/placeholders';

export default function RolesManagement() {
  const [q, setQ] = useState('');

  const rows = useMemo(() => {
    const s = q.trim().toLowerCase();
    if (!s) return MOCK_ROLES;
    return MOCK_ROLES.filter(
      (r) =>
        r.name.toLowerCase().includes(s) ||
        r.description.toLowerCase().includes(s) ||
        r.permissions.some((p) => p.toLowerCase().includes(s))
    );
  }, [q]);

  return (
    <div className="space-y-6 max-w-7xl mx-auto pb-10">
      <div className="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-foreground tracking-tight flex items-center gap-2">
            <Shield className="text-primary" size={28} />
            Phân quyền &amp; vai trò
          </h1>
          <p className="text-muted-foreground text-sm mt-1">
            Gom nhóm quyền theo vai trò. Dữ liệu mẫu — sẽ đồng bộ backend sau.
          </p>
        </div>
        <div className="relative w-full sm:w-80">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" size={16} />
          <input
            value={q}
            onChange={(e) => setQ(e.target.value)}
            placeholder="Tìm vai trò, mô tả, quyền..."
            className="w-full bg-card border border-border rounded-xl py-2.5 pl-10 pr-4 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-primary"
          />
        </div>
      </div>

      <div className="rounded-2xl border border-border bg-muted/50 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border text-left text-muted-foreground uppercase text-[11px] tracking-wider">
                <th className="px-5 py-3 font-semibold">Vai trò</th>
                <th className="px-5 py-3 font-semibold hidden md:table-cell">Mô tả</th>
                <th className="px-5 py-3 font-semibold">Người dùng</th>
                <th className="px-5 py-3 font-semibold">Quyền (rút gọn)</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((r) => (
                <tr key={r.id} className="border-b border-border hover:bg-muted/40 transition-colors">
                  <td className="px-5 py-4">
                    <p className="font-medium text-foreground">{r.name}</p>
                    <p className="text-muted-foreground text-xs mt-0.5 md:hidden">{r.description}</p>
                  </td>
                  <td className="px-5 py-4 text-muted-foreground hidden md:table-cell max-w-md">{r.description}</td>
                  <td className="px-5 py-4">
                    <span className="inline-flex items-center gap-1.5 text-foreground/90">
                      <Users size={14} className="text-primary" />
                      {r.userCount}
                    </span>
                  </td>
                  <td className="px-5 py-4">
                    <div className="flex flex-wrap gap-1.5">
                      {r.permissions.slice(0, 4).map((p) => (
                        <span
                          key={p}
                          className="px-2 py-0.5 rounded-lg bg-muted text-foreground/90 text-xs border border-border"
                        >
                          {p}
                        </span>
                      ))}
                      {r.permissions.length > 4 && (
                        <span className="text-xs text-muted-foreground self-center">+{r.permissions.length - 4}</span>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
