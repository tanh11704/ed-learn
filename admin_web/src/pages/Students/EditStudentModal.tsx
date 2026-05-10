import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, Edit2, Zap, Crown } from 'lucide-react';

export interface StudentToEdit {
  id: string;
  name: string;
  email: string;
  grade: string;
  goal: string;
  plan: 'Free' | 'PREMIUM' | 'VIP';
}

interface EditStudentModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (student: StudentToEdit) => void;
  student: StudentToEdit | null;
}

const GRADES = ['Lớp 10', 'Lớp 11', 'Lớp 12'];
const PLANS = [
  { id: 'Free', label: 'Cơ bản (Free)', icon: null, activeClass: 'bg-muted text-foreground/90 border-muted-foreground' },
  { id: 'PREMIUM', label: 'Premium', icon: Zap, activeClass: 'bg-blue-500/10 text-blue-500 border-blue-500 shadow-[0_0_15px_rgba(59,130,246,0.2)]' },
  { id: 'VIP', label: 'VIP', icon: Crown, activeClass: 'bg-yellow-500/10 text-yellow-500 border-yellow-500 shadow-[0_0_15px_rgba(234,179,8,0.2)]' },
];

export default function EditStudentModal({ isOpen, onClose, onSave, student }: EditStudentModalProps) {
  const [formData, setFormData] = useState<StudentToEdit>({
    id: '', name: '', email: '', grade: 'Lớp 12', goal: '', plan: 'Free'
  });

  useEffect(() => {
    if (student) {
      setFormData(student);
    }
  }, [student, isOpen]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.name.trim() || !formData.email.trim()) return;
    
    onSave(formData);
    onClose();
  };

  return (
    <AnimatePresence>
      {isOpen && student && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-6">
          <motion.div 
            initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            onClick={onClose}
            className="absolute inset-0 bg-black/60 backdrop-blur-md"
          />
          
          <motion.div
            initial={{ opacity: 0, scale: 0.9, y: 20 }} 
            animate={{ opacity: 1, scale: 1, y: 0 }} 
            exit={{ opacity: 0, scale: 0.9, y: 20 }}
            transition={{ type: "spring", damping: 25, stiffness: 300 }}
            className="relative w-full max-w-xl bg-sidebar border border-border rounded-2xl shadow-[0_0_50px_rgba(0,0,0,0.5)] overflow-hidden flex flex-col z-10"
          >
            <div className="flex justify-between items-start p-6 border-b border-border/80 bg-muted/50">
              <div className="flex items-center gap-4">
                <div className="p-2.5 bg-primary-subtle rounded-xl text-primary">
                  <Edit2 size={22} />
                </div>
                <div>
                  <h2 className="text-xl font-bold text-foreground leading-tight">Chỉnh sửa học sinh</h2>
                  <p className="text-sm text-muted-foreground mt-1">Cập nhật thông tin tài khoản học sinh</p>
                </div>
              </div>
              <button onClick={onClose} className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-xl transition-colors">
                <X size={20} />
              </button>
            </div>
            
            <form onSubmit={handleSubmit} className="p-6 flex flex-col gap-6">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <label className="text-sm font-semibold text-foreground">Họ và tên</label>
                  <input 
                    required 
                    value={formData.name} 
                    onChange={(e) => setFormData({...formData, name: e.target.value})}
                    placeholder="Nguyễn Văn A"
                    className="w-full bg-muted border-2 border-border/80 rounded-xl p-3 text-sm text-foreground focus:border-primary/50 outline-none transition-all"
                  />
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-semibold text-foreground">Email</label>
                  <input 
                    required 
                    type="email" 
                    value={formData.email} 
                    onChange={(e) => setFormData({...formData, email: e.target.value})}
                    placeholder="vana@gmail.com"
                    className="w-full bg-muted border-2 border-border/80 rounded-xl p-3 text-sm text-foreground focus:border-primary/50 outline-none transition-all"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <label className="text-sm font-semibold text-foreground">Khối lớp</label>
                  <select 
                    value={formData.grade} 
                    onChange={(e) => setFormData({...formData, grade: e.target.value})}
                    className="w-full bg-muted border-2 border-border/80 rounded-xl p-3 text-sm text-foreground focus:border-primary/50 outline-none transition-all appearance-none"
                  >
                    {GRADES.map(g => <option key={g} value={g}>{g}</option>)}
                  </select>
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-semibold text-foreground">Mục tiêu</label>
                  <input 
                    required 
                    value={formData.goal} 
                    onChange={(e) => setFormData({...formData, goal: e.target.value})}
                    placeholder="ĐH Bách Khoa"
                    className="w-full bg-muted border-2 border-border/80 rounded-xl p-3 text-sm text-foreground focus:border-primary/50 outline-none transition-all"
                  />
                </div>
              </div>

              <div className="space-y-2">
                <label className="text-sm font-semibold text-foreground">Gói cước</label>
                <div className="grid grid-cols-3 gap-3">
                  {PLANS.map(plan => {
                    const IconComponent = plan.icon;
                    const isSelected = formData.plan === plan.id;
                    return (
                      <button
                        key={plan.id}
                        type="button"
                        onClick={() => setFormData({...formData, plan: plan.id as any})}
                        className={`p-3 rounded-xl border-2 transition-all flex items-center justify-center gap-1.5 ${
                          isSelected 
                            ? plan.activeClass 
                            : 'bg-muted border-border/80 text-muted-foreground hover:border-border'
                        }`}
                      >
                        {IconComponent && <IconComponent size={14} className="fill-current" />}
                        <span className="text-xs font-medium">{plan.label}</span>
                      </button>
                    );
                  })}
                </div>
              </div>

              <div className="flex gap-3 pt-4">
                <button
                  type="submit"
                  className="flex-1 px-4 py-2.5 bg-primary hover:bg-primary/90 text-primary-foreground font-semibold rounded-xl transition-all shadow-brand"
                >
                  Cập nhật
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
