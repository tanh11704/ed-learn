import { useEffect, useState } from 'react';
import { Users, BookOpen, UserPlus, CreditCard } from 'lucide-react';
import { StatItem, Activity, SystemMetrics } from './types';
import StatCards from './components/StatCards';
import SystemHealth from './components/SystemHealth';
import ActivityFeed from './components/ActivityFeed';
import { getDashboardSummary, getTopCourses } from '../../api/statisticsApi';
import { ApiError } from '../../api/ensureOk';
const MOCK_METRICS: SystemMetrics = {
  cpu: 45,
  ram: 68,
  storage: 82,
  aiQueue: 14,
};

function safeCount(v: unknown): number {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
}

function formatInt(n: number): string {
  return safeCount(n).toLocaleString('vi-VN');
}

function formatCurrencyVnd(n: number): string {
  const x = safeCount(n);
  if (x >= 1_000_000) return `${(x / 1_000_000).toFixed(1)}M ₫`;
  return `${formatInt(x)} ₫`;
}

function buildStatsFromSummary(summary: {
  totalStudents?: unknown;
  totalActiveCourses?: unknown;
  currentMonthEnrollments?: unknown;
  currentMonthRevenue?: unknown;
}): StatItem[] {
  return [
    {
      id: '1',
      title: 'Tổng học viên',
      value: formatInt(safeCount(summary.totalStudents)),
      change: '',
      trend: 'neutral',
      icon: Users,
      color: 'text-primary',
    },
    {
      id: '2',
      title: 'Khóa học hoạt động',
      value: formatInt(safeCount(summary.totalActiveCourses)),
      change: '',
      trend: 'neutral',
      icon: BookOpen,
      color: 'text-blue-500',
    },
    {
      id: '3',
      title: 'Đăng ký tháng này',
      value: formatInt(safeCount(summary.currentMonthEnrollments)),
      change: '',
      trend: 'neutral',
      icon: UserPlus,
      color: 'text-success',
    },
    {
      id: '4',
      title: 'Doanh thu tháng',
      value: formatCurrencyVnd(safeCount(summary.currentMonthRevenue)),
      change: '',
      trend: 'neutral',
      icon: CreditCard,
      color: 'text-warning',
    },
  ];
}

/** Hiển thị 0 khi chưa tải hoặc lỗi API — không dùng "—". */
const ZERO_STATS: StatItem[] = buildStatsFromSummary({
  totalStudents: 0,
  totalActiveCourses: 0,
  currentMonthEnrollments: 0,
  currentMonthRevenue: 0,
});

export default function Dashboard() {
  const [stats, setStats] = useState<StatItem[]>(ZERO_STATS);
  const [activities, setActivities] = useState<Activity[]>([]);
  const [loadError, setLoadError] = useState('');

  useEffect(() => {
    let cancelled = false;
    (async () => {
      setLoadError('');
      try {
        const summary = await getDashboardSummary();
        const top = await getTopCourses();
        if (cancelled) return;
        setStats(buildStatsFromSummary(summary));
        setActivities(
          (top ?? []).map((c, i) => ({
            id: i + 1,
            action: `Khóa “${c.title}” — ${formatInt(safeCount(c.totalStudents))} học viên`,
            user: 'Thống kê',
            time: 'Top khóa học',
            type: 'user' as const,
          }))
        );
      } catch (e: unknown) {
        if (!cancelled) {
          setStats(ZERO_STATS);
          setLoadError(e instanceof ApiError ? e.message : 'Không tải được thống kê.');
          setActivities([
            {
              id: 1,
              action: 'Kiểm tra đăng nhập ADMIN và backend /api/v1/statistics',
              user: 'Hệ thống',
              time: 'Gợi ý',
              type: 'system',
            },
          ]);
        }
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  return (
    <div className="space-y-6 max-w-[1600px] mx-auto pb-10">
      <div>
        <h1 className="text-2xl font-bold text-foreground tracking-tight">Tổng quan hệ thống</h1>
        <p className="text-muted-foreground text-sm mt-1">
          Số liệu từ API thống kê; biểu đồ hạ tầng bên dưới vẫn là minh họa.
        </p>
      </div>

      {loadError && (
        <div className="p-4 rounded-xl bg-amber-500/10 border border-amber-500/25 text-amber-700 dark:text-amber-400 text-sm">
          {loadError}
        </div>
      )}

      <StatCards stats={stats} />

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2">
          <SystemHealth metrics={MOCK_METRICS} />
        </div>
        <div className="lg:col-span-1">
          <ActivityFeed activities={activities.length ? activities : []} />
        </div>
      </div>
    </div>
  );
}
