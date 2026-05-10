import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, Save } from 'lucide-react';
import { FlashcardItem } from '../types';

interface CardFormModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (data: Partial<FlashcardItem>) => void;
  initialData?: FlashcardItem | null;
}

export default function CardFormModal({ isOpen, onClose, onSave, initialData }: CardFormModalProps) {
  const [front, setFront] = useState('');
  const [back, setBack] = useState('');

  useEffect(() => {
    if (initialData) {
      setFront(initialData.front);
      setBack(initialData.back);
    } else {
      setFront('');
      setBack('');
    }
  }, [initialData, isOpen]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!front.trim() || !back.trim()) return;
    onSave({ front, back });
    onClose();
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center px-4">
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={onClose} className="absolute inset-0 bg-black/80 backdrop-blur-sm" />
          <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 0.95 }} className="relative w-full max-w-lg bg-sidebar border border-border rounded-2xl shadow-2xl overflow-hidden">
            <div className="p-5 border-b border-border flex justify-between items-center bg-muted">
              <h3 className="text-foreground font-bold">{initialData ? 'Chỉnh sửa thẻ' : 'Thêm thẻ mới'}</h3>
              <button onClick={onClose} className="text-muted-foreground hover:text-foreground"><X size={20} /></button>
            </div>
            
            <form id="card-form" onSubmit={handleSubmit} className="p-6 space-y-6">
              <div className="space-y-2">
                <label className="text-sm font-medium text-muted-foreground">Mặt trước (Thuật ngữ / Câu hỏi)</label>
                <textarea required rows={3} value={front} onChange={(e) => setFront(e.target.value)} placeholder="Nhập nội dung mặt trước..." className="w-full bg-muted border border-border rounded-lg p-3 text-foreground text-sm focus:border-primary outline-none resize-none" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium text-muted-foreground">Mặt sau (Định nghĩa / Đáp án)</label>
                <textarea required rows={3} value={back} onChange={(e) => setBack(e.target.value)} placeholder="Nhập nội dung mặt sau..." className="w-full bg-muted border border-border rounded-lg p-3 text-foreground text-sm focus:border-primary outline-none resize-none" />
              </div>
            </form>

            <div className="p-5 bg-muted/50 border-t border-border flex justify-end gap-3">
              <button type="button" onClick={onClose} className="px-4 py-2 text-sm text-muted-foreground hover:text-foreground">Hủy</button>
              <button type="submit" form="card-form" className="px-5 py-2 bg-primary hover:bg-primary/90 text-primary-foreground rounded-lg text-sm font-medium flex items-center gap-2 transition-all">
                <Save size={16} /> Lưu thẻ
              </button>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}