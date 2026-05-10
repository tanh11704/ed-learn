import React from 'react';
import { Eye, Save, Box, AlertTriangle } from 'lucide-react';
import { AIAsset } from '../types';

interface Props {
  generatedAsset: AIAsset | null;
  isGenerating: boolean;
}

export default function PreviewPanel({ generatedAsset, isGenerating }: Props) {
  return (
    <div className="bg-card border border-border rounded-[32px] p-8 flex flex-col h-full shadow-2xl relative overflow-hidden">
      <div className="flex justify-between items-start mb-8">
        <div className="flex items-center gap-4">
          <div className="p-3 bg-muted rounded-2xl border border-border shrink-0">
            <Eye size={24} className="text-muted-foreground" />
          </div>
          <h2 className="text-xl font-bold max-w-[100px] leading-tight">Preview kết quả</h2>
        </div>
        
        {/* Nút Save */}
        <button 
          disabled={!generatedAsset || isGenerating}
          className="flex items-center gap-2 px-4 py-3 bg-muted border border-border hover:border-border disabled:opacity-50 text-foreground rounded-2xl text-sm font-medium transition-all shadow-md"
        >
          <Save size={18} /> Lưu tài sản
        </button>
      </div>

      <div className="flex-1 rounded-[24px] bg-muted border border-border flex flex-col items-center justify-center p-8 text-center shadow-inner">
        {isGenerating ? (
          <div className="space-y-6">
             <div className="w-14 h-14 rounded-full border-[3px] border-border border-t-primary animate-spin mx-auto"></div>
             <p className="text-muted-foreground text-sm max-w-[200px] mx-auto leading-relaxed">AI đang vẽ hình hoặc soạn nội dung cho bạn. Vui lòng chờ...</p>
          </div>
        ) : generatedAsset ? (
          <div className="space-y-4">
             <Box size={48} className="text-primary mx-auto" />
             <h4 className="font-bold text-foreground text-lg">Kết quả đã sẵn sàng</h4>
             <p className="text-muted-foreground text-sm max-w-[250px] mx-auto leading-relaxed">Hãy kiểm tra kỹ trước khi nhấn Lưu tài sản.</p>
             <p className="text-xs bg-card p-4 rounded-xl text-muted-foreground border border-border mt-4 text-left">{generatedAsset.prompt}</p>
          </div>
        ) : (
          <div className="space-y-6">
             <AlertTriangle size={48} className="text-muted-foreground mx-auto" strokeWidth={1.5} />
             <p className="text-muted-foreground text-sm max-w-[220px] mx-auto leading-relaxed">Kết quả tạo từ AI sẽ hiển thị tại đây. Nhập prompt bên trái và nhấn Bắt đầu tạo.</p>
          </div>
        )}
      </div>
    </div>
  );
}