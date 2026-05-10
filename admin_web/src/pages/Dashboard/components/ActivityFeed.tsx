import { FileText, UserPlus, CreditCard, AlertCircle } from 'lucide-react';
import { Activity } from '../types';

interface ActivityFeedProps {
  activities: Activity[];
}

export default function ActivityFeed({ activities }: ActivityFeedProps) {
  const getIcon = (type: Activity['type']) => {
    switch (type) {
      case 'exam': return <FileText size={16} className="text-blue-500" />;
      case 'user': return <UserPlus size={16} className="text-emerald-500" />;
      case 'finance': return <CreditCard size={16} className="text-amber-500" />;
      case 'system': return <AlertCircle size={16} className="text-red-500" />;
      default: return <AlertCircle size={16} className="text-muted-foreground" />;
    }
  };

  const getBgColor = (type: Activity['type']) => {
    switch (type) {
      case 'exam': return 'bg-blue-500/10 border-blue-500/20';
      case 'user': return 'bg-emerald-500/10 border-emerald-500/20';
      case 'finance': return 'bg-amber-500/10 border-amber-500/20';
      case 'system': return 'bg-red-500/10 border-red-500/20';
      default: return 'bg-muted border-border';
    }
  };

  return (
    <div className="bg-sidebar p-6 rounded-xl border border-border flex flex-col h-full">
      <h3 className="text-lg font-bold text-foreground mb-6">Hoạt động gần đây</h3>
      
      <div className="flex-1 space-y-4">
        {activities.map((activity) => (
          <div key={activity.id} className="flex items-start gap-4 group">
            <div className={`p-2.5 rounded-lg border ${getBgColor(activity.type)} mt-1 transition-colors`}>
              {getIcon(activity.type)}
            </div>
            <div className="flex-1">
              <p className="text-sm text-foreground font-medium">{activity.action}</p>
              <div className="flex items-center gap-2 mt-1 text-xs text-muted-foreground">
                <span>{activity.user}</span>
                <span className="w-1 h-1 bg-muted-foreground rounded-full"></span>
                <span>{activity.time}</span>
              </div>
            </div>
          </div>
        ))}
      </div>
      
      <button className="w-full mt-6 py-2.5 text-sm text-muted-foreground hover:text-foreground bg-muted hover:bg-muted border border-border rounded-lg transition-colors">
        Xem toàn bộ lịch sử
      </button>
    </div>
  );
}