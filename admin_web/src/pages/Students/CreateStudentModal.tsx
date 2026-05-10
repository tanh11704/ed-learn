import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, UserPlus, Zap, Crown } from 'lucide-react';

export interface NewStudentData {
  name: string;
  email: string;
  grade: string;
  goal: string;
  plan: 'Free' | 'PREMIUM' | 'VIP';
}

interface CreateStudentModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (student: NewStudentData) => void;
}

const GRADES = ['Lớp 10', 'Lớp 11', 'Lớp 12'];
const PLANS = [
  { id: 'Free', label: 'Cơ bản (Free)', activeClass: 'bg-muted text-foreground/90 border-muted-foreground' },
  { id: 'PREMIUM', label: 'Premium', icon: Zap, activeClass: 'bg-blue-500/10 text-blue-500 border-blue-500 shadow-[0_0_15px_rgba(59,130,246,0.2)]' },
  { id: 'VIP', label: 'VIP', icon: Crown, activeClass: 'bg-yellow-500/10 text-yellow-500 border-yellow-500 shadow-[0_0_15px_rgba(234,179,8,0.2)]' },
];

export default function CreateStudentModal({ isOpen, onClose, onSave }: CreateStudentModalProps) {
  const [formData, setFormData] = useState<NewStudentData>({
    name: '', email: '', grade: 'Lớp 12', goal: '', plan: 'Free'
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.name.trim() || !formData.email.trim()) return;
    
    onSave(formData);
    setFormData({ name: '', email: '', grade: 'Lớp 12', goal: '', plan: 'Free' }); // Reset
  };

  return (
    <AnimatePresence>
      {isOpen && (
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
                  <UserPlus size={22} />
                </div>
                <div>
                  <h2 className="text-xl font-bold text-foreground leading-tight">Thêm học sinh mới</h2>
                  <p className="text-sm text-muted-foreground mt-1">Cấp quyền truy cập hệ thống AI</p>
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
                    required value={formData.name} onChange={(e) => setFormData({...formData, name: e.target.value})}
                    placeholder="Nguyễn Văn A"
                    className="w-full bg-muted border-2 border-border/80 rounded-xl p-3 text-sm text-foreground focus:border-primary/50 outline-none transition-all"
                  />
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-semibold text-foreground">Email</label>
                  <input 
                    required type="email" value={formData.email} onChange={(e) => setFormData({...formData, email: e.target.value})}
                    placeholder="vana@gmail.com"
                    className="w-full bg-muted border-2 border-border/80 rounded-xl p-3 text-sm text-foreground focus:border-primary/50 outline-none transition-all"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <label className="text-sm font-semibold text-foreground">Khối lớp</label>
                  <select 
                    value={formData.grade} onChange={(e) => setFormData({...formData, grade: e.target.value})}
                    className="w-full bg-muted border-2 border-border/80 rounded-xl p-3 text-sm text-foreground focus:border-primary/50 outline-none transition-all appearance-none"
                  >
                    {GRADES.map(g => <option key={g} value={g}>{g}</option>)}
                  </select>
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-semibold text-foreground">Mục tiêu (Trường ĐH)</label>
                  <input 
                    value={formData.goal} onChange={(e) => setFormData({...formData, goal: e.target.value})}
                    placeholder="VD: ĐH Bách Khoa"
                    className="w-full bg-muted border-2 border-border/80 rounded-xl p-3 text-sm text-foreground focus:border-primary/50 outline-none transition-all"
                  />
                </div>
              </div>

              <div className="space-y-3">
                <label className="text-sm font-semibold text-foreground">Gói cước</label>
                <div className="grid grid-cols-3 gap-3">
                  {PLANS.map((plan) => {
                    const Icon = plan.icon;
                    const isActive = formData.plan === plan.id;
                    return (
                      <button
                        key={plan.id} type="button"
                        onClick={() => setFormData({...formData, plan: plan.id as any})}
                        className={`flex items-center justify-center gap-2 py-3 rounded-xl border-2 text-sm font-medium transition-all duration-200 ${
                          isActive ? plan.activeClass : 'border-border/80 bg-muted text-muted-foreground hover:bg-muted'
                        }`}
                      >
                        {Icon && <Icon size={16} />}
                        {plan.label}
                      </button>
                    );
                  })}
                </div>
              </div>

              <div className="flex justify-end gap-3 pt-4 border-t border-border/80">
                <button type="button" onClick={onClose} className="px-6 py-2.5 text-sm font-medium text-foreground/90 hover:text-foreground hover:bg-muted rounded-xl transition-colors">
                  Hủy
                </button>
                <button type="submit" className="px-6 py-2.5 bg-primary hover:bg-primary/90 text-primary-foreground text-sm font-medium rounded-xl transition-colors shadow-brand">
                  Thêm học sinh
                </button>
              </div>
            </form>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}