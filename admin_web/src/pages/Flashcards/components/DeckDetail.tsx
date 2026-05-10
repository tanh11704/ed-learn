import { useState } from 'react';
import { ArrowLeft, Plus, Edit2, Trash2, Play } from 'lucide-react';
import { FlashcardDeck, FlashcardItem } from '../types';
import CardFormModal from './CardFormModal.tsx';

interface DeckDetailProps {
  deck: FlashcardDeck;
  onBack: () => void;
  onUpdateDeck: (updatedDeck: FlashcardDeck) => void;
  onStudy: (deck: FlashcardDeck) => void;
}

export default function DeckDetail({ deck, onBack, onUpdateDeck, onStudy }: DeckDetailProps) {
  const [isCardFormOpen, setIsCardFormOpen] = useState(false);
  const [editingCard, setEditingCard] = useState<FlashcardItem | null>(null);

  const handleSaveCard = (data: Partial<FlashcardItem>) => {
    let updatedCards;
    if (editingCard) {
      updatedCards = deck.cards.map(c => c.id === editingCard.id ? { ...c, ...data } as FlashcardItem : c);
    } else {
      const newCard: FlashcardItem = {
        id: Date.now().toString(),
        front: data.front!,
        back: data.back!
      };
      updatedCards = [...deck.cards, newCard];
    }
    
    // Cập nhật lại Deck với danh sách thẻ mới và count mới
    onUpdateDeck({
      ...deck,
      cards: updatedCards,
      cardCount: updatedCards.length
    });
  };

  const handleDeleteCard = (cardId: string) => {
    if (confirm('Xóa thẻ bài này?')) {
      const updatedCards = deck.cards.filter(c => c.id !== cardId);
      onUpdateDeck({
        ...deck,
        cards: updatedCards,
        cardCount: updatedCards.length
      });
    }
  };

  const openAddCard = () => {
    setEditingCard(null);
    setIsCardFormOpen(true);
  };

  return (
    <div className="animate-in fade-in slide-in-from-bottom-4 duration-500">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <div className="flex items-center gap-4">
          <button onClick={onBack} className="p-2 bg-muted hover:bg-muted/80 text-foreground rounded-lg transition-colors">
            <ArrowLeft size={20} />
          </button>
          <div>
            <h1 className="text-2xl font-bold text-foreground">{deck.title}</h1>
            <p className="text-muted-foreground text-sm mt-1">{deck.cardCount} thẻ • Môn {deck.subject}</p>
          </div>
        </div>
        <div className="flex gap-3">
          <button onClick={() => onStudy(deck)} disabled={deck.cards.length === 0} className="flex items-center gap-2 px-5 py-2.5 bg-card border border-border text-foreground hover:bg-muted disabled:opacity-50 rounded-lg font-medium transition-all">
            <Play size={18} fill="currentColor" /> Học thử
          </button>
          <button onClick={openAddCard} className="flex items-center gap-2 px-5 py-2.5 bg-primary hover:bg-primary/90 text-primary-foreground rounded-lg font-medium transition-all shadow-lg shadow-brand">
            <Plus size={18} /> Thêm thẻ
          </button>
        </div>
      </div>

      {/* Cards List */}
      <div className="space-y-4">
        {deck.cards.length === 0 ? (
          <div className="text-center py-20 bg-sidebar border border-border rounded-2xl">
            <p className="text-muted-foreground mb-4">Chủ đề này chưa có thẻ nào.</p>
            <button onClick={openAddCard} className="text-primary hover:text-primary font-medium">+ Thêm thẻ đầu tiên</button>
          </div>
        ) : (
          deck.cards.map((card, index) => (
            <div key={card.id} className="bg-sidebar border border-border rounded-xl p-5 flex items-start gap-6 group hover:border-border transition-colors">
              <span className="text-muted-foreground font-bold w-6">{index + 1}</span>
              <div className="flex-1 grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="text-foreground relative md:pr-6 md:border-r border-border/80">
                  <span className="text-xs text-muted-foreground uppercase mb-2 block">Mặt trước</span>
                  <p className="whitespace-pre-wrap">{card.front}</p>
                </div>
                <div className="text-foreground/90 relative">
                  <span className="text-xs text-muted-foreground uppercase mb-2 block">Mặt sau</span>
                  <p className="whitespace-pre-wrap">{card.back}</p>
                </div>
              </div>
              <div className="flex gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                <button onClick={() => { setEditingCard(card); setIsCardFormOpen(true); }} className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-lg"><Edit2 size={16} /></button>
                <button onClick={() => handleDeleteCard(card.id)} className="p-2 text-red-400 hover:text-red-300 hover:bg-red-500/10 rounded-lg"><Trash2 size={16} /></button>
              </div>
            </div>
          ))
        )}
      </div>

      <CardFormModal isOpen={isCardFormOpen} onClose={() => setIsCardFormOpen(false)} onSave={handleSaveCard} initialData={editingCard} />
    </div>
  );
}