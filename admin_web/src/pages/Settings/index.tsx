import React, { useState } from 'react';
import { User, Shield, Monitor, Cpu, LogOut, Save } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';

// Import các components con
import ProfileTab from './components/ProfileTab';
import SystemTab from './components/SystemTab';
import AIIntegrationTab from './components/AIIntegrationTab';
import SecurityTab from './components/SecurityTab';

const SETTINGS_TABS = [
  { id: 'profile', label: 'Hồ sơ cá nhân', icon: User },
  { id: 'system', label: 'Hệ thống', icon: Monitor },
  { id: 'ai-integration', label: 'Tích hợp AI', icon: Cpu },
  { id: 'security', label: 'Bảo mật', icon: Shield },
];

export default function Settings() {
  const [activeTab, setActiveTab] = useState('profile');
  const [isSaving, setIsSaving] = useState(false);
  
  const { logout } = useAuth();
  const navigate = useNavigate();

  const handleSave = () => {
    setIsSaving(true);
    setTimeout(() => setIsSaving(false), 1000);
  };

  const handleLogout = async () => {
    await logout();
    navigate('/login');
  };

  return (
    <div className="min-h-screen bg-background text-foreground p-8">
      <div className="max-w-6xl mx-auto">
        <div className="mb-8">
          <h1 className="text-2xl font-bold mb-2">Cài đặt hệ thống</h1>
          <p className="text-muted-foreground text-sm">Quản lý thông tin cá nhân, cấu hình hệ thống và bảo mật.</p>
        </div>

        <div className="flex flex-col md:flex-row gap-8">
          {/* Cột trái: Menu & Logout */}
          <div className="w-full md:w-64 shrink-0 flex flex-col gap-4">
            <div className="bg-card border border-border rounded-3xl p-3 flex flex-col gap-1">
              {SETTINGS_TABS.map((tab) => {
                const Icon = tab.icon;
                return (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`flex items-center gap-3 w-full px-4 py-3 rounded-2xl transition-all text-sm font-medium ${
                      activeTab === tab.id
                        ? 'bg-primary-subtle text-primary'
                        : 'text-muted-foreground hover:bg-muted hover:text-foreground'
                    }`}
                  >
                    <Icon size={18} />
                    {tab.label}
                  </button>
                );
              })}
            </div>

            {/* Nút Đăng xuất */}
            <div className="bg-card border border-border rounded-3xl p-3">
              <button
                onClick={handleLogout}
                className="flex items-center gap-3 w-full px-4 py-3 rounded-2xl transition-all text-sm font-medium text-red-400 hover:bg-red-500/10"
              >
                <LogOut size={18} />
                Đăng xuất
              </button>
            </div>
          </div>

          {/* Cột phải: Nội dung chi tiết */}
          <div className="flex-1">
            <div className="bg-card border border-border rounded-[32px] p-8 shadow-2xl min-h-[500px] flex flex-col">
              
              <div className="flex-1">
                {activeTab === 'profile' && <ProfileTab />}
                {activeTab === 'system' && <SystemTab />}
                {activeTab === 'ai-integration' && <AIIntegrationTab />}
                {activeTab === 'security' && <SecurityTab />}
              </div>

              {/* Action Buttons chung */}
              <div className="mt-8 pt-6 border-t border-border flex justify-end gap-4 shrink-0">
                <button className="px-6 py-3 rounded-xl font-medium text-muted-foreground hover:text-foreground transition-colors">
                  Hủy
                </button>
                <button 
                  onClick={handleSave}
                  disabled={isSaving}
                  className="px-6 py-3 bg-primary hover:bg-primary/90 disabled:bg-primary/50 rounded-xl font-bold text-primary-foreground flex items-center gap-2 transition-all"
                >
                  <Save size={18} />
                  {isSaving ? 'Đang lưu...' : 'Lưu thay đổi'}
                </button>
              </div>

            </div>
          </div>
        </div>
      </div>
    </div>
  );
}