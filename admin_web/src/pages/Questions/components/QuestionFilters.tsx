import React from 'react';
import { Search, Filter } from 'lucide-react';

export default function QuestionFilters() {
  return (
    <div className="bg-card border border-border rounded-[24px] p-4 flex flex-col md:flex-row items-center justify-between gap-4">
      {/* Thanh tìm kiếm giống Flashcard */}
      <div className="relative flex-1 w-full">
        <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" size={20} />
        <input 
          type="text" 
          placeholder="Tìm kiếm nội dung câu hỏi..." 
          className="w-full h-12 bg-muted border border-border rounded-xl pl-12 pr-4 text-foreground focus:border-primary outline-none transition-all"
        />
      </div>

      {/* Bộ lọc chủ đề & Mức độ */}
      <div className="flex items-center gap-3 w-full md:w-auto">
        <div className="flex bg-muted p-1 rounded-xl border border-border">
          <button className="px-4 py-2 bg-card text-foreground rounded-lg text-sm font-medium shadow-sm">Mới nhất</button>
          <button className="px-4 py-2 text-muted-foreground hover:text-foreground/90 rounded-lg text-sm font-medium transition-all">Phổ biến</button>
        </div>
        
        <select className="bg-muted border border-border text-foreground/90 text-sm rounded-xl px-4 py-2.5 outline-none focus:border-primary cursor-pointer">
          <option>Tất cả chủ đề</option>
          <option>Toán học</option>
          <option>Vật lý</option>
          <option>Tiếng Anh</option>
        </select>
      </div>
    </div>
  );
}