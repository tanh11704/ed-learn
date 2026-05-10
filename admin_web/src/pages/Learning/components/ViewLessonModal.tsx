import { motion, AnimatePresence } from 'framer-motion';
import { X, PlayCircle, Clock, Eye } from 'lucide-react';
import { Lesson } from '../types';

interface ViewLessonModalProps {
  isOpen: boolean;
  onClose: () => void;
  lesson: Lesson | null;
}

export default function ViewLessonModal({ isOpen, onClose, lesson }: ViewLessonModalProps) {
  if (!lesson) return null;

  // Lấy ID video Youtube từ URL (Giả lập)
  // Thực tế bạn có thể cần 1 hàm extract ID chuẩn hơn
  const videoId = lesson.videoUrl.includes('v=') 
    ? lesson.videoUrl.split('v=')[1]?.substring(0, 11) 
    : 'dQw4w9WgXcQ'; // ID mặc định nếu không có

  return (
    <AnimatePresence>
      {isOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center px-4">
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={onClose} className="absolute inset-0 bg-black/80 backdrop-blur-sm" />
          
          <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 0.95 }} className="relative w-full max-w-4xl bg-sidebar border border-border rounded-2xl shadow-2xl overflow-hidden">
            {/* Header */}
            <div className="p-4 border-b border-border flex justify-between items-start bg-muted">
              <div>
                <h3 className="text-foreground font-bold text-lg flex items-center gap-2">
                  <PlayCircle className="text-primary" size={24}/> 
                  {lesson.title}
                </h3>
                <div className="flex items-center gap-4 mt-2 text-sm text-muted-foreground">
                  <span className="bg-primary-subtle text-primary px-2 py-0.5 rounded text-xs font-medium border border-primary/20">
                    {lesson.subject}
                  </span>
                  <span className="flex items-center gap-1"><Clock size={14} /> {lesson.duration}</span>
                  <span className="flex items-center gap-1"><Eye size={14} /> {lesson.views} lượt xem</span>
                </div>
              </div>
              <button onClick={onClose} className="p-2 bg-muted/50 hover:bg-muted rounded-full text-muted-foreground hover:text-foreground transition-colors">
                <X size={20} />
              </button>
            </div>
            
            {/* Video Player (Iframe) */}
            <div className="relative w-full pt-[56.25%] bg-black">
              {/* Aspect ratio 16:9 */}
              <iframe
                className="absolute top-0 left-0 w-full h-full"
                src={`https://www.youtube.com/embed/${videoId}?autoplay=1`}
                title={lesson.title}
                frameBorder="0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowFullScreen
              ></iframe>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}