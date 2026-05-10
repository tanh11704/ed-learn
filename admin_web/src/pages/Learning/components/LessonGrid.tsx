import { Play, Clock, Eye, Edit2, Trash2 } from 'lucide-react';
import { Lesson } from '../types';

interface LessonGridProps {
  lessons: Lesson[];
  onView: (lesson: Lesson) => void;
  onEdit: (lesson: Lesson) => void;
  onDelete: (id: string) => void;
}

export default function LessonGrid({ lessons, onView, onEdit, onDelete }: LessonGridProps) {
  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
      {lessons.map((lesson) => (
        <div key={lesson.id} className="bg-sidebar border border-border rounded-xl overflow-hidden group hover:border-border transition-all flex flex-col">
          {/* Thumbnail area */}
          <div className="relative aspect-video bg-card overflow-hidden">
            <img 
              src={lesson.thumbnail} 
              alt={lesson.title}
              className="w-full h-full object-cover opacity-80 group-hover:opacity-100 transition-opacity group-hover:scale-105 duration-500"
            />
            {/* Nút Play to bự khi hover */}
            <div 
              onClick={() => onView(lesson)}
              className="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity bg-black/40 cursor-pointer"
            >
              <div className="w-14 h-14 bg-primary/90 rounded-full flex items-center justify-center text-primary-foreground shadow-brand transform group-hover:scale-110 transition-transform">
                <Play size={28} fill="currentColor" className="ml-1" />
              </div>
            </div>
            
            <div className="absolute bottom-2 right-2 bg-black/80 text-foreground text-[11px] font-bold px-2 py-1 rounded">
              {lesson.duration}
            </div>
            <div className="absolute top-2 left-2">
              <span className="bg-primary text-primary-foreground text-[10px] px-2.5 py-1 rounded-full uppercase font-bold tracking-wider shadow-md">
                {lesson.subject}
              </span>
            </div>
          </div>

          {/* Content area */}
          <div className="p-4 flex-1 flex flex-col">
            <h3 
              onClick={() => onView(lesson)}
              className="text-foreground font-semibold text-sm line-clamp-2 mb-3 cursor-pointer hover:text-primary transition-colors"
            >
              {lesson.title}
            </h3>
            
            <div className="mt-auto flex items-center justify-between text-xs text-muted-foreground border-t border-border/80 pt-3">
              <div className="flex items-center gap-3">
                <span className="flex items-center gap-1.5"><Eye size={14} /> {lesson.views}</span>
                <span className="flex items-center gap-1.5"><Clock size={14} /> {lesson.uploadDate}</span>
              </div>
              
              <div className="flex items-center gap-1 opacity-100 sm:opacity-0 group-hover:opacity-100 transition-opacity">
                <button onClick={() => onEdit(lesson)} className="p-1.5 hover:bg-muted rounded-md text-muted-foreground hover:text-foreground transition-colors" title="Sửa bài giảng">
                  <Edit2 size={15} />
                </button>
                <button onClick={() => onDelete(lesson.id)} className="p-1.5 hover:bg-red-500/10 rounded-md text-muted-foreground hover:text-red-500 transition-colors" title="Xóa bài giảng">
                  <Trash2 size={15} />
                </button>
              </div>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}