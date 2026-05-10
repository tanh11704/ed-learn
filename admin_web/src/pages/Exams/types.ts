export interface Exam {
  id: number;
  title: string;
  subject: string;
  uploadDate: string;
  status: 'completed' | 'processing';
  questions: number;
  type: 'pdf' | 'docx';
}