import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext.jsx';
import ProtectedRoute from './components/ProtectedRoute.jsx';
import Layout from './components/Layout.jsx';
import AiSolverAdminPage from './pages/AiSolverAdminPage.jsx';
import AssessmentAdminPage from './pages/AssessmentAdminPage.jsx';
import LoginPage from './pages/LoginPage.jsx';
import DashboardPage from './pages/DashboardPage.jsx';
import CoursesPage from './pages/CoursesPage.jsx';
import CourseDetailPage from './pages/CourseDetailPage.jsx';
import CoursePreviewPage from './pages/CoursePreviewPage.jsx';
import BadgesPage from './pages/BadgesPage.jsx';
import CourseProgressPage from './pages/CourseProgressPage.jsx';
import ErrorBankAdminPage from './pages/ErrorBankAdminPage.jsx';
import ExamsPage from './pages/ExamsPage.jsx';
import ExamDetailPage from './pages/ExamDetailPage.jsx';
import ExamPreviewPage from './pages/ExamPreviewPage.jsx';
import ExamSessionsPage from './pages/ExamSessionsPage.jsx';
import StreakTasksPage from './pages/StreakTasksPage.jsx';
import UserBadgesPage from './pages/UserBadgesPage.jsx';
import UsersPage from './pages/UsersPage.jsx';
import './admin.css';

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route
            path="/"
            element={
              <ProtectedRoute>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route index element={<DashboardPage />} />
            <Route path="courses" element={<CoursesPage />} />
            <Route path="courses/:id" element={<CoursePreviewPage />} />
            <Route path="courses/:id/manage" element={<CourseDetailPage />} />
            <Route path="badges" element={<BadgesPage />} />
            <Route path="user-badges" element={<UserBadgesPage />} />
            <Route path="exams" element={<ExamsPage />} />
            <Route path="exams/:id" element={<ExamPreviewPage />} />
            <Route path="exams/:id/manage" element={<ExamDetailPage />} />
            <Route path="exam-sessions" element={<ExamSessionsPage />} />
            <Route path="users" element={<UsersPage />} />
            <Route path="course-progress" element={<CourseProgressPage />} />
            <Route path="error-bank" element={<ErrorBankAdminPage />} />
            <Route path="streak-tasks" element={<StreakTasksPage />} />
            <Route path="assessment" element={<AssessmentAdminPage />} />
            <Route path="ai-solver" element={<AiSolverAdminPage />} />
          </Route>
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}
