import React from 'react';

export default function SecurityTab() {
  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      <h2 className="text-lg font-bold border-b border-border pb-4">Bảo mật tài khoản</h2>
      
      <div className="space-y-4 max-w-md">
        <div className="space-y-2">
          <label className="text-sm text-muted-foreground">Mật khẩu hiện tại</label>
          <input type="password" placeholder="••••••••" className="w-full bg-muted border border-border rounded-xl p-3 focus:border-primary outline-none transition-all" />
        </div>
        
        <div className="space-y-2">
          <label className="text-sm text-muted-foreground">Mật khẩu mới</label>
          <input type="password" placeholder="••••••••" className="w-full bg-muted border border-border rounded-xl p-3 focus:border-primary outline-none transition-all" />
        </div>

        <div className="space-y-2">
          <label className="text-sm text-muted-foreground">Xác nhận mật khẩu mới</label>
          <input type="password" placeholder="••••••••" className="w-full bg-muted border border-border rounded-xl p-3 focus:border-primary outline-none transition-all" />
        </div>
      </div>

      <div className="mt-8 pt-6 border-t border-border">
        <div className="flex items-center justify-between p-4 bg-primary-subtle border border-primary/20 rounded-xl">
          <div>
            <h4 className="font-medium text-primary">Xác thực 2 bước (2FA)</h4>
            <p className="text-sm text-muted-foreground">Bảo vệ tài khoản bằng mã qua ứng dụng Authenticator.</p>
          </div>
          <button className="px-4 py-2 bg-primary hover:bg-primary/90 rounded-xl text-sm font-medium transition-all text-primary-foreground">
            Bật 2FA
          </button>
        </div>
      </div>
    </div>
  );
}