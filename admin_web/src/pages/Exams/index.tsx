import { useState } from 'react';
import { FileUp } from 'lucide-react';
import { Exam } from './types';
import ExamFilters from './components/ExamFilters';
import ExamTable from './components/ExamTable';
import UploadModal from './components/UploadModal';
import DetailModal from './components/DetailModal';
import ExamDeleteDialog from './components/ExamDeleteDialog';

// Dữ liệu mẫu
const INITIAL_EXAMS: Exam[] = [
  { id: 1, title: 'Đề thi thử THPT Quốc Gia môn Toán 2024 - Sở Hà Nội', subject: 'Toán học', uploadDate: '2 giờ trước', status: 'completed', questions: 50, type: 'pdf' },
  { id: 2, title: 'Bài tập trắc nghiệm Động lực học chất điểm', subject: 'Vật lý', uploadDate: '5 giờ trước', status: 'completed', questions: 40, type: 'docx' },
  { id: 3, title: '15 Đề thi thử Tiếng Anh có đáp án chi tiết', subject: 'Tiếng Anh', uploadDate: 'Vừa xong', status: 'processing', questions: 0, type: 'pdf' },
];

export default function ExamManagement() {
  // States dữ liệu
  const [exams, setExams] = useState<Exam[]>(INITIAL_EXAMS);
  
  // States Filters
  const [searchTerm, setSearchTerm] = useState('');
  const [subjectFilter, setSubjectFilter] = useState('all');
  const [statusFilter, setStatusFilter] = useState('all');

  // States Modals
  const [isUploadModalOpen, setIsUploadModalOpen] = useState(false);
  const [viewingExam, setViewingExam] = useState<Exam | null>(null);
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [deletingExamId, setDeletingExamId] = useState<number | null>(null);

  // Xử lý Lọc danh sách
  const filteredExams = exams.filter(exam => {
    const matchesSearch = exam.title.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesSubject = subjectFilter === 'all' || exam.subject === subjectFilter;
    const matchesStatus = statusFilter === 'all' || exam.status === statusFilter;
    return matchesSearch && matchesSubject && matchesStatus;
  });

  // Handlers
  const handleDeleteExam = (id: number) => {
    setDeletingExamId(id);
    setIsDeleteDialogOpen(true);
  };

  const confirmDelete = () => {
    if (deletingExamId) {
      setExams(exams.filter(exam => exam.id !== deletingExamId));
      if (viewingExam?.id === deletingExamId) setViewingExam(null);
      setIsDeleteDialogOpen(false);
      setDeletingExamId(null);
    }
  };

  const handleUploadNewExam = (file: File, subject: string) => {
    const newExam: Exam = {
      id: Date.now(),
      title: file.name,
      subject: subject,
      uploadDate: 'Vừa xong',
      status: 'processing',
      questions: 0,
      type: file.name.toLowerCase().endsWith('.docx') ? 'docx' : 'pdf'
    };
    setExams([newExam, ...exams]);
  };

  return (
    <div className="space-y-6 max-w-[1600px] mx-auto pb-10">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold text-foreground tracking-tight">Quản lý Đề thi</h1>
          <p className="text-muted-foreground text-sm mt-1">Upload file PDF/Word để AI tự động quét và bóc tách câu hỏi.</p>
        </div>
        <button 
          onClick={() => setIsUploadModalOpen(true)}
          className="flex items-center gap-2 px-4 py-2 bg-primary hover:bg-primary/90 text-primary-foreground rounded-lg font-medium transition-colors shadow-brand"
        >
          <FileUp size={18} /> Upload Đề thi
        </button>
      </div>

      {/* Filters Component */}
      <ExamFilters 
        searchTerm={searchTerm} setSearchTerm={setSearchTerm}
        subjectFilter={subjectFilter} setSubjectFilter={setSubjectFilter}
        statusFilter={statusFilter} setStatusFilter={setStatusFilter}
      />

      {/* Table Component */}
      <ExamTable 
        exams={filteredExams} 
        onViewDetails={setViewingExam} 
        onDelete={handleDeleteExam} 
      />

      {/* Modals */}
      <UploadModal 
        isOpen={isUploadModalOpen} 
        onClose={() => setIsUploadModalOpen(false)} 
        onUpload={handleUploadNewExam} 
      />
      
      <DetailModal 
        exam={viewingExam} 
        onClose={() => setViewingExam(null)} 
      />

      {/* Delete Confirmation Dialog */}
      <ExamDeleteDialog
        isOpen={isDeleteDialogOpen}
        onClose={() => setIsDeleteDialogOpen(false)}
        onConfirm={confirmDelete}
        examTitle={
          deletingExamId
            ? exams.find(e => e.id === deletingExamId)?.title || ''
            : ''
        }
      />
    </div>
  );
}