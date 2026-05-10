import { BrowserRouter, Routes, Route } from 'react-router-dom';

import { AuthProvider } from './contexts/AuthContext';
import { ProtectedRoute } from './routes/ProtectedRoute';
import Login from './pages/Login';

import AdminLayout from './layouts/AdminLayout';
import Dashboard from './pages/Dashboard';
import StudentManagement from './pages/Students';
import ContentManagement from './pages/Questions';
import AIOps from './pages/AIOps';
import Flashcards from './pages/Flashcards';
import ExamManagement from './pages/Exams';
import LearningManagement from './pages/Learning';
import Reports from './pages/Report_Realtime';
import AIOperations from './pages/AIOps';
import Settings from './pages/Settings';
import RolesManagement from './pages/Roles';
import VirtualRooms from './pages/VirtualRooms';
import LeaderboardPage from './pages/Leaderboard';
import NotificationsPage from './pages/Notifications';
import PricingPlansPage from './pages/PricingPlans';
import TransactionsPage from './pages/Transactions';

export default function App() {
  return (
    // 3. Bọc toàn bộ App bằng AuthProvider để quản lý state đăng nhập
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          {/* Route Đăng nhập: Đứng độc lập, không có Sidebar */}
          <Route path="/login" element={<Login />} />

          {/* 4. Bọc AdminLayout bằng ProtectedRoute */}
          <Route path="/" element={
            <ProtectedRoute>
              <AdminLayout />
            </ProtectedRoute>
          }>
            {/* TỔNG QUAN */}
            <Route index element={<Dashboard />} />
            <Route path='reports' element={<Reports />} />

            {/* NGƯỜI DÙNG */}
            <Route path="students" element={<StudentManagement />} />
            <Route path="roles" element={<RolesManagement />} />

            {/* HỌC TẬP */}
            <Route path="learning" element={<LearningManagement />} />
            <Route path="exams" element={<ExamManagement />} />
            <Route path="content" element={<ContentManagement />} />
            <Route path="flashcards" element={<Flashcards />} />

            {/* VẬN HÀNH AI */}
            <Route path="ai-ops" element={<AIOps />} />
            <Route path="ai-logs" element={<AIOperations />} />

            {/* CỘNG ĐỒNG */}
            <Route path="virtual-rooms" element={<VirtualRooms />} />
            <Route path="leaderboard" element={<LeaderboardPage />} />
            <Route path="notifications" element={<NotificationsPage />} />

            {/* TÀI CHÍNH */}
            <Route path="pricing-plans" element={<PricingPlansPage />} />
            <Route path="transactions" element={<TransactionsPage />} />
            <Route path="settings" element={<Settings />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}