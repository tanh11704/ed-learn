class MockAssessmentData {
  // Mock Universities Data
  static final List<Map<String, dynamic>> universities = [
    {
      'id': '1',
      'name': 'Đại học Bách Khoa Hà Nội',
      'shortName': 'BKHN',
      'logo': 'https://via.placeholder.com/100',
      'location': 'Hà Nội',
      'ranking': 1,
    },
    {
      'id': '2',
      'name': 'Đại học Quốc gia Hà Nội',
      'shortName': 'QGHà Nội',
      'logo': 'https://via.placeholder.com/100',
      'location': 'Hà Nội',
      'ranking': 2,
    },
    {
      'id': '3',
      'name': 'Đại học Sư phạm Hà Nội',
      'shortName': 'ĐHSP',
      'logo': 'https://via.placeholder.com/100',
      'location': 'Hà Nội',
      'ranking': 3,
    },
  ];

  // Mock Courses Data
  static final List<Map<String, dynamic>> courses = [
    {
      'id': 'course1',
      'name': 'Toán 12',
      'description': 'Ôn tập Toán lớp 12',
      'lessons': 20,
      'progress': 45,
      'icon': '📐',
    },
    {
      'id': 'course2',
      'name': 'Vật lý 12',
      'description': 'Ôn tập Vật lý lớp 12',
      'lessons': 18,
      'progress': 60,
      'icon': '⚛️',
    },
    {
      'id': 'course3',
      'name': 'Hóa học 12',
      'description': 'Ôn tập Hóa học lớp 12',
      'lessons': 15,
      'progress': 30,
      'icon': '🧪',
    },
  ];

  // Mock Questions Data
  static final List<Map<String, dynamic>> questions = [
    {
      'id': 'q1',
      'courseId': 'course1',
      'content': '2x + 5 = 15, giá trị của x là?',
      'options': ['A. 5', 'B. 10', 'C. 15', 'D. 20'],
      'correctAnswer': 'A',
      'explanation': 'Giải: 2x = 15 - 5 = 10, nên x = 5',
      'difficulty': 'easy',
    },
    {
      'id': 'q2',
      'courseId': 'course1',
      'content': 'Tính giới hạn lim(x→2) (x² - 4)/(x - 2)',
      'options': ['A. 0', 'B. 2', 'C. 4', 'D. ∞'],
      'correctAnswer': 'C',
      'explanation': 'Phân tích: x² - 4 = (x-2)(x+2), nên giới hạn = x + 2 = 4',
      'difficulty': 'medium',
    },
    {
      'id': 'q3',
      'courseId': 'course2',
      'content': 'Công thức tính vận tốc là?',
      'options': ['A. v = s/t', 'B. v = s*t', 'C. v = t/s', 'D. v = s²/t'],
      'correctAnswer': 'A',
      'explanation': 'Vận tốc = quãng đường / thời gian',
      'difficulty': 'easy',
    },
    {
      'id': 'q4',
      'courseId': 'course3',
      'content': 'Phân tử nước (H₂O) có bao nhiêu nguyên tử?',
      'options': ['A. 1', 'B. 2', 'C. 3', 'D. 4'],
      'correctAnswer': 'C',
      'explanation': 'H₂O gồm 2 nguyên tử Hydrogen + 1 nguyên tử Oxygen = 3 nguyên tử',
      'difficulty': 'easy',
    },
  ];

  // Mock Exams Data
  static final List<Map<String, dynamic>> mockExams = [
    {
      'id': 'exam1',
      'name': 'Đề thi thử THPT Quốc gia 2024',
      'description': 'Đề thi thử năm 2024 khối A00',
      'totalQuestions': 50,
      'duration': 180, // phút
      'subject': 'Toán - Lý - Hóa',
      'status': 'completed',
      'score': 85,
      'maxScore': 100,
      'completedAt': '2024-03-28',
    },
    {
      'id': 'exam2',
      'name': 'Đề thi thử THPT Quốc gia 2023',
      'description': 'Đề thi thử năm 2023 khối D01',
      'totalQuestions': 50,
      'duration': 180,
      'subject': 'Toán - Hóa - Sinh',
      'status': 'completed',
      'score': 72,
      'maxScore': 100,
      'completedAt': '2024-03-20',
    },
    {
      'id': 'exam3',
      'name': 'Đề luyện tập Toán nâng cao',
      'description': 'Bộ đề luyện tập Toán khó',
      'totalQuestions': 30,
      'duration': 90,
      'subject': 'Toán',
      'status': 'not_started',
      'score': 0,
      'maxScore': 100,
      'completedAt': null,
    },
  ];
}
