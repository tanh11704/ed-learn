import React from 'react';
import { Clock, CheckCircle, Edit3, PlayCircle } from 'lucide-react';
import { Activity } from '../types';

export default function RecentActivity({ activities }: { activities: Activity[] }) {
  const getActionIcon = (action: string) => {
    switch (action) {
      case 'nộp bài': return <CheckCircle size={16} className="text-emerald-400" />;
      case 'đang làm bài': return <PlayCircle size={16} className="text-blue-400" />;
      case 'tạo mới': return <Edit3 size={16} className="text-primary" />;
      default: return <Clock size={16} className="text-muted-foreground" />;
    }
  };

  return (
    <div className="bg-card border border-border rounded-[24px] p-6 flex-1">
      <h2 className="text-xl font-bold mb-6 flex items-center gap-2">
        <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
        Hoạt động Real-time
      </h2>
      <div className="space-y-4 max-h-[400px] overflow-y-auto pr-2 custom-scrollbar">
        {activities.map((item) => (
          <div key={item.id} className="flex items-start gap-4 p-4 rounded-2xl bg-muted border border-border/80">
            <div className="w-10 h-10 rounded-full bg-muted flex items-center justify-center font-bold text-sm border border-border">
              {item.user.charAt(0)}
            </div>
            <div className="flex-1">
              <p className="text-sm">
                <span className="font-bold text-foreground">{item.user}</span>{' '}
                <span className="text-muted-foreground">{item.action}</span>{' '}
                <span className="font-medium text-primary">{item.target}</span>
              </p>
              <div className="flex items-center gap-3 mt-2 text-xs text-muted-foreground">
                <span className="flex items-center gap-1">{getActionIcon(item.action)} {item.time}</span>
                {item.score && (
                  <span className="px-2 py-0.5 bg-emerald-500/10 text-emerald-400 rounded-md font-bold">
                    Điểm: {item.score}
                  </span>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}