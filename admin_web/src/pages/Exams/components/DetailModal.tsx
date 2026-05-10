import { motion, AnimatePresence } from 'framer-motion';
import { X, FileText, FileType2, CheckCircle2, Clock, LayoutList, List } from 'lucide-react';
import { Exam } from '../types';

interface DetailModalProps {
  exam: Exam | null;
  onClose: () => void;
}

export default function DetailModal({ exam, onClose }: DetailModalProps) {
  return (
    <AnimatePresence>
      {exam && (
        <div className="fixed inset-0 z-50 flex items-center justify-center px-4 py-6">
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={onClose} className="absolute inset-0 bg-black/60 backdrop-blur-sm" />
          <motion.div initial={{ opacity: 0, scale: 0.95, y: 20 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.95, y: 20 }} className="relative w-full max-w-3xl max-h-full flex flex-col bg-sidebar border border-border rounded-2xl shadow-2xl overflow-hidden">
            <div className="flex flex-shrink-0 items-center justify-between p-6 border-b border-border bg-muted">
              <div className="flex items-center gap-3">
                <div className={`p-2.5 rounded-xl ${exam.type === 'pdf' ? 'bg-red-500/10 text-red-500' : 'bg-blue-500/10 text-blue-500'}`}>
                  {exam.type === 'pdf' ? <FileText size={24} /> : <FileType2 size={24} />}
                </div>
                <div>
                  <h3 className="text-lg font-bold text-foreground line-clamp-1 pr-4">{exam.title}</h3>
                  <div className="flex items-center gap-3 mt-1 text-xs">
                    <span className="text-muted-foreground">{exam.subject}</span>
                    <span className="w-1 h-1 bg-muted-foreground rounded-full"></span>
                    <span className="text-muted-foreground">{exam.uploadDate}</span>
                  </div>
                </div>
              </div>
              <button onClick={onClose} className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-lg transition-colors"><X size={20} /></button>
            </div>

            <div className="flex-1 overflow-y-auto p-6 space-y-6 custom-scrollbar">
              <div className="grid grid-cols-2 gap-4">
                <div className="bg-muted border border-border rounded-xl p-4 flex flex-col justify-center">
                  <span className="text-muted-foreground text-xs font-medium uppercase mb-1">Trạng thái AI</span>
                  {exam.status === 'completed' ? (
                    <span className="flex items-center gap-1.5 text-emerald-500 font-medium"><CheckCircle2 size={18} /> Đã bóc tách</span>
                  ) : (
                    <span className="flex items-center gap-1.5 text-amber-500 font-medium"><Clock size={18} className="animate-spin-slow" /> Đang xử lý...</span>
                  )}
                </div>
                <div className="bg-muted border border-border rounded-xl p-4 flex flex-col justify-center">
                  <span className="text-muted-foreground text-xs font-medium uppercase mb-1">Số câu hỏi nhận diện</span>
                  <span className="flex items-center gap-2 text-foreground font-bold text-xl"><LayoutList size={20} className="text-primary" /> {exam.questions > 0 ? exam.questions : 0} câu</span>
                </div>
              </div>

              <div className="space-y-4">
                <h4 className="font-semibold text-foreground flex items-center gap-2"><List size={18} /> Nội dung bóc tách (Preview)</h4>
                {exam.status === 'completed' ? (
                  <div className="space-y-3">
                    {[1, 2, 3].map((q) => (
                      <div key={q} className="bg-muted p-4 rounded-xl border border-border">
                        <p className="text-sm text-foreground font-medium mb-3"><span className="text-primary font-bold mr-1">Câu {q}:</span> Nội dung câu hỏi mô phỏng...</p>
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                          <div className="text-xs text-foreground/90 p-2.5 bg-sidebar rounded-lg border border-border">A. Đáp án A</div>
                          <div className="text-xs text-foreground/90 p-2.5 bg-sidebar rounded-lg border border-border">B. Đáp án B</div>
                          <div className="text-xs text-foreground/90 p-2.5 bg-sidebar rounded-lg border border-border text-emerald-400 border-emerald-500/30">C. Đáp án C (Đúng)</div>
                          <div className="text-xs text-foreground/90 p-2.5 bg-sidebar rounded-lg border border-border">D. Đáp án D</div>
                        </div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="flex flex-col items-center justify-center py-12 bg-muted rounded-xl border border-border border-dashed">
                    <Clock size={40} className="text-amber-500 animate-spin-slow mb-4" />
                    <p className="text-foreground font-medium mb-1">AI đang phân tích tài liệu</p>
                    <p className="text-muted-foreground text-sm max-w-sm text-center">Quá trình này có thể mất vài phút.</p>
                  </div>
                )}
              </div>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}