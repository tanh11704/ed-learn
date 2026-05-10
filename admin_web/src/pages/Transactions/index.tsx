import { useMemo, useState } from 'react';
import { Receipt, Search } from 'lucide-react';
import { MOCK_TRANSACTIONS } from '../../mock/placeholders';

const statusStyle: Record<string, string> = {
  completed: 'bg-emerald-500/15 text-emerald-400 border-emerald-500/25',
  pending: 'bg-amber-500/15 text-amber-400 border-amber-500/25',
  failed: 'bg-red-500/15 text-red-400 border-red-500/25',
  refunded: 'bg-muted/60 text-foreground/90 border-border',
};

const statusLabel: Record<string, string> = {
  completed: 'Thành công',
  pending: 'Đang xử lý',
  failed: 'Thất bại',
  refunded: 'Hoàn tiền',
};

export default function TransactionsPage() {
  const [q, setQ] = useState('');
  const [status, setStatus] = useState<string>('all');

  const rows = useMemo(() => {
    return MOCK_TRANSACTIONS.filter((t) => {
      const matchQ =
        !q.trim() ||
        t.id.toLowerCase().includes(q.toLowerCase()) ||
        t.userEmail.toLowerCase().includes(q.toLowerCase()) ||
        t.userName.toLowerCase().includes(q.toLowerCase());
      const matchS = status === 'all' || t.status === status;
      return matchQ && matchS;
    });
  }, [q, status]);

  return (
    <div className="space-y-6 max-w-7xl mx-auto pb-10">
      <div>
        <h1 className="text-2xl font-bold text-foreground tracking-tight flex items-center gap-2">
          <Receipt className="text-primary" size={28} />
          Lịch sử giao dịch
        </h1>
        <p className="text-muted-foreground text-sm mt-1">Theo dõi thanh toán và hoàn tiền (dữ liệu mẫu).</p>
      </div>

      <div className="flex flex-col sm:flex-row gap-3">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" size={16} />
          <input
            value={q}
            onChange={(e) => setQ(e.target.value)}
            placeholder="Mã GD, email, tên..."
            className="w-full bg-card border border-border rounded-xl py-2.5 pl-10 pr-4 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-primary"
          />
        </div>
        <select
          value={status}
          onChange={(e) => setStatus(e.target.value)}
          className="bg-card border border-border rounded-xl py-2.5 px-3 text-sm text-foreground focus:outline-none focus:ring-1 focus:ring-primary"
        >
          <option value="all">Mọi trạng thái</option>
          <option value="completed">Thành công</option>
          <option value="pending">Đang xử lý</option>
          <option value="failed">Thất bại</option>
          <option value="refunded">Hoàn tiền</option>
        </select>
      </div>

      <div className="rounded-2xl border border-border bg-muted/50 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border text-left text-muted-foreground uppercase text-[11px] tracking-wider">
                <th className="px-5 py-3 font-semibold">Mã</th>
                <th className="px-5 py-3 font-semibold">Người dùng</th>
                <th className="px-5 py-3 font-semibold hidden lg:table-cell">Gói / mô tả</th>
                <th className="px-5 py-3 font-semibold">Số tiền</th>
                <th className="px-5 py-3 font-semibold">Trạng thái</th>
                <th className="px-5 py-3 font-semibold hidden md:table-cell">Thời điểm</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((t) => (
                <tr key={t.id} className="border-b border-border hover:bg-muted/40 transition-colors">
                  <td className="px-5 py-4 font-mono text-xs text-foreground/90">{t.id}</td>
                  <td className="px-5 py-4">
                    <p className="text-foreground font-medium">{t.userName}</p>
                    <p className="text-muted-foreground text-xs">{t.userEmail}</p>
                  </td>
                  <td className="px-5 py-4 text-muted-foreground hidden lg:table-cell">{t.planName}</td>
                  <td
                    className={`px-5 py-4 tabular-nums font-medium ${
                      t.amount < 0 ? 'text-red-400' : 'text-foreground'
                    }`}
                  >
                    {t.amount.toLocaleString('vi-VN')} {t.currency}
                  </td>
                  <td className="px-5 py-4">
                    <span
                      className={`text-xs font-medium px-2 py-0.5 rounded-lg border ${statusStyle[t.status]}`}
                    >
                      {statusLabel[t.status]}
                    </span>
                  </td>
                  <td className="px-5 py-4 text-muted-foreground hidden md:table-cell whitespace-nowrap">
                    {t.paidAt}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        {rows.length === 0 && (
          <p className="text-center text-muted-foreground text-sm py-10">Không có giao dịch khớp bộ lọc.</p>
        )}
      </div>
    </div>
  );
}
