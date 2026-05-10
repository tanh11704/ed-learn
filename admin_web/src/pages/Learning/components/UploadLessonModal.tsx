import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, Video, Save, Edit } from 'lucide-react';
import { Lesson } from '../types';

export type LessonFormPayload = {
  title: string;
  chapterId: string;
  orderIndex: number;
  isPreview: boolean;
  mediaFile: File | null;
};

interface UploadModalProps {
  isOpen: boolean;
  onClose: () => void;
  /** Gọi API ở parent; modal chỉ hiển thị lỗi submit */
  onSave: (data: LessonFormPayload) => Promise<void>;
  initialData?: Lesson | null;
  courseSubject: string;
  chapters: { id: string; title: string }[];
  defaultChapterId?: string;
}

export default function UploadLessonModal({
  isOpen,
  onClose,
  onSave,
  initialData,
  courseSubject,
  chapters,
  defaultChapterId,
}: UploadModalProps) {
  const [title, setTitle] = useState('');
  const [chapterId, setChapterId] = useState('');
  const [orderIndex, setOrderIndex] = useState(0);
  const [isPreview, setIsPreview] = useState(false);
  const [mediaFile, setMediaFile] = useState<File | null>(null);
  const [submitError, setSubmitError] = useState('');
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (!isOpen) return;
    setSubmitError('');
    if (initialData) {
      setTitle(initialData.title);
      setChapterId(initialData.chapterId ?? '');
      setOrderIndex(initialData.orderIndex ?? 0);
      setIsPreview(initialData.isPreview ?? false);
    } else {
      setTitle('');
      setChapterId(defaultChapterId ?? chapters[0]?.id ?? '');
      setOrderIndex(0);
      setIsPreview(false);
    }
    setMediaFile(null);
  }, [initialData, isOpen, chapters, defaultChapterId]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim()) return;
    if (!initialData && !chapterId) {
      setSubmitError('Chọn chương chứa bài giảng.');
      return;
    }
    setSubmitting(true);
    setSubmitError('');
    try {
      await onSave({
        title: title.trim(),
        chapterId: initialData ? (initialData.chapterId ?? chapterId) : chapterId,
        orderIndex: Number.isFinite(orderIndex) ? orderIndex : 0,
        isPreview,
        mediaFile,
      });
      onClose();
    } catch (err: unknown) {
      setSubmitError(err instanceof Error ? err.message : 'Lưu thất bại.');
    } finally {
      setSubmitting(false);
    }
  };

  const editing = !!initialData;

  return (
    <AnimatePresence>
      {isOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center px-4">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={onClose}
            className="absolute inset-0 bg-black/60 backdrop-blur-sm"
          />
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.95 }}
            className="relative w-full max-w-lg bg-sidebar border border-border rounded-2xl shadow-2xl overflow-hidden"
          >
            <div className="p-6 border-b border-border flex justify-between items-center bg-muted">
              <h3 className="text-foreground font-bold flex items-center gap-2">
                {editing ? (
                  <Edit className="text-amber-500" size={20} />
                ) : (
                  <Video className="text-primary" size={20} />
                )}
                {editing ? 'Chỉnh sửa bài giảng' : 'Thêm bài giảng'}
              </h3>
              <button type="button" onClick={onClose} className="text-muted-foreground hover:text-foreground">
                <X size={20} />
              </button>
            </div>

            <form id="lesson-form" onSubmit={handleSubmit} className="p-6 space-y-4">
              <p className="text-xs text-muted-foreground">
                Môn: <span className="text-foreground font-medium">{courseSubject}</span>
              </p>

              <div className="space-y-1.5">
                <label className="text-xs font-medium text-muted-foreground uppercase tracking-wider">
                  Tiêu đề
                </label>
                <input
                  required
                  type="text"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  className="w-full bg-muted border border-border rounded-lg px-4 py-2.5 text-foreground text-sm focus:border-primary outline-none"
                />
              </div>

              {!editing && (
                <div className="space-y-1.5">
                  <label className="text-xs font-medium text-muted-foreground uppercase tracking-wider">
                    Chương
                  </label>
                  <select
                    required
                    value={chapterId}
                    onChange={(e) => setChapterId(e.target.value)}
                    className="w-full bg-muted border border-border rounded-lg px-3 py-2.5 text-foreground text-sm outline-none focus:border-primary"
                  >
                    {chapters.length === 0 ? (
                      <option value="">— Tạo chương trước —</option>
                    ) : (
                      chapters.map((c) => (
                        <option key={c.id} value={c.id}>
                          {c.title}
                        </option>
                      ))
                    )}
                  </select>
                </div>
              )}

              {editing && initialData?.chapterTitle && (
                <p className="text-xs text-muted-foreground">
                  Chương: <span className="text-foreground">{initialData.chapterTitle}</span>
                </p>
              )}

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-medium text-muted-foreground uppercase tracking-wider">
                    Thứ tự
                  </label>
                  <input
                    type="number"
                    value={orderIndex}
                    onChange={(e) => setOrderIndex(parseInt(e.target.value, 10) || 0)}
                    className="w-full bg-muted border border-border rounded-lg px-4 py-2.5 text-foreground text-sm outline-none focus:border-primary"
                  />
                </div>
                <label className="flex items-center gap-2 pt-7 text-sm text-foreground cursor-pointer">
                  <input
                    type="checkbox"
                    checked={isPreview}
                    onChange={(e) => setIsPreview(e.target.checked)}
                    className="rounded border-border"
                  />
                  Học thử
                </label>
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-medium text-muted-foreground uppercase tracking-wider">
                  Tệp video / PDF (tùy chọn — tải lên server)
                </label>
                <input
                  type="file"
                  accept="video/*,.pdf,application/pdf"
                  onChange={(e) => setMediaFile(e.target.files?.[0] ?? null)}
                  className="w-full text-sm text-muted-foreground file:mr-3 file:rounded-lg file:border-0 file:bg-primary file:px-3 file:py-1.5 file:text-primary-foreground"
                />
              </div>

              {submitError && (
                <p className="text-sm text-danger bg-danger/10 border border-danger/20 rounded-lg px-3 py-2">
                  {submitError}
                </p>
              )}
            </form>

            <div className="p-6 bg-muted/50 border-t border-border flex justify-end gap-3">
              <button
                type="button"
                onClick={onClose}
                className="px-4 py-2 text-sm text-muted-foreground hover:text-foreground"
              >
                Hủy
              </button>
              <button
                type="submit"
                form="lesson-form"
                disabled={submitting}
                className="px-5 py-2 bg-primary hover:bg-primary/90 text-primary-foreground rounded-lg text-sm font-medium flex items-center gap-2 shadow-lg shadow-brand transition-all disabled:opacity-60"
              >
                <Save size={16} /> {submitting ? 'Đang lưu…' : 'Lưu'}
              </button>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}
