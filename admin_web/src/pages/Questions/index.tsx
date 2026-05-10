import React, { useState, useMemo } from 'react';
import { Plus, ArrowLeft, Search, Filter, Edit2, Trash2, Eye } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import TopicGrid from './components/TopicGrid';
import QuestionList from './components/QuestionList';
import QuestionModal from './components/QuestionModal';
import QuestionDeleteDialog from './components/QuestionDeleteDialog';
import { Topic, Question } from './types';

// MOCK DATA
const MOCK_TOPICS: Topic[] = [
  { id: '1', title: 'Ôn tập Giải tích 12', category: 'TOÁN HỌC', count: 45, updatedAt: '2 giờ trước', author: 'Hệ thống AI' },
  { id: '2', title: 'Ngữ pháp Tiếng Anh', category: 'TIẾNG ANH', count: 120, updatedAt: '1 ngày trước', author: 'Admin' },
  { id: '3', title: 'Vật Lý 12 - Điện Từ', category: 'VẬT LÝ', count: 82, updatedAt: '3 ngày trước', author: 'Hệ thống AI' },
];

const MOCK_QUESTIONS: Question[] = [
  { id: 'q1', topicId: '1', content: 'Hàm số nào dưới đây đồng biến trên khoảng (-∞; +∞)?', subject: 'Toán học', level: 'Nhận biết', type: 'Trắc nghiệm', options: ['y = x²', 'y = 2x + 1', 'y = -x + 3', 'y = 1/x'], correctAnswer: 1, status: 'Hoạt động' },
  { id: 'q2', topicId: '2', content: 'Choose the correct answer: I usually _____ to school by bus.', subject: 'Tiếng Anh', level: 'Nhận biết', type: 'Trắc nghiệm', options: ['go', 'goes', 'going', 'gone'], correctAnswer: 0, status: 'Hoạt động' },
  { id: 'q3', topicId: '1', content: 'Tính giới hạn: lim(x→0) sin(x)/x', subject: 'Toán học', level: 'Thông hiểu', type: 'Trắc nghiệm', options: ['0', '1', '-1', 'Không tồn tại'], correctAnswer: 1, status: 'Hoạt động' },
];

