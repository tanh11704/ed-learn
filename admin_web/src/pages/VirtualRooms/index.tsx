import { Video, Users, Clock } from 'lucide-react';
import { MOCK_VIRTUAL_ROOMS } from '../../mock/placeholders';

const statusLabel: Record<string, { label: string; className: string }> = {
  live: { label: 'Đang live', className: 'bg-emerald-500/15 text-emerald-400 border-emerald-500/30' },
  scheduled: { label: 'Sắp diễn ra', className: 'bg-amber-500/15 text-amber-400 border-amber-500/30' },
  ended: { label: 'Đã kết thúc', className: 'bg-muted/70 text-muted-foreground border-border' },
};

export default function VirtualRooms() {
  return (
    <div className="space-y-6 max-w-7xl mx-auto pb-10">
      <div>
        <h1 className="text-2xl font-bold text-foreground tracking-tight flex items-center gap-2">
          <Video className="text-primary" size={28} />
          Phòng học ảo
        </h1>
        <p className="text-muted-foreground text-sm mt-1">
          Theo dõi phòng livestream, lịch và sức chứa. Dữ liệu mẫu.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {MOCK_VIRTUAL_ROOMS.map((room) => {
          const st = statusLabel[room.status];
          return (
            <div
              key={room.id}
              className="rounded-2xl border border-border bg-muted/50 p-5 hover:border-border transition-colors"
            >
              <div className="flex items-start justify-between gap-3">
                <div>
                  <p className="text-xs font-medium text-primary uppercase tracking-wide">{room.subject}</p>
                  <h2 className="text-lg font-semibold text-foreground mt-1">{room.name}</h2>
                  <p className="text-sm text-muted-foreground mt-1">Host: {room.host}</p>
                </div>
                <span className={`shrink-0 text-xs font-medium px-2.5 py-1 rounded-lg border ${st.className}`}>
                  {st.label}
                </span>
              </div>

              <div className="mt-4 flex flex-wrap gap-4 text-sm text-muted-foreground">
                <span className="inline-flex items-center gap-1.5">
                  <Users size={16} className="text-muted-foreground" />
                  {room.participants}/{room.capacity} học sinh
                </span>
                <span className="inline-flex items-center gap-1.5">
                  <Clock size={16} className="text-muted-foreground" />
                  {room.startsAt}
                </span>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
