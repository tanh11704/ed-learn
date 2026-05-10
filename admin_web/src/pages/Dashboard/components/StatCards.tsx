import { ArrowUpRight, ArrowDownRight } from 'lucide-react';
import { StatItem } from '../types';

interface StatCardsProps {
  stats: StatItem[];
}

export default function StatCards({ stats }: StatCardsProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      {stats.map((stat) => {
        const Icon = stat.icon;
        return (
          <div key={stat.id} className="bg-sidebar p-6 rounded-xl border border-border hover:border-border transition-colors">
            <div className="flex justify-between items-start mb-4">
              <div className={`p-3 rounded-lg bg-muted ${stat.color}`}>
                <Icon size={24} />
              </div>
              {stat.change ? (
                <div
                  className={`flex items-center gap-1 text-sm font-medium ${
                    stat.trend === 'up'
                      ? 'text-success'
                      : stat.trend === 'down'
                        ? 'text-danger'
                        : 'text-muted-foreground'
                  }`}
                >
                  {stat.trend === 'up' && <ArrowUpRight size={16} />}
                  {stat.trend === 'down' && <ArrowDownRight size={16} />}
                  {stat.change}
                </div>
              ) : null}
            </div>
            <div>
              <h4 className="text-muted-foreground text-sm font-medium mb-1">{stat.title}</h4>
              <h2 className="text-2xl font-bold text-foreground">{stat.value}</h2>
            </div>
          </div>
        );
      })}
    </div>
  );
}