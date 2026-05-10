export interface Question {
  id: string;
  subject: 'Math' | 'Physics' | 'Chemistry' | 'English';
  content: string;
  difficulty: 'Easy' | 'Medium' | 'Hard';
  status: 'published' | 'draft' | 'reviewing';
  createdAt: string;
  tags: string[];
  hasAIExplanation: boolean;
}

export const MOCK_QUESTIONS: Question[] = [
  {
    id: 'QUE-1001',
    subject: 'Math',
    content: 'Tìm tập xác định của hàm số y = log2(x^2 - 3x + 2).',
    difficulty: 'Medium',
    status: 'published',
    createdAt: '2 giờ trước',
    tags: ['Hàm số', 'Logarit'],
    hasAIExplanation: true
  },
  {
    id: 'QUE-1002',
    subject: 'Physics',
    content: 'Một con lắc lò xo dao động điều hòa với biên độ 5cm. Tính năng lượng của con lắc...',
    difficulty: 'Easy',
    status: 'published',
    createdAt: '5 giờ trước',
    tags: ['Dao động cơ', 'Năng lượng'],
    hasAIExplanation: true
  },
  {
    id: 'QUE-1003',
    subject: 'English',
    content: 'Choose the best answer to complete the sentence: "If I _______ you, I would study harder."',
    difficulty: 'Easy',
    status: 'published',
    createdAt: '1 ngày trước',
    tags: ['Grammar', 'Conditional Sentences'],
    hasAIExplanation: true
  },
  {
    id: 'QUE-1004',
    subject: 'Chemistry',
    content: 'Xác định sản phẩm chính khi cho Propen tác dụng với HBr theo quy tắc Markownikoff.',
    difficulty: 'Hard',
    status: 'reviewing',
    createdAt: '3 ngày trước',
    tags: ['Hữu cơ', 'Anken'],
    hasAIExplanation: false
  }
];