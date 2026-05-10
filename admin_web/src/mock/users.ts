export interface User {
  id: string;
  name: string;
  email: string;
  grade: string;
  targetUni: string;
  status: 'active' | 'inactive' | 'banned';
  subscription: 'free' | 'premium' | 'vip';
  solvedQuestions: number;
  lastActive: string;
}

export const MOCK_USERS: User[] = [
  { id: 'USR-001', name: 'Nguyễn Văn A', email: 'vana.nguyen@gmail.com', grade: 'Lớp 12', targetUni: 'ĐH Bách Khoa', status: 'active', subscription: 'premium', solvedQuestions: 1245, lastActive: 'Vừa xong' },
  { id: 'USR-002', name: 'Trần Thị B', email: 'tranb.2006@gmail.com', grade: 'Lớp 12', targetUni: 'ĐH Ngoại Thương', status: 'active', subscription: 'vip', solvedQuestions: 3420, lastActive: '5 phút trước' },
  { id: 'USR-003', name: 'Lê Hoàng C', email: 'hoangc.le@yahoo.com', grade: 'Lớp 11', targetUni: 'ĐH Kinh Tế Quốc Dân', status: 'active', subscription: 'free', solvedQuestions: 120, lastActive: '2 giờ trước' },
  { id: 'USR-004', name: 'Phạm Quỳnh D', email: 'quynhd.pham@gmail.com', grade: 'Lớp 12', targetUni: 'ĐH Y Hà Nội', status: 'inactive', subscription: 'free', solvedQuestions: 85, lastActive: '3 ngày trước' },
  { id: 'USR-005', name: 'Vũ Đức E', email: 'duce.vu@gmail.com', grade: 'Lớp 10', targetUni: 'ĐH Quốc Gia', status: 'active', subscription: 'premium', solvedQuestions: 890, lastActive: '10 phút trước' },
  { id: 'USR-006', name: 'Hoàng Minh F', email: 'minhf.hoang@gmail.com', grade: 'Lớp 12', targetUni: 'Học viện An Ninh', status: 'banned', subscription: 'free', solvedQuestions: 12, lastActive: '1 tuần trước' },
];