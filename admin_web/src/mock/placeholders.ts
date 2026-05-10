/** Mock data cho các module Cộng đồng / Tài chính / Phân quyền (chưa nối API). */

export interface RoleRow {
  id: string;
  name: string;
  description: string;
  userCount: number;
  permissions: string[];
}

export interface VirtualRoomRow {
  id: string;
  name: string;
  subject: string;
  host: string;
  participants: number;
  capacity: number;
  status: 'live' | 'scheduled' | 'ended';
  startsAt: string;
}

export interface LeaderboardRow {
  rank: number;
  studentName: string;
  school: string;
  score: number;
  streak: number;
  plan: 'Free' | 'PREMIUM' | 'VIP';
}

export interface NotificationRow {
  id: string;
  title: string;
  body: string;
  type: 'system' | 'billing' | 'community' | 'exam';
  createdAt: string;
  read: boolean;
}

export interface PricingPlanRow {
  id: string;
  name: string;
  priceMonthly: number;
  priceYearly: number;
  highlight?: boolean;
  features: string[];
  cta: string;
}

export interface TransactionRow {
  id: string;
  userEmail: string;
  userName: string;
  planName: string;
  amount: number;
  currency: string;
  status: 'completed' | 'pending' | 'failed' | 'refunded';
  paidAt: string;
}

export const MOCK_ROLES: RoleRow[] = [
  {
    id: 'r1',
    name: 'Super Admin',
    description: 'Toàn quyền cấu hình hệ thống, người dùng và tài chính.',
    userCount: 2,
    permissions: ['users.*', 'content.*', 'finance.*', 'ai.*', 'settings.*'],
  },
  {
    id: 'r2',
    name: 'Content Manager',
    description: 'Quản lý bài giảng, đề thi, câu hỏi và flashcards.',
    userCount: 5,
    permissions: ['content.read', 'content.write', 'exams.*', 'learning.*'],
  },
  {
    id: 'r3',
    name: 'Support',
    description: 'Xem học sinh, gửi thông báo, không chỉnh sửa nội dung.',
    userCount: 8,
    permissions: ['users.read', 'notifications.send'],
  },
  {
    id: 'r4',
    name: 'Finance',
    description: 'Gói cước, giao dịch, hoàn tiền (hạn chế).',
    userCount: 3,
    permissions: ['finance.read', 'finance.transactions', 'plans.read'],
  },
];

export const MOCK_VIRTUAL_ROOMS: VirtualRoomRow[] = [
  {
    id: 'vr1',
    name: 'Ôn Toán 12 — Buổi 14',
    subject: 'Toán',
    host: 'GV. Minh Anh',
    participants: 42,
    capacity: 50,
    status: 'live',
    startsAt: 'Đang diễn ra',
  },
  {
    id: 'vr2',
    name: 'Luyện đề Tiếng Anh THPT',
    subject: 'Tiếng Anh',
    host: 'GV. Hoàng Nam',
    participants: 0,
    capacity: 80,
    status: 'scheduled',
    startsAt: 'Hôm nay, 20:00',
  },
  {
    id: 'vr3',
    name: 'Hóa 11 — Phản ứng oxi hóa khử',
    subject: 'Hóa học',
    host: 'GV. Thu Hà',
    participants: 28,
    capacity: 40,
    status: 'ended',
    startsAt: 'Hôm qua, 19:00',
  },
  {
    id: 'vr4',
    name: 'Vật lý — Dao động cơ',
    subject: 'Vật lý',
    host: 'GV. Đức Thịnh',
    participants: 15,
    capacity: 45,
    status: 'scheduled',
    startsAt: 'Mai, 18:30',
  },
];

export const MOCK_LEADERBOARD: LeaderboardRow[] = [
  { rank: 1, studentName: 'Nguyễn Minh Khôi', school: 'THPT Chuyên HN', score: 9850, streak: 42, plan: 'VIP' },
  { rank: 2, studentName: 'Trần Bảo Ngọc', school: 'THPT Lê Hồng Phong', score: 9720, streak: 38, plan: 'PREMIUM' },
  { rank: 3, studentName: 'Lê Gia Huy', school: 'THPT Nguyễn Du', score: 9580, streak: 21, plan: 'PREMIUM' },
  { rank: 4, studentName: 'Phạm Quỳnh An', school: 'THPT Amsterdam', score: 9310, streak: 15, plan: 'Free' },
  { rank: 5, studentName: 'Vũ Đức Anh', school: 'THPT Chuyên Lê Hồng Phong', score: 9190, streak: 29, plan: 'VIP' },
  { rank: 6, studentName: 'Đặng Thu Hà', school: 'THPT Marie Curie', score: 9050, streak: 7, plan: 'Free' },
  { rank: 7, studentName: 'Hoàng Việt Dũng', school: 'THPT Trần Phú', score: 8920, streak: 12, plan: 'PREMIUM' },
];

