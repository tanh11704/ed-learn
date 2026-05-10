import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, Save } from 'lucide-react';
import { FlashcardDeck } from '../types';

// Đổi tên Interface thành DeckFormModalProps và dùng FlashcardDeck
interface DeckFormModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (data: Partial<FlashcardDeck>) => void;
  initialData?: FlashcardDeck | null; // <--- Sửa lỗi ở đây
}

export default function DeckFormModal({ isOpen, onClose, onSave, initialData }: DeckFormModalProps) {
  const [title, setTitle] = useState('');
  const [subject, setSubject] = useState('Khác');

  useEffect(() => {
    if (initialData) {
      setTitle(initialData.title);
      setSubject(initialData.subject);
    } else {
      setTitle('');
      setSubject('Khác');
    }
  }, [initialData, isOpen]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim()) return;
    onSave({ title, subject });
    onClose();
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center px-4">
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={onClose} className="absolute inset-0 bg-black/80 backdrop-blur-sm" />
          <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 0.95 }} className="relative w-full max-w-md bg-sidebar border border-border rounded-2xl shadow-2xl overflow-hidden">
            <div className="p-5 border-b border-border flex justify-between items-center bg-muted">
              <h3 className="text-foreground font-bold">{initialData ? 'Chỉnh sửa chủ đề' : 'Tạo chủ đề mới'}</h3>
              <button onClick={onClose} className="text-muted-foreground hover:text-foreground"><X size={20} /></button>
            </div>
            
            <form id="deck-form" onSubmit={handleSubmit} className="p-6 space-y-6">
              <div className="space-y-2">
                <label className="text-sm font-medium text-muted-foreground">Tên bộ thẻ</label>
                <input required type="text" value={title} onChange={(e) => setTitle(e.target.value)} placeholder="VD: 1000 Từ vựng TOEIC..." className="w-full bg-muted border border-border rounded-lg p-3 text-foreground text-sm focus:border-primary outline-none" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium text-muted-foreground">Môn học</label>
                <select value={subject} onChange={(e) => setSubject(e.target.value)} className="w-full bg-muted border border-border rounded-lg p-3 text-foreground text-sm focus:border-primary outline-none">
                  <option value="Toán học">Toán học</option>
                  <option value="Vật lý">Vật lý</option>
                  <option value="Hóa học">Hóa học</option>
                  <option value="Tiếng Anh">Tiếng Anh</option>
                  <option value="Ngữ Văn">Ngữ Văn</option>
                  <option value="Khác">Khác</option>
                </select>
              </div>
            </form>

            <div className="p-5 bg-muted/50 border-t border-border flex justify-end gap-3">
              <button type="button" onClick={onClose} className="px-4 py-2 text-sm text-muted-foreground hover:text-foreground">Hủy</button>
              <button type="submit" form="deck-form" className="px-5 py-2 bg-primary hover:bg-primary/90 text-primary-foreground rounded-lg text-sm font-medium flex items-center gap-2 transition-all">
                <Save size={16} /> Lưu bộ thẻ
              </button>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}