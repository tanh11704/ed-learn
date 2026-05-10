export interface StatData {
  title: string;
  value: string | number;
  trend: number; // Phần trăm tăng/giảm
  isUp: boolean;
}

export interface Activity {
  id: string;
  user: string;
  avatar?: string;
  action: 'nộp bài' | 'đang làm bài' | 'tạo mới' | 'cập nhật';
  target: string;
  time: string;
  score?: number;
}