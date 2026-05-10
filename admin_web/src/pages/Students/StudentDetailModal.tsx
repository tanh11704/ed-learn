import { motion, AnimatePresence } from 'framer-motion';
import { X, Mail, BookOpen, Target, Zap, BarChart3, Clock, Award } from 'lucide-react';

export interface StudentDetail {
  id: string;
  name: string;
  email: string;
  grade: string;
  goal: string;
  plan: 'Free' | 'PREMIUM' | 'VIP';
  aiQuestions: string;
  status: string;
  lastActive: string;
  initial: string;
  color: string;
  enrolledDate?: string;
  totalLessonsCompleted?: number;
  averageScore?: number;
  learningStreak?: number;
}

interface StudentDetailModalProps {
  isOpen: boolean;
  onClose: () => void;
  student: StudentDetail | null;
}

const STATS_DATA = [
  { label: 'Bài giảng hoàn thành', value: '24', icon: BookOpen, color: 'text-blue-400' },
  { label: 'Điểm trung bình', value: '8.5/10', icon: Award, color: 'text-yellow-400' },
  { label: 'Chuỗi học tập', value: '15 ngày', icon: Clock, color: 'text-emerald-400' },
  { label: 'Xếp hạng', value: '#245', icon: BarChart3, color: 'text-purple-400' },
];

const LEARNING_PROGRESS = [
  { subject: 'Toán học', progress: 75, color: 'bg-primary' },
  { subject: 'Vật lý', progress: 62, color: 'bg-blue-500' },
  { subject: 'Tiếng Anh', progress: 88, color: 'bg-emerald-500' },
  { subject: 'Hóa học', progress: 55, color: 'bg-amber-500' },
];

export default function StudentDetailModal({ isOpen, onClose, student }: StudentDetailModalProps) {
  if (!student) return null;

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
            className="relative w-full max-w-2xl bg-sidebar border border-border rounded-2xl shadow-[0_0_50px_rgba(0,0,0,0.5)] overflow-hidden z-10 max-h-[90vh] overflow-y-auto"
          >
            {/* Header */}
            <div className="sticky top-0 flex justify-between items-start p-6 border-b border-border/80 bg-muted/80 backdrop-blur-md z-10">
              <div className="flex items-center gap-4">
                <div className={`w-12 h-12 rounded-full bg-muted border border-border flex items-center justify-center font-bold text-lg ${student.color}`}>
                  {student.initial}
                </div>
                <div>
                  <h2 className="text-xl font-bold text-foreground">{student.name}</h2>
                  <p className="text-sm text-muted-foreground">{student.id}</p>
                </div>
              </div>
              <button onClick={onClose} className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-xl transition-colors">
                <X size={20} />
              </button>
            </div>

            {/* Content */}
            <div className="p-6 space-y-6">
              {/* Thông tin cơ bản */}
              <div>
                <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-4">Thông tin cơ bản</h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div className="bg-muted rounded-xl p-4 border border-border/80">
                    <div className="flex items-center gap-2 text-muted-foreground text-sm mb-1">
                      <Mail size={14} /> Email
                    </div>
                    <p className="text-foreground font-medium">{student.email}</p>
                  </div>
                  <div className="bg-muted rounded-xl p-4 border border-border/80">
                    <div className="flex items-center gap-2 text-muted-foreground text-sm mb-1">
                      <BookOpen size={14} /> Khối lớp
                    </div>
                    <p className="text-foreground font-medium">{student.grade}</p>
                  </div>
                  <div className="bg-muted rounded-xl p-4 border border-border/80">
                    <div className="flex items-center gap-2 text-muted-foreground text-sm mb-1">
                      <Target size={14} /> Mục tiêu
                    </div>
                    <p className="text-foreground font-medium text-sm">{student.goal}</p>
                  </div>
                  <div className="bg-muted rounded-xl p-4 border border-border/80">
                    <div className="flex items-center gap-2 text-muted-foreground text-sm mb-1">
                      <Zap size={14} /> Gói cước
                    </div>
                    <p className="text-foreground font-medium">{student.plan}</p>
                  </div>
                </div>
              </div>

              {/* Thống kê học tập */}
              <div>
                <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-4">Thống kê học tập</h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  {STATS_DATA.map((stat) => {
                    const IconComponent = stat.icon;
                    return (
                      <div key={stat.label} className="bg-muted rounded-xl p-4 border border-border/80">
                        <div className="flex items-center gap-3 mb-2">
                          <IconComponent size={18} className={stat.color} />
                          <span className="text-muted-foreground text-sm">{stat.label}</span>
                        </div>
                        <p className="text-2xl font-bold text-foreground">{stat.value}</p>
                      </div>
                    );
                  })}
                </div>
              </div>

              {/* Lộ trình học tập */}
              <div>
                <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-4">Tiến độ môn học</h3>
                <div className="space-y-4">
                  {LEARNING_PROGRESS.map((item) => (
                    <div key={item.subject}>
                      <div className="flex justify-between items-center mb-2">
                        <span className="text-foreground font-medium text-sm">{item.subject}</span>
                        <span className="text-muted-foreground text-sm">{item.progress}%</span>
                      </div>
                      <div className="w-full h-2.5 bg-muted rounded-full border border-border/80 overflow-hidden">
                        <motion.div
                          initial={{ width: 0 }}
                          animate={{ width: `${item.progress}%` }}
                          transition={{ duration: 0.8, ease: 'easeOut' }}
                          className={`h-full ${item.color} rounded-full`}
                        />
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Hoạt động gần đây */}
              <div>
                <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-4">Hoạt động gần đây</h3>
                <div className="space-y-3">
                  <div className="flex items-center justify-between bg-muted rounded-xl p-4 border border-border/80">
                    <div>
                      <p className="text-foreground font-medium text-sm">Hoàn thành bài kiểm tra Toán</p>
                      <p className="text-muted-foreground text-xs mt-1">2 giờ trước</p>
                    </div>
                    <span className="text-emerald-400 font-semibold">+25 điểm</span>
                  </div>
                  <div className="flex items-center justify-between bg-muted rounded-xl p-4 border border-border/80">
                    <div>
                      <p className="text-foreground font-medium text-sm">Xem bài giảng Vật lý</p>
                      <p className="text-muted-foreground text-xs mt-1">5 giờ trước</p>
                    </div>
                  </div>
                  <div className="flex items-center justify-between bg-muted rounded-xl p-4 border border-border/80">
                    <div>
                      <p className="text-foreground font-medium text-sm">Nâng cấp lên gói Premium</p>
                      <p className="text-muted-foreground text-xs mt-1">1 ngày trước</p>
                    </div>
                    <span className="text-blue-400 font-semibold text-sm">PREMIUM</span>
                  </div>
                </div>
              </div>

              {/* Footer Actions */}
              <div className="flex gap-3 pt-4 border-t border-border/80">
                <button className="flex-1 px-4 py-2.5 bg-primary hover:bg-primary/90 text-primary-foreground font-medium rounded-xl transition-colors">
                  Chỉnh sửa
                </button>
                <button 
                  onClick={onClose}
                  className="flex-1 px-4 py-2.5 bg-muted hover:bg-muted text-foreground/90 font-medium rounded-xl transition-colors border border-border"
                >
                  Đóng
                </button>
              </div>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}
