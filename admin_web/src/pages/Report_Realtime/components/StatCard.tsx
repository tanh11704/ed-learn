import React from 'react';
import { TrendingUp, TrendingDown } from 'lucide-react';
import { StatData } from '../types';

interface StatCardProps {
  data: StatData;
  icon: React.ReactNode;
  colorClass: string;
}

export default function StatCard({ data, icon, colorClass }: StatCardProps) {
  return (
    <div className="bg-card border border-border rounded-[24px] p-6 hover:border-border transition-all">
      <div className="flex justify-between items-start mb-4">
        <div className={`p-3 rounded-2xl ${colorClass}`}>
          {icon}
        </div>
        <div className={`flex items-center gap-1 text-sm font-bold px-2 py-1 rounded-lg ${data.isUp ? 'bg-emerald-500/10 text-emerald-400' : 'bg-rose-500/10 text-rose-400'}`}>
          {data.isUp ? <TrendingUp size={16} /> : <TrendingDown size={16} />}
          {data.trend}%
        </div>
      </div>
      <div>
        <p className="text-muted-foreground text-sm font-medium mb-1">{data.title}</p>
        <h3 className="text-3xl font-bold text-foreground">{data.value}</h3>
      </div>
    </div>
  );
}