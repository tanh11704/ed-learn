import React from 'react';
import { LayoutGrid, BotMessageSquare, FileText, Layers, BookOpenText, MoreVertical } from 'lucide-react';
import { AIAsset } from '../types';

interface Props {
  savedAssets: AIAsset[];
}

export default function AssetManager({ savedAssets }: Props) {
  // Hàm phụ trợ để render icon theo loại tài sản
  const getAssetIcon = (type: string) => {
    switch (type) {
      case 'exam': return <FileText size={18} className="text-primary" />;
      case 'flashcards': return <Layers size={18} className="text-purple-400" />;
      case 'quiz': return <BookOpenText size={18} className="text-emerald-400" />;
      default: return <FileText size={18} className="text-muted-foreground" />;
    }
  };

  const getAssetLabel = (type: string) => {
    switch (type) {
      case 'exam': return 'Đề thi thử';
      case 'flashcards': return 'Flashcards';
      case 'quiz': return 'Bài Quiz';
      default: return 'Tài sản AI';
    }
  };

  return (
    <div className="bg-card border border-border rounded-[32px] p-8 shadow-2xl h-full flex flex-col overflow-hidden">
      <div className="flex items-start gap-4 mb-8">
        <div className="p-3 bg-muted rounded-2xl border border-border shrink-0 text-muted-foreground">
          <LayoutGrid size={24} />
        </div>
        <div>
          <h2 className="text-xl font-bold mt-1">Thư viện tài sản AI</h2>
          <p className="text-muted-foreground text-sm mt-1">Quản lý các tài sản đã lưu.</p>
        </div>
      </div>
      
      <div className="flex-1 flex flex-col overflow-y-auto custom-scrollbar pr-2">
        {savedAssets.length === 0 ? (
          /* TRẠNG THÁI TRỐNG (EMPTY STATE) */
          <div className="flex-1 rounded-[24px] border border-border/80 border-dashed flex flex-col items-center justify-center p-8 text-center bg-muted/30">
            <BotMessageSquare size={48} className="mx-auto mb-6 text-muted-foreground" strokeWidth={1.5} />
            <p className="text-muted-foreground text-sm max-w-[200px] leading-relaxed">
              Tài sản AI sau khi bạn nhấn "Lưu" sẽ xuất hiện tại đây.
            </p>
          </div>
        ) : (
          /* DANH SÁCH TÀI SẢN ĐÃ LƯU */
          <div className="space-y-3">
            {savedAssets.map((asset) => (
              <div 
                key={asset.id} 
                className="bg-muted border border-border rounded-2xl p-4 flex items-center gap-4 hover:border-border transition-all cursor-pointer group"
              >
                <div className="p-3 bg-card rounded-xl border border-border group-hover:bg-muted transition-colors">
                  {getAssetIcon(asset.type)}
                </div>
                <div className="flex-1 min-w-0">
                  <h4 className="text-foreground font-medium text-sm truncate" title={asset.prompt}>
                    {asset.prompt || 'Tài sản chưa có tên'}
                  </h4>
                  <p className="text-xs text-muted-foreground mt-1 flex items-center gap-2">
                    <span className="px-2 py-0.5 bg-muted rounded-md">{getAssetLabel(asset.type)}</span>
                    <span>• {asset.createdAt}</span>
                  </p>
                </div>
                <button className="p-2 hover:bg-muted rounded-lg text-muted-foreground hover:text-foreground/90 transition-colors opacity-0 group-hover:opacity-100">
                  <MoreVertical size={18} />
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}