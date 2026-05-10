import React from 'react';

export default function SystemTab() {
  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      <h2 className="text-lg font-bold border-b border-border pb-4">Cấu hình Hệ thống</h2>
      
      <div className="space-y-6">
        <div className="space-y-2">
          <label className="text-sm text-muted-foreground">Ngôn ngữ mặc định</label>
          <select className="w-full bg-muted border border-border rounded-xl p-3 focus:border-primary outline-none transition-all appearance-none">
            <option value="vi">Tiếng Việt</option>
            <option value="en">English</option>
          </select>
        </div>

        <div className="space-y-2">
          <label className="text-sm text-muted-foreground">Múi giờ</label>
          <select className="w-full bg-muted border border-border rounded-xl p-3 focus:border-primary outline-none transition-all appearance-none">
            <option value="GMT+7">(GMT+07:00) Bangkok, Hanoi, Jakarta</option>
            <option value="UTC">UTC</option>
          </select>
        </div>

        <div className="flex items-center justify-between p-4 bg-muted border border-border rounded-xl">
          <div>
            <h4 className="font-medium text-foreground">Chế độ bảo trì</h4>
            <p className="text-sm text-muted-foreground">Tạm dừng truy cập từ học sinh để nâng cấp hệ thống.</p>
          </div>
          <label className="relative inline-flex items-center cursor-pointer">
            <input type="checkbox" className="sr-only peer" />
            <div className="w-11 h-6 bg-muted peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-border after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-card after:border-border after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-danger"></div>
          </label>
        </div>
      </div>
    </div>
  );
}