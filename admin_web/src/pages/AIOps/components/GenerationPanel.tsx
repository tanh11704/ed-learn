import React, { useState } from 'react';
import { Sparkles, FileText, Layers, BookOpenText, Loader2 } from 'lucide-react';

interface Props {
  onGenerate: (prompt: string, type: string) => void;
  isGenerating: boolean;
}

export default function GenerationPanel({ onGenerate, isGenerating }: Props) {
  const [prompt, setPrompt] = useState('');
  const [type, setType] = useState('exam'); // Đã cập nhật mặc định là 'exam'

  const assetTypes = [
    { id: 'exam', label: 'Tạo đề thi thử', icon: <FileText size={24} /> }, // Đã sửa label và icon
    { id: 'flashcards', label: 'Bộ Flashcards', icon: <Layers size={24} /> },
    { id: 'quiz', label: 'Bài Quiz trắc nghiệm', icon: <BookOpenText size={24} /> },
  ];

  return (
    <div className="bg-card border border-border rounded-[32px] p-8 flex flex-col h-full shadow-2xl">
      <div className="flex items-start gap-4 mb-8">
        <div className="p-3 bg-primary-subtle rounded-2xl text-primary shrink-0">
          <Sparkles size={24} />
        </div>
        <div>
          <h2 className="text-xl font-bold mb-1">Tạo tài sản học tập AI</h2>
          <p className="text-muted-foreground text-sm">Mô tả những gì bạn muốn AI tạo ra dưới đây.</p>
        </div>
      </div>

      <div className="flex-1 flex flex-col gap-8">
        {/* Nhập Prompt */}
        <div className="space-y-3">
          <label className="text-sm font-medium text-muted-foreground">Prompt (Mô tả chi tiết)</label>
          <textarea 
            value={prompt}
            onChange={(e) => setPrompt(e.target.value)}
            rows={5}
            className="w-full bg-muted border border-border rounded-2xl p-5 text-foreground focus:border-primary outline-none transition-all resize-none custom-scrollbar"
            placeholder="VD: Tạo một đề thi thử môn Toán lớp 12 gồm 10 câu hỏi trắc nghiệm về phần Giải tích..."
          />
        </div>

        {/* Chọn loại tài sản */}
        <div className="space-y-3">
          <label className="text-sm font-medium text-muted-foreground">Loại tài sản cần tạo</label>
          <div className="grid grid-cols-3 gap-4">
            {assetTypes.map((item) => (
              <button 
                key={item.id}
                onClick={() => setType(item.id)}
                className={`flex flex-col items-center justify-center gap-3 p-4 rounded-2xl border transition-all h-[100px] ${
                  type === item.id 
                  ? 'bg-primary border-primary text-primary-foreground shadow-lg shadow-brand' 
                  : 'bg-muted border-border text-muted-foreground hover:border-border hover:bg-muted/50'
                }`}
              >
                {item.icon}
                <span className="font-medium text-xs text-center leading-tight">{item.label}</span>
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* Nút tạo */}
      <button 
        onClick={() => onGenerate(prompt, type)}
        disabled={isGenerating || !prompt.trim()}
        className="w-full mt-8 py-4 bg-primary hover:bg-primary/90 text-primary-foreground disabled:bg-muted disabled:border disabled:border-border disabled:text-muted-foreground rounded-2xl font-bold flex items-center justify-center gap-2 shadow-lg shadow-brand transition-all active:scale-95 disabled:shadow-none"
      >
        {isGenerating ? (
          <><Loader2 className="animate-spin" size={20} /> Đang xử lý...</>
        ) : (
          <><Sparkles size={20} /> Bắt đầu tạo</>
        )}
      </button>
    </div>
  );
}