const students = [
  {
    id: 'stu-001',
    fullName: 'Nguyễn Minh Anh',
    email: 'minhanh@gmail.com',
    role: 'STUDENT',
    status: 'ACTIVE',
    joinedAt: '2026-05-01',
    enrolledCourses: 2,
    completedLessons: 18,
  },
  {
    id: 'stu-002',
    fullName: 'Trần Quốc Bảo',
    email: 'quocbao@gmail.com',
    role: 'STUDENT',
    status: 'ACTIVE',
    joinedAt: '2026-05-08',
    enrolledCourses: 1,
    completedLessons: 6,
  },
  {
    id: 'stu-003',
    fullName: 'Lê Hà Vy',
    email: 'havy@gmail.com',
    role: 'STUDENT',
    status: 'LOCKED',
    joinedAt: '2026-04-20',
    enrolledCourses: 3,
    completedLessons: 25,
  },
];

const courseProgress = [
  {
    id: 'enr-001',
    studentName: 'Nguyễn Minh Anh',
    email: 'minhanh@gmail.com',
    courseTitle: 'Toán lớp 12 – Chinh phục kỳ thi THPT Quốc Gia',
    progressPercent: 72,
    completedLessons: 18,
    totalLessons: 25,
    lastActivity: '2026-05-18',
    status: 'Đang học',
  },
  {
    id: 'enr-002',
    studentName: 'Trần Quốc Bảo',
    email: 'quocbao@gmail.com',
    courseTitle: 'Khoá học làm giàu',
    progressPercent: 30,
    completedLessons: 6,
    totalLessons: 20,
    lastActivity: '2026-05-16',
    status: 'Đang học',
  },
  {
    id: 'enr-003',
    studentName: 'Lê Hà Vy',
    email: 'havy@gmail.com',
    courseTitle: 'Toán lớp 12 – Chinh phục kỳ thi THPT Quốc Gia',
    progressPercent: 100,
    completedLessons: 25,
    totalLessons: 25,
    lastActivity: '2026-05-12',
    status: 'Hoàn thành',
  },
];

const errorBank = [
  {
    id: 'err-001',
    studentName: 'Nguyễn Minh Anh',
    subject: 'Toán học',
    question: 'Tìm giá trị lớn nhất của hàm số trên đoạn [-2; 2].',
    wrongCount: 3,
    dueAt: '2026-05-19',
    lastQuality: 2,
    status: 'Đến hạn ôn',
  },
  {
    id: 'err-002',
    studentName: 'Trần Quốc Bảo',
    subject: 'Hình học',
    question: 'Xác định mặt phẳng vuông góc trong hình chóp S.ABCD.',
    wrongCount: 2,
    dueAt: '2026-05-21',
    lastQuality: 3,
    status: 'Sắp đến hạn',
  },
];

const streakTasks = [
  {
    id: 'stk-001',
    studentName: 'Nguyễn Minh Anh',
    currentStreak: 8,
    longestStreak: 14,
    freezeCount: 1,
    tasksDoneToday: 3,
    tasksTotalToday: 4,
    lastActiveDate: '2026-05-19',
  },
  {
    id: 'stk-002',
    studentName: 'Trần Quốc Bảo',
    currentStreak: 2,
    longestStreak: 5,
    freezeCount: 0,
    tasksDoneToday: 1,
    tasksTotalToday: 3,
    lastActiveDate: '2026-05-18',
  },
];

const awardedBadges = [
  {
    id: 'ub-001',
    studentName: 'Nguyễn Minh Anh',
    badgeName: 'Cú đêm',
    badgeCode: 'NIGHT_OWL',
    imageUrl: '',
    xpReward: 10,
    earnedAt: '2026-05-14',
  },
  {
    id: 'ub-002',
    studentName: 'Lê Hà Vy',
    badgeName: 'Chuỗi 7 ngày',
    badgeCode: 'STREAK_7',
    imageUrl: '',
    xpReward: 25,
    earnedAt: '2026-05-12',
  },
];

const examSessions = [
  {
    id: 'sess-001',
    studentName: 'Nguyễn Minh Anh',
    examTitle: 'Đề thi thử THPT Quốc Gia số 1',
    score: 8.2,
    correctAnswers: 41,
    totalQuestions: 50,
    status: 'Đã nộp',
    submittedAt: '2026-05-18 20:15',
  },
  {
    id: 'sess-002',
    studentName: 'Trần Quốc Bảo',
    examTitle: 'Đề kiểm tra hàm số',
    score: 6.5,
    correctAnswers: 26,
    totalQuestions: 40,
    status: 'Đã nộp',
    submittedAt: '2026-05-17 19:40',
  },
];

const assessments = [
  {
    id: 'asm-001',
    studentName: 'Nguyễn Minh Anh',
    targetUniversity: 'Đại học Bách khoa Hà Nội',
    targetScore: 27,
    currentLevel: 'Khá',
    studyDays: 'Thứ 2, Thứ 4, Thứ 6',
    completedAt: '2026-05-03',
  },
  {
    id: 'asm-002',
    studentName: 'Trần Quốc Bảo',
    targetUniversity: 'Đại học Kinh tế Quốc dân',
    targetScore: 25,
    currentLevel: 'Trung bình khá',
    studyDays: 'Thứ 3, Thứ 5, Chủ nhật',
    completedAt: '2026-05-09',
  },
];

const aiSolverLogs = [
  {
    id: 'ai-001',
    studentName: 'Nguyễn Minh Anh',
    topic: 'Giải phương trình logarit',
    source: 'Chụp ảnh bài toán',
    status: 'Đã giải',
    savedToNotebook: true,
    createdAt: '2026-05-18 21:10',
  },
  {
    id: 'ai-002',
    studentName: 'Trần Quốc Bảo',
    topic: 'Tư vấn cách làm bài hình học',
    source: 'Chat AI tutor',
    status: 'Đã phản hồi',
    savedToNotebook: false,
    createdAt: '2026-05-17 22:05',
  },
];

function delay(data) {
  return new Promise((resolve) => {
    window.setTimeout(() => resolve(structuredClone(data)), 180);
  });
}

export function getMockStudents() {
  return delay(students);
}

export function updateMockStudentStatus(id, status) {
  const student = students.find((item) => item.id === id);
  if (student) student.status = status;
  return delay(student);
}

export function getMockCourseProgress() {
  return delay(courseProgress);
}

export function getMockErrorBank() {
  return delay(errorBank);
}

export function getMockStreakTasks() {
  return delay(streakTasks);
}

export function getMockAwardedBadges() {
  return delay(awardedBadges);
}

export function awardMockBadge(body) {
  const item = {
    id: `ub-${Date.now()}`,
    earnedAt: new Date().toISOString().slice(0, 10),
    ...body,
  };
  awardedBadges.unshift(item);
  return delay(item);
}

export function revokeMockBadge(id) {
  const index = awardedBadges.findIndex((item) => item.id === id);
  if (index >= 0) awardedBadges.splice(index, 1);
  return delay(null);
}

export function getMockExamSessions() {
  return delay(examSessions);
}

export function getMockAssessments() {
  return delay(assessments);
}

export function getMockAiSolverLogs() {
  return delay(aiSolverLogs);
}
