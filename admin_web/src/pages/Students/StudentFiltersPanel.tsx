import { motion, AnimatePresence } from 'framer-motion';
import { X, Filter } from 'lucide-react';

interface StudentFiltersPanelProps {
  isOpen: boolean;
  onClose: () => void;
  onStatusChange: (status: string) => void;
  onPlanChange: (plan: string) => void;
  onGradeChange: (grade: string) => void;
  currentStatus: string;
  currentPlan: string;
  currentGrade: string;
}

const STATUSES = ['all', 'Hoạt động', 'Ngoại tuyến'];
const PLANS = ['all', 'Free', 'PREMIUM', 'VIP'];
const GRADES = ['all', 'Lớp 10', 'Lớp 11', 'Lớp 12'];

export default function StudentFiltersPanel({
  isOpen,
  onClose,
  onStatusChange,
  onPlanChange,
  onGradeChange,
  currentStatus,
  currentPlan,
  currentGrade,
}: StudentFiltersPanelProps) {
  const handleReset = () => {
    onStatusChange('all');
    onPlanChange('all');
    onGradeChange('all');
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <>
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={onClose}
            className="fixed inset-0 z-40 bg-black/40"
          />
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -20 }}
            className="fixed left-0 top-0 h-screen w-80 bg-sidebar border-r border-border z-40 p-6 overflow-y-auto"
          >
            <div className="flex justify-between items-center mb-6">
              <div className="flex items-center gap-2">
                <Filter size={20} className="text-primary" />
                <h3 className="text-lg font-bold text-foreground">Bộ lọc</h3>
              </div>
              <button
                onClick={onClose}
                className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-lg transition-colors"
              >
                <X size={20} />
              </button>
            </div>

            <div className="space-y-6">
              {/* Status Filter */}
              <div>
                <label className="text-sm font-semibold text-foreground block mb-3">Trạng thái</label>
                <div className="space-y-2">
                  {STATUSES.map((status) => (
                    <label key={status} className="flex items-center gap-3 cursor-pointer group">
                      <input
                        type="radio"
                        name="status"
                        value={status}
                        checked={currentStatus === status}
                        onChange={(e) => onStatusChange(e.target.value)}
                        className="w-4 h-4 accent-primary cursor-pointer"
                      />
                      <span className="text-sm text-foreground/90 group-hover:text-foreground transition-colors">
                        {status === 'all' ? 'Tất cả' : status}
                      </span>
                    </label>
                  ))}
                </div>
              </div>

              {/* Plan Filter */}
              <div>
                <label className="text-sm font-semibold text-foreground block mb-3">Gói cước</label>
                <div className="space-y-2">
                  {PLANS.map((plan) => (
                    <label key={plan} className="flex items-center gap-3 cursor-pointer group">
                      <input
                        type="radio"
                        name="plan"
                        value={plan}
                        checked={currentPlan === plan}
                        onChange={(e) => onPlanChange(e.target.value)}
                        className="w-4 h-4 accent-primary cursor-pointer"
                      />
                      <span className="text-sm text-foreground/90 group-hover:text-foreground transition-colors">
                        {plan === 'all' ? 'Tất cả' : plan}
                      </span>
                    </label>
                  ))}
                </div>
              </div>

              {/* Grade Filter */}
              <div>
                <label className="text-sm font-semibold text-foreground block mb-3">Khối lớp</label>
                <div className="space-y-2">
                  {GRADES.map((grade) => (
                    <label key={grade} className="flex items-center gap-3 cursor-pointer group">
                      <input
                        type="radio"
                        name="grade"
                        value={grade}
                        checked={currentGrade === grade}
                        onChange={(e) => onGradeChange(e.target.value)}
                        className="w-4 h-4 accent-primary cursor-pointer"
                      />
                      <span className="text-sm text-foreground/90 group-hover:text-foreground transition-colors">
                        {grade === 'all' ? 'Tất cả' : grade}
                      </span>
                    </label>
                  ))}
                </div>
              </div>

              {/* Reset Button */}
              <button
                onClick={handleReset}
                className="w-full px-4 py-2.5 bg-muted hover:bg-muted text-foreground/90 font-medium rounded-lg border border-border transition-colors"
              >
                Đặt lại bộ lọc
              </button>
            </div>
          </motion.div>
        </>
      )}
    </AnimatePresence>
  );
}
