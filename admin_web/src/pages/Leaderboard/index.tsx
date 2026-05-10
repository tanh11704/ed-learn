import { useState } from 'react';
import { Trophy, Flame } from 'lucide-react';
import { MOCK_LEADERBOARD } from '../../mock/placeholders';

export default function LeaderboardPage() {
  const [scope, setScope] = useState<'month' | 'term'>('month');

  return (
    <div className="space-y-6 max-w-7xl mx-auto pb-10">
      <div className="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-foreground tracking-tight flex items-center gap-2">
            <Trophy className="text-amber-400" size={28} />
            Bảng xếp hạng
          </h1>
          <p className="text-muted-foreground text-sm mt-1">
            Xếp hạng điểm tích lũy (demo). Chọn khung thời gian để lọc sau khi có API.
          </p>
        </div>
        <div className="flex rounded-xl border border-border bg-muted/50 p-1">
          {(
            [
              { id: 'month' as const, label: 'Tháng này' },
              { id: 'term' as const, label: 'Học kỳ' },
            ] as const
          ).map((t) => (
            <button
              key={t.id}
              type="button"
              onClick={() => setScope(t.id)}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                scope === t.id ? 'bg-primary-subtle text-primary' : 'text-muted-foreground hover:text-foreground'
              }`}
            >
              {t.label}
            </button>
          ))}
        </div>
      </div>

      <div className="rounded-2xl border border-border bg-muted/50 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border text-left text-muted-foreground uppercase text-[11px] tracking-wider">
                <th className="px-5 py-3 font-semibold w-16">Hạng</th>
                <th className="px-5 py-3 font-semibold">Học sinh</th>
                <th className="px-5 py-3 font-semibold hidden sm:table-cell">Trường</th>
                <th className="px-5 py-3 font-semibold">Điểm</th>
                <th className="px-5 py-3 font-semibold">Streak</th>
                <th className="px-5 py-3 font-semibold">Gói</th>
              </tr>
            </thead>
            <tbody>
              {MOCK_LEADERBOARD.map((row) => (
                <tr key={row.rank} className="border-b border-border hover:bg-muted/40 transition-colors">
                  <td className="px-5 py-4">
                    <span
                      className={`inline-flex items-center justify-center w-8 h-8 rounded-lg font-bold text-sm ${
                        row.rank === 1
                          ? 'bg-amber-500/20 text-amber-400'
                          : row.rank === 2
                            ? 'bg-muted/50 text-foreground'
                            : row.rank === 3
                              ? 'bg-orange-900/30 text-orange-300'
                              : 'text-muted-foreground'
                      }`}
                    >
                      {row.rank}
                    </span>
                  </td>
                  <td className="px-5 py-4 font-medium text-foreground">{row.studentName}</td>
                  <td className="px-5 py-4 text-muted-foreground hidden sm:table-cell">{row.school}</td>
                  <td className="px-5 py-4 text-foreground tabular-nums">{row.score.toLocaleString('vi-VN')}</td>
                  <td className="px-5 py-4">
                    <span className="inline-flex items-center gap-1 text-orange-400">
                      <Flame size={14} />
                      {row.streak}
                    </span>
                  </td>
                  <td className="px-5 py-4">
                    <span
                      className={`text-xs font-medium px-2 py-0.5 rounded-md border ${
                        row.plan === 'VIP'
                          ? 'border-purple-500/40 text-purple-300 bg-purple-500/10'
                          : row.plan === 'PREMIUM'
                            ? 'border-primary/40 text-primary bg-primary-subtle'
                            : 'border-border text-muted-foreground'
                      }`}
                    >
                      {row.plan}
                    </span>
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
