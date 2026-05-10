import { useState } from 'react';
import { Play, Edit2, Trash2, Layers, Clock, AlertTriangle } from 'lucide-react';
import { FlashcardDeck } from '../types';

interface FlashcardGridProps {
  decks: FlashcardDeck[];
  onView: (deck: FlashcardDeck) => void;
  onStudy: (deck: FlashcardDeck) => void;
  onEdit: (deck: FlashcardDeck) => void;
  onDelete: (id: string) => void;
}

export default function FlashcardGrid({ decks, onView, onStudy, onEdit, onDelete }: FlashcardGridProps) {
  // State lưu id của bộ thẻ đang chuẩn bị xóa (nếu null nghĩa là không có hộp thoại nào hiện lên)
  const [deletingDeckId, setDeletingDeckId] = useState<string | null>(null);

  // Hàm xử lý khi người dùng bấm nút Xác nhận xóa trong Modal
  const confirmDelete = () => {
    if (deletingDeckId) {
      onDelete(deletingDeckId);
      setDeletingDeckId(null); // Đóng modal sau khi xóa
    }
  };

  return (
    <>
      <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
        {decks.map((deck) => (
          <div 
            key={deck.id} 
            onClick={() => onView(deck)} 
            className="relative bg-sidebar border border-border rounded-2xl p-5 group hover:border-border transition-all flex flex-col h-[180px] overflow-hidden cursor-pointer"
          >
            
            {/* Nội dung mặc định của thẻ */}
            <div className="flex-1 transition-opacity duration-300 group-hover:opacity-10">
              <div className="w-10 h-10 bg-primary-subtle rounded-lg flex items-center justify-center mb-4 border border-primary/20">
                <Layers className="text-primary" size={20} />
              </div>
              
              <h3 className="text-foreground font-bold text-lg mb-2 line-clamp-1">{deck.title}</h3>
              
              <div className="flex items-center gap-3 text-xs font-medium mb-4">
                <span className="bg-muted text-foreground/90 px-2 py-1 rounded uppercase tracking-wider">
                  {deck.subject}
                </span>
                <span className="text-muted-foreground flex items-center gap-1.5">
                  <Layers size={14} /> {deck.cardCount} thẻ
                </span>
              </div>
            </div>

            <div className="flex items-center justify-between text-xs text-muted-foreground transition-opacity duration-300 group-hover:opacity-10 mt-auto">
              <span className="flex items-center gap-1.5"><Clock size={14} /> {deck.createdAt}</span>
              <span className="border border-border/50 px-2 py-1 rounded bg-muted/40">
                {deck.author}
              </span>
            </div>

            {/* Hover Overlay Actions */}
            <div className="absolute inset-0 flex items-center justify-center gap-4 opacity-0 group-hover:opacity-100 transition-all duration-300 scale-95 group-hover:scale-100 z-10 bg-sidebar/60 backdrop-blur-[2px]">
              <button 
                onClick={(e) => { e.stopPropagation(); onStudy(deck); }} 
                className="w-12 h-12 bg-white rounded-full flex items-center justify-center text-black hover:scale-110 transition-transform shadow-lg group/btn"
                title="Học thử"
              >
                <Play size={22} fill="currentColor" className="ml-1" />
              </button>
              <button 
                onClick={(e) => { e.stopPropagation(); onEdit(deck); }}
                className="w-10 h-10 bg-muted border border-border rounded-full flex items-center justify-center text-foreground hover:bg-muted/80 hover:scale-110 transition-transform shadow-lg"
                title="Chỉnh sửa"
              >
                <Edit2 size={18} />
              </button>
              
              {/* Nút Xóa: Khi click sẽ mở Modal thay vì gọi onDelete ngay */}
              <button 
                onClick={(e) => { 
                  e.stopPropagation(); 
                  setDeletingDeckId(deck.id); // <--- Mở Modal
                }}
                className="w-10 h-10 bg-red-500/20 border border-red-500/50 rounded-full flex items-center justify-center text-red-500 hover:bg-red-500 hover:text-foreground hover:scale-110 transition-transform shadow-lg"
                title="Xóa bộ thẻ"
              >
                <Trash2 size={18} />
              </button>
            </div>

          </div>
        ))}
      </div>

      {/* Modal Xác Nhận Xóa */}
      {deletingDeckId && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm">
          <div className="bg-muted border border-border rounded-2xl p-6 w-full max-w-sm shadow-2xl relative">
            <div className="flex flex-col items-center text-center">
              <div className="w-14 h-14 bg-red-500/10 text-red-500 rounded-full flex items-center justify-center mb-4 border border-red-500/20">
                <AlertTriangle size={28} />
              </div>
              <h3 className="text-xl font-bold text-foreground mb-2">Xác nhận xóa</h3>
              <p className="text-muted-foreground text-sm mb-6">
                Bạn có chắc chắn muốn xóa bộ thẻ này không? Các thẻ bài bên trong cũng sẽ bị xóa vĩnh viễn và không thể khôi phục.
              </p>
            </div>
            
            <div className="flex gap-3 w-full">
              <button 
                onClick={() => setDeletingDeckId(null)} // Đóng modal khi bấm Hủy
                className="flex-1 px-4 py-2.5 bg-muted hover:bg-muted/80 text-foreground rounded-lg text-sm font-medium transition-colors"
              >
                Hủy
              </button>
              <button 
                onClick={confirmDelete} // Gọi hàm xóa khi bấm Xóa
                className="flex-1 px-4 py-2.5 bg-red-600 hover:bg-red-700 text-foreground rounded-lg text-sm font-medium transition-colors"
              >
                Xóa bộ thẻ
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}