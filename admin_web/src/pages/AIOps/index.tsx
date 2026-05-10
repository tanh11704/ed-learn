import React, { useState } from 'react';
import GenerationPanel from './components/GenerationPanel';
import PreviewPanel from './components/PreviewPanel';
import AssetManager from './components/AssetManager'; // Import Component mới
import { AIAsset } from './types';

export default function AIOperations() {
  const [isGenerating, setIsGenerating] = useState(false);
  const [generatedAsset, setGeneratedAsset] = useState<AIAsset | null>(null);
  
  // Mảng lưu trữ các tài sản đã được Save (hiện tại để rỗng để hiển thị Empty State)
  const [savedAssets, setSavedAssets] = useState<AIAsset[]>([]);

  const handleGenerate = (prompt: string, type: string) => {
    setIsGenerating(true);
    setGeneratedAsset(null);
    
    // Giả lập AI chạy trong 3 giây
    setTimeout(() => {
      setIsGenerating(false);
      setGeneratedAsset({
        id: Date.now().toString(),
        type: type as any,
        prompt: prompt,
        data: 'dummy_data', 
        createdAt: 'Vừa xong',
        status: 'preview'
      });
    }, 3000);
  };

  // Hàm xử lý khi bấm nút "Lưu tài sản" từ PreviewPanel (bạn sẽ nối props này sau)
  const handleSaveAsset = () => {
    if (generatedAsset) {
      setSavedAssets(prev => [generatedAsset, ...prev]);
      setGeneratedAsset(null); // Clear preview sau khi lưu
    }
  };

  return (
    <div className="min-h-screen bg-background text-foreground p-8">
      {/* Layout 3 Cột Đều Nhau */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 h-[calc(100vh-64px)] min-h-[700px]">
        
        {/* Cột 1: Tạo tài sản */}
        <div className="h-full">
          <GenerationPanel onGenerate={handleGenerate} isGenerating={isGenerating} />
        </div>

        {/* Cột 2: Preview */}
        <div className="h-full">
          <PreviewPanel 
            generatedAsset={generatedAsset} 
            isGenerating={isGenerating} 
            // onSave={handleSaveAsset} // Truyền hàm này vào PreviewPanel sau
          />
        </div>

        {/* Cột 3: Thư viện (Asset Manager) */}
        <div className="h-full">
          <AssetManager savedAssets={savedAssets} />
        </div>

      </div>
    </div>
  );
}