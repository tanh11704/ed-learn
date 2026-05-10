import { motion, AnimatePresence } from 'framer-motion';
import { X, Mail, Shield, Calendar } from 'lucide-react';
import type { AdminUserDto } from '../../api/models/adminUser.dto';

interface Props {
  isOpen: boolean;
  onClose: () => void;
  user: AdminUserDto | null;
}

function formatTs(iso?: string): string {
  if (!iso) return '—';
  try {
    return new Date(iso).toLocaleString('vi-VN');
  } catch {
    return iso;
  }
}

export default function RegisteredUserDetailModal({ isOpen, onClose, user }: Props) {
  if (!user) return null;

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
            initial={{ opacity: 0, scale: 0.95, y: 12 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.95, y: 12 }}
            className="relative w-full max-w-lg bg-sidebar border border-border rounded-2xl shadow-xl z-10 overflow-hidden"
          >
            <div className="flex justify-between items-start p-5 border-b border-border bg-muted/40">
              <div>
                <h2 className="text-lg font-bold text-foreground">{user.fullName}</h2>
                <p className="text-xs text-muted-foreground font-mono mt-0.5">{user.id}</p>
              </div>
              <button
                type="button"
                onClick={onClose}
                className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-lg transition-colors"
              >
                <X size={20} />
              </button>
            </div>
            <div className="p-5 space-y-4">
              <div className="flex items-start gap-3 rounded-xl border border-border bg-muted/30 p-3">
                <Mail size={18} className="text-primary shrink-0 mt-0.5" />
                <div>
                  <p className="text-xs text-muted-foreground">Email</p>
                  <p className="text-sm font-medium text-foreground break-all">{user.email}</p>
                </div>
              </div>
              <div className="flex items-start gap-3 rounded-xl border border-border bg-muted/30 p-3">
                <Shield size={18} className="text-primary shrink-0 mt-0.5" />
                <div>
                  <p className="text-xs text-muted-foreground">Vai trò (DB)</p>
                  <p className="text-sm font-medium text-foreground">{user.role}</p>
                </div>
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div className="flex items-start gap-3 rounded-xl border border-border bg-muted/30 p-3">
                  <Calendar size={18} className="text-muted-foreground shrink-0 mt-0.5" />
                  <div>
                    <p className="text-xs text-muted-foreground">Tạo</p>
                    <p className="text-xs font-medium text-foreground">{formatTs(user.createdAt)}</p>
                  </div>
                </div>
                <div className="flex items-start gap-3 rounded-xl border border-border bg-muted/30 p-3">
                  <Calendar size={18} className="text-muted-foreground shrink-0 mt-0.5" />
                  <div>
                    <p className="text-xs text-muted-foreground">Cập nhật</p>
                    <p className="text-xs font-medium text-foreground">{formatTs(user.updatedAt)}</p>
                  </div>
                </div>
              </div>
            </div>
            <div className="p-4 border-t border-border bg-muted/20">
              <button
                type="button"
                onClick={onClose}
                className="w-full py-2.5 rounded-xl bg-muted hover:bg-muted text-foreground text-sm font-medium border border-border transition-colors"
              >
                Đóng
              </button>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}
