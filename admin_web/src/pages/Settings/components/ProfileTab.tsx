import React from 'react';
import { useAuth } from '../../../contexts/AuthContext';

function initialsFromName(name: string, email: string): string {
  const n = name.trim();
  if (n.length >= 2) {
    const parts = n.split(/\s+/);
    if (parts.length >= 2) {
      return (parts[0]![0]! + parts[parts.length - 1]![0]!).toUpperCase();
    }
    return n.slice(0, 2).toUpperCase();
  }
  if (email.length >= 2) return email.slice(0, 2).toUpperCase();
  return 'AD';
}

export default function ProfileTab() {
  const { user } = useAuth();

  const initials = user
    ? initialsFromName(user.name, user.email)
    : '…';

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      <h2 className="text-lg font-bold border-b border-border pb-4">Thông tin tài khoản</h2>
      <p className="text-xs text-muted-foreground">
        Thông tin đồng bộ khi đăng nhập — không gọi thêm API trên tab này.
      </p>

      <div className="flex items-center gap-6 mb-6">
        <div className="w-20 h-20 bg-muted rounded-full flex items-center justify-center text-xl font-bold border border-border">
          {initials}
        </div>
        <p className="text-sm text-muted-foreground max-w-md">
          Avatar và số điện thoại chưa có API; chỉ hiển thị dữ liệu từ máy chủ.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="space-y-2">
          <label className="text-sm text-muted-foreground">Họ và tên</label>
          <input
            type="text"
            readOnly
            value={user?.name ?? ''}
            placeholder="—"
            className="w-full bg-muted border border-border rounded-xl p-3 text-foreground outline-none"
          />
        </div>
        <div className="space-y-2">
          <label className="text-sm text-muted-foreground">Email</label>
          <input
            type="email"
            readOnly
            value={user?.email ?? ''}
            placeholder="—"
            className="w-full bg-muted/50 border border-border rounded-xl p-3 text-muted-foreground cursor-not-allowed outline-none"
          />
        </div>
        <div className="space-y-2 md:col-span-2">
          <label className="text-sm text-muted-foreground">Vai trò</label>
          <input
            type="text"
            readOnly
            value={user?.role ?? ''}
            placeholder="—"
            className="w-full bg-muted border border-border rounded-xl p-3 text-foreground outline-none"
          />
        </div>
      </div>
    </div>
  );
}