export default function QuestionBank() {
  // State quản lý Topic
  const [selectedTopic, setSelectedTopic] = useState<Topic | null>(null);
  const [topics, setTopics] = useState<Topic[]>(MOCK_TOPICS);
  const [questions, setQuestions] = useState<Question[]>(MOCK_QUESTIONS);
  
  // Filter & Search
  const [searchTerm, setSearchTerm] = useState('');
  const [levelFilter, setLevelFilter] = useState<string>('all');
  const [typeFilter, setTypeFilter] = useState<string>('all');

  // Modal states
  const [isQuestionModalOpen, setIsQuestionModalOpen] = useState(false);
  const [editingQuestion, setEditingQuestion] = useState<Question | null>(null);
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [deletingQuestionId, setDeletingQuestionId] = useState<string | null>(null);

  // Filtered questions for selected topic
  const filteredQuestions = useMemo(() => {
    if (!selectedTopic) return [];
    
    return questions.filter(q => {
      if (q.topicId !== selectedTopic.id) return false;
      const matchSearch = q.content.toLowerCase().includes(searchTerm.toLowerCase());
      const matchLevel = levelFilter === 'all' || q.level === levelFilter;
      const matchType = typeFilter === 'all' || q.type === typeFilter;
      return matchSearch && matchLevel && matchType;
    });
  }, [selectedTopic, questions, searchTerm, levelFilter, typeFilter]);

  // Handlers
  const handleAddQuestion = () => {
    if (selectedTopic) {
      setEditingQuestion(null);
      setIsQuestionModalOpen(true);
    }
  };

  const handleEditQuestion = (question: Question) => {
    setEditingQuestion(question);
    setIsQuestionModalOpen(true);
  };

  const handleSaveQuestion = (questionData: Partial<Question>) => {
    if (!selectedTopic) return;

    if (editingQuestion) {
      // Update
      setQuestions(questions.map(q => 
        q.id === editingQuestion.id 
          ? { ...q, ...questionData } as Question
          : q
      ));
    } else {
      // Create
      const newQuestion: Question = {
        id: `q${Date.now()}`,
        topicId: selectedTopic.id,
        content: questionData.content || '',
        subject: questionData.subject || '',
        level: questionData.level || 'Nhận biết',
        type: questionData.type || 'Trắc nghiệm',
        options: questionData.options,
        correctAnswer: questionData.correctAnswer,
        status: 'Hoạt động'
      };
      setQuestions([newQuestion, ...questions]);
    }
    setIsQuestionModalOpen(false);
  };

  const handleDeleteQuestion = (questionId: string) => {
    setDeletingQuestionId(questionId);
    setIsDeleteDialogOpen(true);
  };

  const confirmDelete = () => {
    if (deletingQuestionId) {
      setQuestions(questions.filter(q => q.id !== deletingQuestionId));
      setIsDeleteDialogOpen(false);
      setDeletingQuestionId(null);
    }
  };

  return (
    <div className="min-h-screen bg-background text-foreground p-8">
      {/* Header Section */}
      <div className="flex justify-between items-center mb-8">
        <div className="flex items-center gap-4">
          {selectedTopic && (
            <motion.button 
              onClick={() => setSelectedTopic(null)}
              whileHover={{ scale: 1.05 }}
              className="p-2 bg-muted rounded-xl hover:bg-muted/80 transition-colors"
            >
              <ArrowLeft size={20} />
            </motion.button>
          )}
          <div>
            <h1 className="text-3xl font-bold">{selectedTopic ? selectedTopic.title : 'Ngân hàng Câu hỏi'}</h1>
            <p className="text-muted-foreground text-sm mt-1">
              {selectedTopic 
                ? `${filteredQuestions.length} / ${selectedTopic.count} câu hỏi` 
                : 'Quản lý và lưu trữ các câu hỏi trắc nghiệm, tự luận.'}
            </p>
          </div>
        </div>
        {selectedTopic && (
          <motion.button 
            onClick={handleAddQuestion}
            whileHover={{ scale: 1.05 }}
            className="bg-primary hover:bg-primary/90 text-primary-foreground px-6 py-3 rounded-2xl font-bold flex items-center gap-2 shadow-lg shadow-brand transition-all"
          >
            <Plus size={20} /> Thêm câu hỏi
          </motion.button>
        )}
      </div>

      {/* Filter Bar - Only show when topic selected */}
      {selectedTopic && (
        <div className="flex flex-col sm:flex-row gap-4 mb-8">
          <div className="relative flex-1">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" size={18} />
            <input 
              type="text" 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder="Tìm kiếm nội dung câu hỏi..." 
              className="w-full bg-card border border-border rounded-2xl py-3 pl-12 pr-4 focus:border-primary outline-none transition-all"
            />
          </div>
          <select 
            value={levelFilter}
            onChange={(e) => setLevelFilter(e.target.value)}
            className="px-4 bg-card border border-border rounded-2xl text-muted-foreground focus:text-foreground outline-none transition-all appearance-none"
          >
            <option value="all">Tất cả mức độ</option>
            <option value="Nhận biết">Nhận biết</option>
            <option value="Thông hiểu">Thông hiểu</option>
            <option value="Vận dụng">Vận dụng</option>
            <option value="Vận dụng cao">Vận dụng cao</option>
          </select>
          <select 
            value={typeFilter}
            onChange={(e) => setTypeFilter(e.target.value)}
            className="px-4 bg-card border border-border rounded-2xl text-muted-foreground focus:text-foreground outline-none transition-all appearance-none"
          >
            <option value="all">Tất cả loại</option>
            <option value="Trắc nghiệm">Trắc nghiệm</option>
            <option value="Tự luận">Tự luận</option>
          </select>
        </div>
      )}

      {/* Main View */}
      <AnimatePresence mode="wait">
        {!selectedTopic ? (
          <TopicGrid topics={topics} onSelect={setSelectedTopic} />
        ) : (
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
          >
            {/* Question List with Actions */}
            <div className="space-y-4">
              {filteredQuestions.length === 0 ? (
                <div className="text-center py-12">
                  <p className="text-muted-foreground">Không tìm thấy câu hỏi nào</p>
                </div>
              ) : (
                filteredQuestions.map((question) => (
                  <motion.div
                    key={question.id}
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    className="bg-card border border-border rounded-xl p-6 hover:border-border transition-all group"
                  >
                    <div className="flex gap-6 items-start">
                      {/* Question Content */}
                      <div className="flex-1 min-w-0">
                        <div className="flex gap-3 items-start mb-3">
                          <span className={`px-2.5 py-1 rounded text-xs font-bold whitespace-nowrap ${
                            question.type === 'Trắc nghiệm' 
                              ? 'bg-blue-500/10 text-blue-400' 
                              : 'bg-purple-500/10 text-purple-400'
                          }`}>
                            {question.type}
                          </span>
                          <span className="px-2.5 py-1 rounded text-xs font-bold bg-amber-500/10 text-amber-400 whitespace-nowrap">
                            {question.level}
                          </span>
                          <span className="px-2.5 py-1 rounded text-xs font-bold bg-muted text-muted-foreground">
                            {question.subject}
                          </span>
                        </div>
                        <p className="text-foreground font-medium line-clamp-2">{question.content}</p>
                        {question.options && (
                          <div className="mt-3 grid grid-cols-2 gap-2 text-sm text-muted-foreground">
                            {question.options.map((opt, idx) => (
                              <div 
                                key={idx}
                                className={`p-2 rounded border ${
                                  idx === question.correctAnswer 
                                    ? 'border-emerald-500/50 bg-emerald-500/10 text-emerald-400' 
                                    : 'border-border bg-sidebar'
                                }`}
                              >
                                <span className="font-bold">{String.fromCharCode(65 + idx)}.</span> {opt}
                              </div>
                            ))}
                          </div>
                        )}
                      </div>

                      {/* Actions */}
                      <div className="flex gap-2 opacity-0 sm:opacity-100 group-hover:opacity-100 transition-opacity shrink-0">
                        <button
                          onClick={() => handleEditQuestion(question)}
                          className="p-2.5 hover:bg-blue-500/10 rounded-lg text-blue-400 hover:text-blue-300 transition-colors"
                          title="Chỉnh sửa"
                        >
                          <Edit2 size={18} />
                        </button>
                        <button
                          onClick={() => handleDeleteQuestion(question.id)}
                          className="p-2.5 hover:bg-red-500/10 rounded-lg text-red-400 hover:text-red-300 transition-colors"
                          title="Xóa"
                        >
                          <Trash2 size={18} />
                        </button>
                      </div>
                    </div>
                  </motion.div>
                ))
              )}
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Modals */}
      <QuestionModal
        isOpen={isQuestionModalOpen}
        onClose={() => setIsQuestionModalOpen(false)}
        onSave={handleSaveQuestion}
        question={editingQuestion}
        topic={selectedTopic}
      />

      <QuestionDeleteDialog
        isOpen={isDeleteDialogOpen}
        onClose={() => setIsDeleteDialogOpen(false)}
        onConfirm={confirmDelete}
        questionContent={
          deletingQuestionId
            ? questions.find(q => q.id === deletingQuestionId)?.content || ''
            : ''
        }
      />
    </div>
  );
}