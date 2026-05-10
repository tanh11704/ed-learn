import React from 'react';
import { Key } from 'lucide-react';

export default function AIIntegrationTab() {
  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      <h2 className="text-lg font-bold border-b border-border pb-4">Cấu hình API & Trí tuệ nhân tạo</h2>
      
      <div className="space-y-6">
        <div className="space-y-2">
          <label className="text-sm text-muted-foreground">OpenAI API Key</label>
          <div className="relative">
            <Key size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
            <input type="password" defaultValue="sk-proj-xxxxxxxx" className="w-full bg-muted border border-border rounded-xl py-3 pl-10 pr-4 focus:border-primary outline-none transition-all" />
          </div>
          <p className="text-xs text-muted-foreground">Khóa này được sử dụng cho tính năng tạo câu hỏi và chấm điểm tự động.</p>
        </div>

        <div className="space-y-2">
          <label className="text-sm text-muted-foreground">Mô hình AI mặc định</label>
          <select className="w-full bg-muted border border-border rounded-xl p-3 focus:border-primary outline-none transition-all appearance-none">
            <option value="gpt-4o">GPT-4o (Đề xuất - Nhanh & Thông minh)</option>
            <option value="gpt-3.5-turbo">GPT-3.5 Turbo (Tiết kiệm)</option>
          </select>
        </div>
      </div>
    </div>
  );
}