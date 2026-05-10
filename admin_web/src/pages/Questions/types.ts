export interface Topic {
  id: string;
  title: string;
  category: string;
  count: number;
  updatedAt: string;
  author: string;
}

export interface Question {
  id: string;
  topicId: string;
  content: string;
  type: 'Trắc nghiệm' | 'Tự luận';
  level: 'Nhận biết' | 'Thông hiểu' | 'Vận dụng' | 'Vận dụng cao';
  subject: string;
  options?: string[]; // Mảng 4 phần tử cho A, B, C, D
  correctAnswer?: number; // 0, 1, 2, 3 tương ứng A, B, C, D
  status: 'Hoạt động' | 'Bản nháp';
}