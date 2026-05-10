import type { LucideIcon } from 'lucide-react';
import {
  Activity,
  Bell,
  BotIcon,
  Cpu,
  CreditCard,
  FileText,
  HelpCircle,
  Layers,
  LayoutDashboard,
  MonitorPlay,
  Receipt,
  ShieldCheck,
  Trophy,
  Users,
  Video,
} from 'lucide-react';

/** Nhãn phụ trên item (không dùng trạng thái giả như "Lỗi"). */
export type SidebarNavBadge = {
  text: string;
  tone?: 'neutral' | 'info';
};

export type SidebarNavItem = {
  label: string;
  /** Path đầy đủ; phải khớp route trong `App.tsx`. */
  path: string;
  icon: LucideIcon;
  badge?: SidebarNavBadge;
};

export type SidebarNavGroup = {
  title: string;
  items: SidebarNavItem[];
};

/**
 * Menu sidebar — nguồn duy nhất cho label + path + icon.
 * Khi thêm/sửa route trong App, cập nhật mảng này cho khớp.
 */
export const ADMIN_SIDEBAR_GROUPS: SidebarNavGroup[] = [
  {
    title: 'TỔNG QUAN',
    items: [
      { label: 'Dashboard', path: '/', icon: LayoutDashboard },
      { label: 'Báo cáo real-time', path: '/reports', icon: Activity },
    ],
  },
  {
    title: 'NGƯỜI DÙNG',
    items: [
      { label: 'Học sinh', path: '/students', icon: Users },
      { label: 'Phân quyền', path: '/roles', icon: ShieldCheck },
    ],
  },
  {
    title: 'HỌC TẬP',
    items: [
      { label: 'Bài giảng', path: '/learning', icon: Video },
      { label: 'Đề thi', path: '/exams', icon: FileText },
      { label: 'Câu hỏi', path: '/content', icon: HelpCircle },
      { label: 'Flashcards', path: '/flashcards', icon: Layers },
    ],
  },
  {
    title: 'VẬN HÀNH AI',
    items: [
      { label: 'Trợ lý AI', path: '/ai-ops', icon: BotIcon },
      {
        label: 'Nhật ký AI',
        path: '/ai-logs',
        icon: Cpu,
        badge: { text: 'Beta', tone: 'neutral' },
      },
    ],
  },
  {
    title: 'CỘNG ĐỒNG',
    items: [
      { label: 'Phòng học ảo', path: '/virtual-rooms', icon: MonitorPlay },
      { label: 'Bảng xếp hạng', path: '/leaderboard', icon: Trophy },
      { label: 'Thông báo', path: '/notifications', icon: Bell },
    ],
  },
  {
    title: 'TÀI CHÍNH',
    items: [
      { label: 'Gói cước', path: '/pricing-plans', icon: CreditCard },
      { label: 'Giao dịch', path: '/transactions', icon: Receipt },
    ],
  },
];

/** Footer sidebar — cùng path với route Settings. */
export const ADMIN_SETTINGS_PATH = '/settings' as const;

/** Danh sách path từ menu (hữu ích khi đối chiếu / test). */
export const ADMIN_SIDEBAR_PATHS: string[] = ADMIN_SIDEBAR_GROUPS.flatMap((g) =>
  g.items.map((i) => i.path)
);
