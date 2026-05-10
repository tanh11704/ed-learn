import { FileText, FileType2, CheckCircle2, Clock, Eye, Trash2, MoreVertical } from 'lucide-react';
import { Exam } from '../types';

interface ExamTableProps {
  exams: Exam[];
  onViewDetails: (exam: Exam) => void;
  onDelete: (id: number) => void;
}

export default function ExamTable({ exams, onViewDetails, onDelete }: ExamTableProps) {
  return (
    <div className="bg-sidebar border border-border rounded-xl overflow-hidden">
      <div className="overflow-x-auto">
        <table className="w-full text-left text-sm text-muted-foreground">
          <thead className="text-xs uppercase bg-muted text-muted-foreground border-b border-border">
            <tr>
              <th className="px-6 py-4 font-medium">Tên tài liệu</th>
              <th className="px-6 py-4 font-medium">Môn học</th>
              <th className="px-6 py-4 font-medium">Trạng thái AI</th>
              <th className="px-6 py-4 font-medium">Số câu hỏi</th>
              <th className="px-6 py-4 font-medium">Thời gian</th>
              <th className="px-6 py-4 font-medium text-right">Thao tác</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border/80">
            {exams.length === 0 ? (
              <tr>
                <td colSpan={6} className="px-6 py-10 text-center text-muted-foreground">
                  Không tìm thấy đề thi nào phù hợp với bộ lọc.
                </td>
              </tr>
            ) : (
              exams.map((exam) => (
                <tr key={exam.id} className="hover:bg-muted/20 transition-colors group">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className={`p-2 rounded-lg ${exam.type === 'pdf' ? 'bg-red-500/10 text-red-500' : 'bg-blue-500/10 text-blue-500'}`}>
                        {exam.type === 'pdf' ? <FileText size={18} /> : <FileType2 size={18} />}
                      </div>
                      <span className="font-medium text-foreground line-clamp-1 max-w-[300px]" title={exam.title}>
                        {exam.title}
                      </span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <span className="px-2.5 py-1 bg-muted text-foreground/90 rounded-md text-xs font-medium">
                      {exam.subject}
                    </span>
                  </td>
                  <td className="px-6 py-4">
                    {exam.status === 'completed' ? (
                      <span className="flex items-center gap-1.5 text-emerald-500 bg-emerald-500/10 px-2.5 py-1 rounded-full w-max text-xs font-medium">
                        <CheckCircle2 size={14} /> Hoàn thành
                      </span>
                    ) : (
                      <span className="flex items-center gap-1.5 text-amber-500 bg-amber-500/10 px-2.5 py-1 rounded-full w-max text-xs font-medium">
                        <Clock size={14} className="animate-spin-slow" /> Đang bóc tách...
                      </span>
                    )}
                  </td>
                  <td className="px-6 py-4">
                    <span className="text-foreground font-medium">{exam.questions > 0 ? `${exam.questions} câu` : '-'}</span>
                  </td>
                  <td className="px-6 py-4">{exam.uploadDate}</td>
                  <td className="px-6 py-4">
                    <div className="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                      <button onClick={() => onViewDetails(exam)} className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-lg transition-colors" title="Xem chi tiết">
                        <Eye size={16} />
                      </button>
                      <button onClick={() => onDelete(exam.id)} className="p-2 text-muted-foreground hover:text-red-400 hover:bg-red-500/10 rounded-lg transition-colors" title="Xóa tài liệu">
                        <Trash2 size={16} />
                      </button>
                      <button className="p-2 text-muted-foreground hover:text-foreground hover:bg-muted rounded-lg transition-colors">
                        <MoreVertical size={16} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}