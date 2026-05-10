export interface Lesson {
  id: string;
  title: string;
  subject: string;
  duration: string;
  thumbnail: string;
  videoUrl: string;
  views: number;
  uploadDate: string;
  status: 'active' | 'draft';
  chapterId?: string;
  chapterTitle?: string;
  orderIndex?: number;
  isPreview?: boolean;
}
