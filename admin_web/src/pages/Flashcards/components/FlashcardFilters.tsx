import { Search } from 'lucide-react';

interface FlashcardFiltersProps {
  searchTerm: string;
  setSearchTerm: (val: string) => void;
  sortBy: 'newest' | 'popular';
  setSortBy: (val: 'newest' | 'popular') => void;
}

export default function FlashcardFilters({ searchTerm, setSearchTerm, sortBy, setSortBy }: FlashcardFiltersProps) {
  return (
    <div className="flex flex-col md:flex-row items-center justify-between bg-sidebar p-4 rounded-xl border border-border gap-4 mb-6">
      <div className="relative w-full max-w-md">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" size={18} />
        <input
          type="text"
          placeholder="Tìm kiếm bộ Flashcard..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full bg-muted border border-border text-foreground text-sm rounded-lg pl-10 pr-4 py-2 focus:outline-none focus:border-primary"
        />
      </div>
      <div className="flex bg-muted border border-border rounded-lg p-1 w-full md:w-auto">
        <button
          onClick={() => setSortBy('newest')}
          className={`px-4 py-1.5 text-sm rounded-md transition-colors flex-1 md:flex-none ${sortBy === 'newest' ? 'bg-muted text-foreground' : 'text-muted-foreground hover:text-foreground'}`}
        >
          Mới nhất
        </button>
        <button
          onClick={() => setSortBy('popular')}
          className={`px-4 py-1.5 text-sm rounded-md transition-colors flex-1 md:flex-none ${sortBy === 'popular' ? 'bg-muted text-foreground' : 'text-muted-foreground hover:text-foreground'}`}
        >
          Phổ biến
        </button>
      </div>
    </div>
  );
}