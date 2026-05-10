export interface AIAsset {
  id: string;
  type: 'flashcards' | 'quiz' | 'image' | 'lesson_plan';
  prompt: string;
  // Dữ liệu thực tế tùy thuộc vào type (VD: url ảnh, hoặc mảng các thẻ)
  data: string | any; 
  createdAt: string;
  status: 'saved' | 'preview';
}