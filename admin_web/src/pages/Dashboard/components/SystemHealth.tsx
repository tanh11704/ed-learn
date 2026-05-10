import { Server, Cpu, Database, Activity } from 'lucide-react';
import { SystemMetrics } from '../types';

interface SystemHealthProps {
  metrics: SystemMetrics;
}

export default function SystemHealth({ metrics }: SystemHealthProps) {
  const ProgressBar = ({ label, value, icon: Icon, color }: { label: string, value: number, icon: any, color: string }) => (
    <div className="space-y-2">
      <div className="flex justify-between items-center text-sm">
        <div className="flex items-center gap-2 text-muted-foreground">
          <Icon size={16} /> {label}
        </div>
        <span className="text-foreground font-medium">{value}%</span>
      </div>
      <div className="h-2 w-full bg-muted rounded-full overflow-hidden border border-border">
        <div 
          className={`h-full rounded-full ${color}`} 
          style={{ width: `${value}%`, transition: 'width 1s ease-in-out' }}
        />
      </div>
    </div>
  );

  return (
    <div className="bg-sidebar p-6 rounded-xl border border-border">
      <div className="flex items-center justify-between mb-6">
        <h3 className="text-lg font-bold text-foreground flex items-center gap-2">
          <Server size={20} className="text-primary" /> Trạng thái Hệ thống AI
        </h3>
        <span className="flex items-center gap-1.5 text-emerald-500 bg-emerald-500/10 px-2.5 py-1 rounded-full text-xs font-medium">
          <Activity size={14} /> Đang hoạt động
        </span>
      </div>

      <div className="space-y-6">
        <ProgressBar label="Tải CPU" value={metrics.cpu} icon={Cpu} color="bg-primary" />
        <ProgressBar label="Sử dụng RAM" value={metrics.ram} icon={Database} color="bg-blue-500" />
        <ProgressBar label="Dung lượng lưu trữ" value={metrics.storage} icon={Server} color="bg-emerald-500" />
        
        <div className="pt-4 border-t border-border">
          <div className="flex justify-between items-center">
            <span className="text-sm text-muted-foreground">Hàng đợi bóc tách AI</span>
            <span className="text-sm font-medium text-amber-500">{metrics.aiQueue} tài liệu</span>
          </div>
        </div>
      </div>
    </div>
  );
}