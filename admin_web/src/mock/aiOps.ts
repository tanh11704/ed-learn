export interface OCRLog {
  id: string;
  studentName: string;
  subject: string;
  confidence: number;
  errorType: 'blurry' | 'unrecognized_math' | 'handwriting';
  uploadedAt: string;
  imageUrl: string;
  aiExtractedText: string;
  status: 'pending' | 'resolved';
}

export const MOCK_OCR_LOGS: OCRLog[] = [
  {
    id: 'ERR-9921',
    studentName: 'Trần Thị B',
    subject: 'Toán học',
    confidence: 42,
    errorType: 'unrecognized_math',
    uploadedAt: '10 phút trước',
    imageUrl: 'https://placehold.co/600x400/27272a/a1a1aa?text=T%C3%ADnh+t%C3%ADch+ph%C3%A2n...',
    aiExtractedText: 'Tính [LỖI] từ 0 đến 1 của hàm số f(x) = ...',
    status: 'pending'
  },
  {
    id: 'ERR-9922',
    studentName: 'Nguyễn Văn A',
    subject: 'Vật lý',
    confidence: 68,
    errorType: 'blurry',
    uploadedAt: '25 phút trước',
    imageUrl: 'https://placehold.co/600x400/27272a/a1a1aa?text=Image+Too+Blurry',
    aiExtractedText: 'Một con lắc lò xo dao độ... [KHÔNG ĐỌC ĐƯỢC]',
    status: 'pending'
  },
  {
    id: 'ERR-9923',
    studentName: 'Lê Hoàng C',
    subject: 'Hóa học',
    confidence: 55,
    errorType: 'handwriting',
    uploadedAt: '1 giờ trước',
    imageUrl: 'https://placehold.co/600x400/27272a/a1a1aa?text=Handwriting+Notes',
    aiExtractedText: 'Cho 2.4g Mg tác dụng với dung dịch HC... [KÝ TỰ LẠ]',
    status: 'pending'
  }
];