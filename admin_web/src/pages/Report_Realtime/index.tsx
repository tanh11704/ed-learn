import React, { useState, useEffect } from 'react';
import { Users, BookOpen, Target, Activity as ActivityIcon } from 'lucide-react';
import StatCard from './components/StatCard';
import RecentActivity from './components/RecentActivity';
import { Activity } from './types';
import AnalyticsChart from './components/AnalyticsChart';

export default function Reports() {
  const [activities, setActivities] = useState<Activity[]>([
    { id: '1', user: 'Nguyễn Văn A', action: 'nộp bài', target: 'Ôn tập Giải tích 12', time: 'Vừa xong', score: 9.5 },
    { id: '2', user: 'Trần Thị B', action: 'đang làm bài', target: 'Ngữ pháp Tiếng Anh', time: '1 phút trước' },
    { id: '3', user: 'Hệ thống AI', action: 'tạo mới', target: 'Flashcard 1000 Từ vựng TOEIC', time: '5 phút trước' },
  ]);

  const [stats, setStats] = useState({
    online: 124,
    testsCompleted: 856,
  });

  // Mô phỏng Real-time: Cập nhật dữ liệu ngẫu nhiên mỗi 5 giây
  useEffect(() => {
    const interval = setInterval(() => {
      setStats(prev => ({ ...prev, online: prev.online + Math.floor(Math.random() * 5) - 2 }));
      
      const newActivity: Activity = {
        id: Date.now().toString(),
        user: `Học sinh ẩn danh ${Math.floor(Math.random() * 1000)}`,
        action: Math.random() > 0.5 ? 'nộp bài' : 'đang làm bài',
        target: 'Bài kiểm tra định kỳ',
        time: 'Vừa xong',
        score: Math.random() > 0.5 ? Math.floor(Math.random() * 4) + 6 : undefined
      };

      setActivities(prev => [newActivity, ...prev].slice(0, 10)); // Giữ lại 10 log gần nhất
    }, 5000);

    return () => clearInterval(interval);
  }, []);

  return (
    <div className="min-h-screen bg-background text-foreground p-8">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold flex items-center gap-3">
          <ActivityIcon className="text-primary" size={32} /> 
          Trung tâm Báo cáo
        </h1>
        <p className="text-muted-foreground text-sm mt-2">
          Theo dõi tiến độ học tập và các luồng sự kiện đang diễn ra trên hệ thống.
        </p>
      </div>

      {/* Grid Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <StatCard 
          title="Học sinh đang Online" 
          value={stats.online} 
          data={{ title: "Học sinh đang Online", value: stats.online, trend: 12.5, isUp: true }}
          icon={<Users size={24} />} 
          colorClass="bg-blue-500/10 text-blue-500"
        />
        <StatCard 
          title="Lượt nộp bài hôm nay" 
          value={stats.testsCompleted} 
          data={{ title: "Lượt nộp bài hôm nay", value: stats.testsCompleted, trend: 8.2, isUp: true }}
          icon={<Target size={24} />} 
          colorClass="bg-emerald-500/10 text-emerald-500"
        />
        <StatCard 
          title="Tỷ lệ hoàn thành bài" 
          value="87%" 
          data={{ title: "Tỷ lệ hoàn thành bài", value: "87%", trend: 2.1, isUp: false }}
          icon={<BookOpen size={24} />} 
          colorClass="bg-purple-500/10 text-purple-500"
        />
      </div>

      {/* Main Content Area */}
      <div className="flex flex-col lg:flex-row gap-6">
        <div className="flex-[2] bg-card border border-border rounded-[24px] p-6 flex flex-col min-h-[400px]">
          <AnalyticsChart />
        </div>
        <RecentActivity activities={activities} />
      </div>
    </div>
  );
}