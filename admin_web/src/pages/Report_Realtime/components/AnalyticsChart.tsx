import React, { useMemo } from 'react';
import {
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts';
import { useUIStore } from '../../../store/useUIStore';

const data = [
  { name: 'T2', activeUsers: 400, avgScore: 7.5 },
  { name: 'T3', activeUsers: 300, avgScore: 7.8 },
  { name: 'T4', activeUsers: 550, avgScore: 8.1 },
  { name: 'T5', activeUsers: 450, avgScore: 7.9 },
  { name: 'T6', activeUsers: 600, avgScore: 8.4 },
  { name: 'T7', activeUsers: 800, avgScore: 8.7 },
  { name: 'CN', activeUsers: 750, avgScore: 8.5 },
];

const PRIMARY = '#1890ff';

export default function AnalyticsChart() {
  const theme = useUIStore((s) => s.theme);
  const isDark = theme === 'dark';

  const chartPalette = useMemo(
    () =>
      isDark
        ? {
            grid: '#2a3441',
            axis: '#9ca3af',
            tooltipBg: '#151b24',
            tooltipBorder: '#2a3441',
            tooltipColor: '#f3f4f6',
            tooltipItem: '#e5e7eb',
          }
        : {
            grid: '#e5e7eb',
            axis: '#6b7280',
            tooltipBg: '#ffffff',
            tooltipBorder: '#e5e7eb',
            tooltipColor: '#1f2937',
            tooltipItem: '#374151',
          },
    [isDark]
  );

  return (
    <div className="w-full h-full min-h-[350px] flex flex-col">
      <h3 className="text-xl font-bold mb-6 text-foreground">Xu hướng Học tập & Truy cập</h3>
      <div className="flex-1 w-full h-full">
        <ResponsiveContainer width="100%" height="100%">
          <AreaChart data={data} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
            <defs>
              <linearGradient id="colorUsers" x1="0" y1="0" x2="0" y2="1">
                <stop offset="5%" stopColor={PRIMARY} stopOpacity={0.35} />
                <stop offset="95%" stopColor={PRIMARY} stopOpacity={0} />
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" stroke={chartPalette.grid} vertical={false} />
            <XAxis
              dataKey="name"
              stroke={chartPalette.axis}
              tick={{ fill: chartPalette.axis }}
              tickLine={false}
              axisLine={false}
            />
            <YAxis
              stroke={chartPalette.axis}
              tick={{ fill: chartPalette.axis }}
              tickLine={false}
              axisLine={false}
            />
            <Tooltip
              contentStyle={{
                backgroundColor: chartPalette.tooltipBg,
                borderColor: chartPalette.tooltipBorder,
                borderRadius: '12px',
                color: chartPalette.tooltipColor,
              }}
              itemStyle={{ color: chartPalette.tooltipItem }}
            />
            <Area
              type="monotone"
              dataKey="activeUsers"
              name="Lượt truy cập"
              stroke={PRIMARY}
              strokeWidth={3}
              fillOpacity={1}
              fill="url(#colorUsers)"
            />
          </AreaChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
