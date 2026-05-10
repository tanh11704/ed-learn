import { useState } from 'react';
import { Plus } from 'lucide-react';
import { FlashcardDeck } from './types';
import FlashcardFilters from './components/FlashcardFilters';
import FlashcardGrid from './components/FlashcardGrid';
import DeckFormModal from './components/DeckFormModal';
import StudyModal from './components/StudyModal';
import DeckDetail from './components/DeckDetail';
import DeleteDeckDialog from './components/DeleteDeckDialog';

// MOCK DATA CÓ CHỨA CARDS
const MOCK_DECKS: FlashcardDeck[] = [
  { 
    id: '1', title: 'Công thức Vật Lý 12 - Ôn thi ĐH', subject: 'Vật lý', cardCount: 2, createdAt: '5 giờ trước', author: 'Minh Giáo Viên',
    cards: [
      { id: 'c1', front: 'Công thức tính chu kỳ con lắc đơn?', back: 'T = 2π√(l/g)' },
      { id: 'c2', front: 'Công thức tính chu kỳ con lắc lò xo?', back: 'T = 2π√(m/k)' }
    ]
  },
  { 
    id: '2', title: '1000 Từ vựng TOEIC Cơ bản', subject: 'Tiếng Anh', cardCount: 0, createdAt: '2 ngày trước', author: 'Hệ thống AI',
    cards: []
  }
];

export default function FlashcardsManagement() {
  const [decks, setDecks] = useState<FlashcardDeck[]>(MOCK_DECKS);
  
  // Navigation State
  const [activeDeckId, setActiveDeckId] = useState<string | null>(null);

  // Filters
  const [searchTerm, setSearchTerm] = useState('');
  const [sortBy, setSortBy] = useState<'newest' | 'popular'>('newest');
  
  // Modals
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingDeck, setEditingDeck] = useState<FlashcardDeck | null>(null);
  const [isStudyOpen, setIsStudyOpen] = useState(false);
  const [studyingDeck, setStudyingDeck] = useState<FlashcardDeck | null>(null);
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [deletingDeckId, setDeletingDeckId] = useState<string | null>(null);

  // === HANDLERS ===
  const handleSaveDeck = (data: Partial<FlashcardDeck>) => {
    if (editingDeck) {
      setDecks(decks.map(d => d.id === editingDeck.id ? { ...d, ...data } as FlashcardDeck : d));
    } else {
      const newDeck: FlashcardDeck = {
        id: Date.now().toString(),
        title: data.title!,
        subject: data.subject!,
        cardCount: 0,
        createdAt: 'Vừa xong',
        author: 'Admin',
        cards: []
      };
      setDecks([newDeck, ...decks]);
    }
  };

  const updateSpecificDeck = (updatedDeck: FlashcardDeck) => {
    setDecks(decks.map(d => d.id === updatedDeck.id ? updatedDeck : d));
  };

  const handleDeleteDeck = (deckId: string) => {
    setDeletingDeckId(deckId);
    setIsDeleteDialogOpen(true);
  };

  const confirmDelete = () => {
    if (deletingDeckId) {
      setDecks(decks.filter(d => d.id !== deletingDeckId));
      setIsDeleteDialogOpen(false);
      setDeletingDeckId(null);
    }
  };

  // Lấy deck đang active để hiển thị chi tiết
  const activeDeck = decks.find(d => d.id === activeDeckId) || null;

  return (
    <div className="max-w-[1600px] mx-auto pb-10">
      
      {/* NẾU CÓ ACTIVE DECK -> HIỂN THỊ TRANG CHI TIẾT */}
      {activeDeck ? (
        <DeckDetail 
          deck={activeDeck} 
          onBack={() => setActiveDeckId(null)} 
          onUpdateDeck={updateSpecificDeck}
          onStudy={(deck) => { setStudyingDeck(deck); setIsStudyOpen(true); }}
        />
      ) : (
        /* NẾU KHÔNG -> HIỂN THỊ DANH SÁCH CHỦ ĐỀ */
        <div className="animate-in fade-in duration-300">
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
            <div>
              <h1 className="text-2xl font-bold text-foreground tracking-tight">Quản lý Flashcards</h1>
              <p className="text-muted-foreground text-sm mt-1">Tạo và quản lý các bộ thẻ ghi nhớ thông minh.</p>
            </div>
            <button onClick={() => { setEditingDeck(null); setIsFormOpen(true); }} className="flex items-center gap-2 px-5 py-2.5 bg-primary hover:bg-primary/90 text-primary-foreground rounded-lg font-medium shadow-lg transition-all">
              <Plus size={18} /> Tạo chủ đề mới
            </button>
          </div>

          <FlashcardFilters searchTerm={searchTerm} setSearchTerm={setSearchTerm} sortBy={sortBy} setSortBy={setSortBy} />

          <FlashcardGrid 
            decks={decks.filter(d => d.title.toLowerCase().includes(searchTerm.toLowerCase()))}
            onView={(deck) => setActiveDeckId(deck.id)}
            onStudy={(deck) => { setStudyingDeck(deck); setIsStudyOpen(true); }}
            onEdit={(deck) => { setEditingDeck(deck); setIsFormOpen(true); }}
            onDelete={handleDeleteDeck}
          />
        </div>
      )}

      {/* Global Modals */}
      <DeckFormModal isOpen={isFormOpen} onClose={() => setIsFormOpen(false)} onSave={handleSaveDeck} initialData={editingDeck} />
      <StudyModal isOpen={isStudyOpen} onClose={() => setIsStudyOpen(false)} deck={studyingDeck} />
      <DeleteDeckDialog
        isOpen={isDeleteDialogOpen}
        onClose={() => setIsDeleteDialogOpen(false)}
        onConfirm={confirmDelete}
        deckTitle={
          deletingDeckId
            ? decks.find(d => d.id === deletingDeckId)?.title || ''
            : ''
        }
        cardCount={
          deletingDeckId
            ? decks.find(d => d.id === deletingDeckId)?.cardCount || 0
            : 0
        }
      />
    </div>
  );
}