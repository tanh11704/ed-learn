import { Search } from 'lucide-react';

interface ExamFiltersProps {
  searchTerm: string;
  setSearchTerm: (value: string) => void;
  subjectFilter: string;
  setSubjectFilter: (value: string) => void;
  statusFilter: string;
  setStatusFilter: (value: string) => void;
}

export default function ExamFilters({
  searchTerm, setSearchTerm, 
  subjectFilter, setSubjectFilter, 
  statusFilter, setStatusFilter
}: ExamFiltersProps) {
  return (
    <div className="flex flex-col md:flex-row items-center justify-between bg-sidebar p-4 rounded-xl border border-border gap-4">
      <div className="relative w-full max-w-md">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" size={18} />
        <input
          type="text"
          placeholder="Tìm kiếm tên đề thi..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full bg-muted border border-border text-foreground text-sm rounded-lg pl-10 pr-4 py-2 focus:outline-none focus:border-primary transition-colors"
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
          <option value="Vật lý">Vật lý</option>
          <option value="Hóa học">Hóa học</option>
          <option value="Tiếng Anh">Tiếng Anh</option>
        </select>
        <select 
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
          className="flex-1 md:flex-none bg-muted border border-border text-foreground/90 text-sm rounded-lg px-3 py-2 focus:outline-none focus:border-primary"
        >
          <option value="all">Tất cả trạng thái</option>
          <option value="completed">Đã bóc tách</option>
          <option value="processing">Đang xử lý</option>
        </select>
      </div>
    </div>
  );
}