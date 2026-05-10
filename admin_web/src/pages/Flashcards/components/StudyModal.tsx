import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, RefreshCcw, ChevronLeft, ChevronRight, AlertCircle } from 'lucide-react';
import { FlashcardDeck } from '../types';

interface StudyModalProps {
  isOpen: boolean;
  onClose: () => void;
  deck: FlashcardDeck | null;
}

export default function StudyModal({ isOpen, onClose, deck }: StudyModalProps) {
  const [isFlipped, setIsFlipped] = useState(false);
  const [currentIndex, setCurrentIndex] = useState(0);

  // Reset lại trạng thái mỗi khi mở Modal hoặc đổi bộ thẻ
  useEffect(() => {
    if (isOpen) {
      setCurrentIndex(0);
      setIsFlipped(false);
    }
  }, [isOpen, deck]);

  if (!deck) return null;

  // Kiểm tra xem bộ thẻ có thẻ bài nào không
  const hasCards = deck.cards && deck.cards.length > 0;
  const currentCard = hasCards ? deck.cards[currentIndex] : null;

  const handleNext = () => {
    if (hasCards && currentIndex < deck.cards.length - 1) {
      setIsFlipped(false); // Úp thẻ lại trước khi chuyển
      setTimeout(() => setCurrentIndex((prev) => prev + 1), 150);
    }
  };

  const handlePrev = () => {
    if (hasCards && currentIndex > 0) {
      setIsFlipped(false); // Úp thẻ lại trước khi chuyển
      setTimeout(() => setCurrentIndex((prev) => prev - 1), 150);
    }
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center px-4">
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={onClose} className="absolute inset-0 bg-black/90 backdrop-blur-sm" />
          
          <div className="relative z-10 w-full max-w-3xl flex flex-col items-center">
            {/* Header */}
            <div className="w-full flex justify-between items-center mb-6">
              <div className="text-foreground">
                <h2 className="text-2xl font-bold">{deck.title}</h2>
                {hasCards && (
                  <p className="text-primary font-medium text-sm mt-1">
                    Đang học • Thẻ {currentIndex + 1} / {deck.cards.length}
                  </p>
                )}
              </div>
              <button onClick={onClose} className="p-3 bg-muted hover:bg-muted/80 rounded-full text-foreground transition-colors">
                <X size={24} />
              </button>
            </div>

            {/* Xử lý trường hợp bộ thẻ rỗng */}
            {!hasCards ? (
              <div className="w-full aspect-[3/2] bg-sidebar border border-border rounded-3xl flex flex-col items-center justify-center text-muted-foreground">
                <AlertCircle size={48} className="mb-4 text-muted-foreground" />
                <p className="text-lg font-medium text-foreground mb-2">Chưa có thẻ nào</p>
                <p>Hãy thêm thẻ vào bộ bài này trước khi bắt đầu học nhé.</p>
              </div>
            ) : (
              <>
                {/* Flashcard Area */}
                <div 
                  className="w-full aspect-[3/2] perspective-1000 cursor-pointer"
                  onClick={() => setIsFlipped(!isFlipped)}
                >
                  <motion.div 
                    className="w-full h-full relative preserve-3d"
                    animate={{ rotateX: isFlipped ? 180 : 0 }}
                    transition={{ duration: 0.6, type: "spring", stiffness: 260, damping: 20 }}
                  >
                    {/* Mặt trước */}
                    <div className="absolute w-full h-full bg-card rounded-3xl p-8 sm:p-12 backface-hidden shadow-2xl flex flex-col items-center justify-center border-4 border-primary-subtle overflow-hidden">
                      <span className="absolute top-6 left-6 text-primary font-bold uppercase tracking-wider text-xs sm:text-sm">Mặt trước</span>
                      
                      {/* Thêm overflow-y-auto đề phòng chữ quá dài */}
                      <div className="max-h-full overflow-y-auto w-full flex items-center justify-center no-scrollbar">
                        <h3 className="text-2xl sm:text-4xl font-bold text-foreground text-center whitespace-pre-wrap leading-relaxed">
                          {currentCard?.front}
                        </h3>
                      </div>

                      <div className="absolute bottom-6 text-muted-foreground flex items-center gap-2 text-sm">
                        <RefreshCcw size={16} /> Nhấp để lật thẻ
                      </div>
                    </div>

                    {/* Mặt sau */}
                    <div className="absolute w-full h-full bg-primary rounded-3xl p-8 sm:p-12 backface-hidden shadow-2xl flex flex-col items-center justify-center overflow-hidden" style={{ transform: "rotateX(180deg)" }}>
                      <span className="absolute top-6 left-6 text-primary-foreground/60 font-bold uppercase tracking-wider text-xs sm:text-sm">Mặt sau</span>
                      
                      <div className="max-h-full overflow-y-auto w-full flex items-center justify-center no-scrollbar">
                        <h3 className="text-2xl sm:text-4xl font-bold text-primary-foreground text-center whitespace-pre-wrap leading-relaxed">
                          {currentCard?.back}
                        </h3>
                      </div>

                      <div className="absolute bottom-6 text-primary-foreground/90 flex items-center gap-2 text-sm">
                        <RefreshCcw size={16} /> Nhấp để lật thẻ
                      </div>
                    </div>
                  </motion.div>
                </div>

                {/* Controls (Next / Prev) */}
                <div className="flex items-center gap-6 mt-8">
                  <button 
                    onClick={handlePrev}
                    disabled={currentIndex === 0}
                    className="p-4 bg-muted hover:bg-muted/80 text-foreground rounded-full transition-colors disabled:opacity-30 disabled:cursor-not-allowed shadow-lg"
                  >
                    <ChevronLeft size={24} />
                  </button>
                  <button 
                    onClick={handleNext}
                    disabled={currentIndex === deck.cards.length - 1}
                    className="p-4 bg-muted hover:bg-muted/80 text-foreground rounded-full transition-colors disabled:opacity-30 disabled:cursor-not-allowed shadow-lg"
                  >
                    <ChevronRight size={24} />
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      )}
    </AnimatePresence>
  );
}