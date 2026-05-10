import React, { useState, useEffect } from 'react';
import { X } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { Question, Topic } from '../types';

interface QuestionModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (data: Partial<Question>) => void;
  question?: Question | null;
  topic?: Topic | null;
}

export default function QuestionModal({ isOpen, onClose, onSave, question, topic }: QuestionModalProps) {
  const [formData, setFormData] = useState<Partial<Question>>({
    content: '',
    type: 'Trắc nghiệm',
    level: 'Nhận biết',
    subject: '',
    options: ['', '', '', ''],
    correctAnswer: 0,
  });

  useEffect(() => {
    if (question) {
      setFormData(question);
    } else {
      setFormData({
        content: '',
        type: 'Trắc nghiệm',
        level: 'Nhận biết',
        subject: '',
        options: ['', '', '', ''],
        correctAnswer: 0,
      });
    }
  }, [question, isOpen]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.content?.trim()) return;
    
    onSave(formData);
  };

  const updateOption = (index: number, value: string) => {
    const newOptions = [...(formData.options || ['', '', '', ''])];
    newOptions[index] = value;
    setFormData({ ...formData, options: newOptions });
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-6">
          <motion.div 
            initial={{ opacity: 0 }} 
            animate={{ opacity: 1 }} 
            exit={{ opacity: 0 }}
            onClick={onClose}
            className="absolute inset-0 bg-black/60 backdrop-blur-md"
          />
          
          <motion.div
            initial={{ opacity: 0, scale: 0.9, y: 20 }} 
            animate={{ opacity: 1, scale: 1, y: 0 }} 
            exit={{ opacity: 0, scale: 0.9, y: 20 }}
            transition={{ type: "spring", damping: 25, stiffness: 300 }}
            className="relative w-full max-w-2xl bg-sidebar border border-border rounded-2xl shadow-[0_0_50px_rgba(0,0,0,0.5)] overflow-hidden flex flex-col z-10 max-h-[90vh] overflow-y-auto"
          >
            {/* Header */}
            <div className="sticky top-0 flex justify-between items-start p-6 border-b border-border/80 bg-muted/80 backdrop-blur-md z-10">
              <div>
                <h2 className="text-xl font-bold text-foreground">{question ? 'Chỉnh sửa câu hỏi' : 'Thêm câu hỏi mới'}</h2>
                {topic && <p className="text-sm text-muted-foreground mt-1">Chủ đề: {topic.title}</p>}
              </div>
              <button onClick={onClose} className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-xl transition-colors">
                <X size={20} />
              </button>
            </div>

            {/* Form */}
            <form onSubmit={handleSubmit} className="p-6 space-y-6">
              {/* Nội dung câu hỏi */}
              <div className="space-y-2">
                <label className="block text-sm font-semibold text-foreground">Nội dung câu hỏi *</label>
                <textarea 
                  required
                  rows={4}
                  value={formData.content || ''}
                  onChange={(e) => setFormData({ ...formData, content: e.target.value })}
                  placeholder="Nhập câu hỏi tại đây..."
                  className="w-full bg-muted border border-border rounded-xl p-4 text-foreground focus:border-primary outline-none transition-all resize-none"
                />
              </div>

              {/* 2 cột: Loại & Mức độ */}
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <label className="block text-sm font-semibold text-foreground">Loại câu hỏi *</label>
                  <select 
                    value={formData.type || ''}
                    onChange={(e) => setFormData({ ...formData, type: e.target.value as any })}
                    className="w-full bg-muted border border-border rounded-xl p-3 text-foreground outline-none transition-all"
                  >
                    <option value="Trắc nghiệm">Trắc nghiệm</option>
                    <option value="Tự luận">Tự luận</option>
                  </select>
                </div>
                <div className="space-y-2">
                  <label className="block text-sm font-semibold text-foreground">Mức độ *</label>
                  <select 
                    value={formData.level || ''}
                    onChange={(e) => setFormData({ ...formData, level: e.target.value as any })}
                    className="w-full bg-muted border border-border rounded-xl p-3 text-foreground outline-none transition-all"
                  >
                    <option value="Nhận biết">Nhận biết</option>
                    <option value="Thông hiểu">Thông hiểu</option>
                    <option value="Vận dụng">Vận dụng</option>
                    <option value="Vận dụng cao">Vận dụng cao</option>
                  </select>
                </div>
              </div>

              {/* Môn học */}
              <div className="space-y-2">
                <label className="block text-sm font-semibold text-foreground">Môn học *</label>
                <input 
                  required
                  type="text"
                  value={formData.subject || ''}
                  onChange={(e) => setFormData({ ...formData, subject: e.target.value })}
                  placeholder="VD: Toán học, Vật lý, Tiếng Anh..."
                  className="w-full bg-muted border border-border rounded-xl p-3 text-foreground outline-none transition-all"
                />
              </div>

              {/* Các tùy chọn (chỉ hiển thị khi là trắc nghiệm) */}
              {formData.type === 'Trắc nghiệm' && (
                <div className="space-y-3">
                  <label className="block text-sm font-semibold text-foreground">Các phương án trả lời</label>
                  {formData.options?.map((opt, idx) => (
                    <div key={idx} className="flex gap-3">
                      <label className="flex items-center gap-2">
                        <input 
                          type="radio" 
                          name="correctAnswer"
                          checked={formData.correctAnswer === idx}
                          onChange={() => setFormData({ ...formData, correctAnswer: idx })}
                          className="w-4 h-4 accent-emerald-500"
                        />
                        <span className="text-sm font-bold text-foreground w-6">{String.fromCharCode(65 + idx)}.</span>
                      </label>
                      <input 
                        type="text"
                        value={opt}
                        onChange={(e) => updateOption(idx, e.target.value)}
                        placeholder={`Phương án ${String.fromCharCode(65 + idx)}`}
                        className="flex-1 bg-muted border border-border rounded-xl p-3 text-foreground text-sm outline-none transition-all"
                      />
                    </div>
                  ))}
                  <p className="text-xs text-muted-foreground">Chọn đáp án đúng bằng radio button</p>
                </div>
              )}

              {/* Actions */}
              <div className="flex gap-3 pt-4 border-t border-border">
                <button
                  type="submit"
                  className="flex-1 px-4 py-2.5 bg-primary hover:bg-primary/90 text-primary-foreground font-semibold rounded-xl transition-all"
                >
                  {question ? 'Cập nhật' : 'Thêm câu hỏi'}
                </button>
                <button
                  type="button"
                  onClick={onClose}
                  className="flex-1 px-4 py-2.5 bg-muted hover:bg-muted text-foreground/90 font-semibold rounded-xl transition-all border border-border"
                >
                  Hủy
                </button>
              </div>
            </form>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}