export const MOCK_NOTIFICATIONS: NotificationRow[] = [
  {
    id: 'n1',
    title: 'Bảo trì hệ thống AI',
    body: 'Khung giờ 02:00–04:00 ngày 12/05. Một số tính năng trợ lý có thể chậm.',
    type: 'system',
    createdAt: '10 phút trước',
    read: false,
  },
  {
    id: 'n2',
    title: 'Thanh toán thành công — Gói Premium',
    body: 'Học sinh tr***@gmail.com đã gia hạn 12 tháng.',
    type: 'billing',
    createdAt: '1 giờ trước',
    read: false,
  },
  {
    id: 'n3',
    title: 'Phòng ảo mới: Ôn Lý THPT',
    body: 'GV. Lan Phương đã lên lịch buổi livestream tối nay.',
    type: 'community',
    createdAt: '3 giờ trước',
    read: true,
  },
  {
    id: 'n4',
    title: 'Upload đề thi hoàn tất',
    body: 'Đề thi thử môn Sinh đã được AI phân tích xong.',
    type: 'exam',
    createdAt: 'Hôm qua',
    read: true,
  },
];

export const MOCK_PRICING_PLANS: PricingPlanRow[] = [
  {
    id: 'p1',
    name: 'Free',
    priceMonthly: 0,
    priceYearly: 0,
    features: ['Lộ trình cơ bản', 'Giới hạn câu hỏi AI/ngày', 'Flashcards công khai'],
    cta: 'Đang áp dụng mặc định',
  },
  {
    id: 'p2',
    name: 'Premium',
    priceMonthly: 99000,
    priceYearly: 990000,
    highlight: true,
    features: ['Không giới hạn AI cơ bản', 'Đề thi & chấm chi tiết', 'Ưu tiên hàng đợi AI'],
    cta: 'Phổ biến nhất',
  },
  {
    id: 'p3',
    name: 'VIP',
    priceMonthly: 199000,
    priceYearly: 1990000,
    features: ['Mentor AI nâng cao', 'Báo cáo học tập sâu', 'Hỗ trợ ưu tiên 24/7'],
    cta: 'Dành cho lớp & trung tâm',
  },
];

export const MOCK_TRANSACTIONS: TransactionRow[] = [
  {
    id: 'TX-2026-00421',
    userEmail: 'vana.nguyen@gmail.com',
    userName: 'Nguyễn Văn A',
    planName: 'Premium (12 tháng)',
    amount: 990000,
    currency: 'VND',
    status: 'completed',
    paidAt: '10/05/2026 14:32',
  },
  {
    id: 'TX-2026-00420',
    userEmail: 'tranb.2006@gmail.com',
    userName: 'Trần Thị B',
    planName: 'VIP (1 tháng)',
    amount: 199000,
    currency: 'VND',
    status: 'completed',
    paidAt: '09/05/2026 09:15',
  },
  {
    id: 'TX-2026-00419',
    userEmail: 'parent.pham@gmail.com',
    userName: 'Phạm (PH)',
    planName: 'Premium (1 tháng)',
    amount: 99000,
    currency: 'VND',
    status: 'pending',
    paidAt: '—',
  },
  {
    id: 'TX-2026-00418',
    userEmail: 'duce.vu@gmail.com',
    userName: 'Vũ Đức E',
    planName: 'Hoàn tiền — gói trùng',
    amount: -99000,
    currency: 'VND',
    status: 'refunded',
    paidAt: '08/05/2026 16:00',
  },
  {
    id: 'TX-2026-00417',
    userEmail: 'fail@example.com',
    userName: 'Người dùng ẩn danh',
    planName: 'Premium (1 tháng)',
    amount: 99000,
    currency: 'VND',
    status: 'failed',
    paidAt: '07/05/2026 11:20',
  },
];
