import { motion, AnimatePresence } from 'framer-motion';
import { Eye, Edit2, Trash2 } from 'lucide-react';
import { useRef, useEffect, useState } from 'react';

interface StudentActionsMenuProps {
  isOpen: boolean;
  onClose: () => void;
  onView: () => void;
  onEdit: () => void;
  onDelete: () => void;
  position?: { x: number; y: number };
}

export default function StudentActionsMenu({ 
  isOpen, 
  onClose, 
  onView, 
  onEdit, 
  onDelete, 
  position 
}: StudentActionsMenuProps) {
  const menuRef = useRef<HTMLDivElement>(null);
  const [menuPosition, setMenuPosition] = useState(position);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        onClose();
      }
    };

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside);
      return () => document.removeEventListener('mousedown', handleClickOutside);
    }
  }, [isOpen, onClose]);

  const handleAction = (action: () => void) => {
    action();
    onClose();
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          ref={menuRef}
          initial={{ opacity: 0, scale: 0.9, y: -10 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.9, y: -10 }}
          transition={{ type: "spring", damping: 20, stiffness: 300 }}
          style={menuPosition ? { 
            position: 'fixed', 
            left: menuPosition.x, 
            top: menuPosition.y 
          } : undefined}
          className="w-48 bg-muted border border-border rounded-xl shadow-[0_0_30px_rgba(0,0,0,0.5)] z-50 overflow-hidden"
        >
          <button
            onClick={() => handleAction(onView)}
            className="w-full flex items-center gap-3 px-4 py-3 text-foreground/90 hover:bg-sidebar hover:text-foreground transition-colors border-b border-border/80"
          >
            <Eye size={16} />
            <span className="text-sm font-medium">Xem chi tiết</span>
          </button>

          <button
            onClick={() => handleAction(onEdit)}
            className="w-full flex items-center gap-3 px-4 py-3 text-foreground/90 hover:bg-sidebar hover:text-foreground transition-colors border-b border-border/80"
          >
            <Edit2 size={16} />
            <span className="text-sm font-medium">Chỉnh sửa</span>
          </button>

          <button
            onClick={() => handleAction(onDelete)}
            className="w-full flex items-center gap-3 px-4 py-3 text-red-400 hover:bg-red-500/10 hover:text-red-300 transition-colors"
          >
            <Trash2 size={16} />
            <span className="text-sm font-medium">Xóa</span>
          </button>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
