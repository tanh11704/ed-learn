import { Search, Filter } from 'lucide-react';

interface LessonFiltersProps {
  searchTerm: string;
  setSearchTerm: (val: string) => void;
  subjectFilter: string;
  setSubjectFilter: (val: string) => void;
}

export default function LessonFilters({ searchTerm, setSearchTerm, subjectFilter, setSubjectFilter }: LessonFiltersProps) {
  return (
    <div className="flex flex-col md:flex-row items-center justify-between bg-sidebar p-4 rounded-xl border border-border gap-4">
      <div className="relative w-full max-w-md">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" size={18} />
        <input
          type="text"
          placeholder="Tìm tên bài giảng, giáo viên..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full bg-muted border border-border text-foreground text-sm rounded-lg pl-10 pr-4 py-2 focus:outline-none focus:border-primary"
        />
      </div>
      <div className="flex gap-2 w-full md:w-auto">
        <select 
          value={subjectFilter}
          onChange={(e) => setSubjectFilter(e.target.value)}
          className="flex-1 md:flex-none bg-muted border border-border text-foreground/90 text-sm rounded-lg px-3 py-2 focus:outline-none focus:border-primary"
        >
          <option value="all">Tất cả môn học</option>
          <option value="Toán học">Toán học</option>
          <option value="Tiếng Anh">Tiếng Anh</option>
          <option value="Vật lý">Vật lý</option>
        </select>
        <button className="p-2 bg-muted border border-border text-muted-foreground rounded-lg hover:text-foreground transition-colors">
          <Filter size={18} />
        </button>
      </div>
    </div>
  );
}