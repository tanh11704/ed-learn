export interface FlashcardItem {
  id: string;
  front: string; // Mặt trước (Câu hỏi/Thuật ngữ)
  back: string;  // Mặt sau (Đáp án/Định nghĩa)
}

export interface FlashcardDeck {
  id: string;
  title: string;
  subject: string;
  cardCount: number;
  createdAt: string;
  author: string;
  cards: FlashcardItem[]; // Thêm mảng chứa các thẻ bài
}