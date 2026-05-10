import { motion, AnimatePresence } from 'framer-motion';
import { X, AlertTriangle, Trash2 } from 'lucide-react';

interface DeleteConfirmDialogProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  studentName: string;
  isLoading?: boolean;
}

export default function DeleteConfirmDialog({ isOpen, onClose, onConfirm, studentName, isLoading }: DeleteConfirmDialogProps) {
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
            className="relative w-full max-w-md bg-sidebar border border-border rounded-2xl shadow-[0_0_50px_rgba(0,0,0,0.5)] overflow-hidden z-10"
          >
            {/* Header */}
            <div className="flex justify-between items-start p-6 border-b border-border/80 bg-muted/50">
              <div className="flex items-center gap-4">
                <div className="p-2.5 bg-red-500/10 rounded-xl text-red-500">
                  <AlertTriangle size={22} />
                </div>
                <h2 className="text-lg font-bold text-foreground">Xác nhận xóa</h2>
              </div>
              <button onClick={onClose} className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-xl transition-colors">
                <X size={20} />
              </button>
            </div>

            {/* Content */}
            <div className="p-6 space-y-4">
              <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-4">
                <p className="text-red-400 text-sm font-medium">
                  Bạn có chắc chắn muốn xóa học sinh <span className="font-bold">{studentName}</span>?
                </p>
                <p className="text-red-300/70 text-xs mt-2">
                  Hành động này không thể hoàn tác. Tất cả dữ liệu học tập của học sinh này sẽ bị xóa vĩnh viễn.
                </p>
              </div>

              {/* Actions */}
              <div className="flex gap-3 pt-4">
                <button
                  onClick={onConfirm}
                  disabled={isLoading}
                  className="flex-1 flex items-center justify-center gap-2 px-4 py-2.5 bg-red-600 hover:bg-red-500 disabled:bg-red-600/50 disabled:cursor-not-allowed text-foreground font-semibold rounded-xl transition-all"
                >
                  <Trash2 size={18} />
                  {isLoading ? 'Đang xóa...' : 'Xóa'}
                </button>
                <button
                  onClick={onClose}
                  disabled={isLoading}
                  className="flex-1 px-4 py-2.5 bg-muted hover:bg-muted disabled:bg-muted/50 disabled:cursor-not-allowed text-foreground/90 font-semibold rounded-xl transition-all border border-border"
                >
                  Hủy
                </button>
              </div>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}
