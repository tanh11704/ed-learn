import 'package:flutter/material.dart';
import 'package:mobile_app/features/mock_exam/data/model/exam.dart';
import 'package:mobile_app/features/mock_exam/data/model/subject.dart';
import 'package:mobile_app/features/mock_exam/presentation/screens/exam_waiting_room_screen.dart';

class ExamLibraryScreen extends StatefulWidget {
  const ExamLibraryScreen({super.key});

  @override
  State<ExamLibraryScreen> createState() => _ExamLibraryScreenState();
}

class _ExamLibraryScreenState extends State<ExamLibraryScreen> {
  // 1. Lưu ID môn học đang được chọn ở đây
  String _selectedSubjectId = 'all';

  // 2. Mock Data danh sách đề thi (Nên có nhiều môn để test việc lọc)
  final List<Exam> mockExams = [
    Exam(
      id: '1',
      subjectId: 'math',
      level: 'KHÓ',
      levelColor: const Color(0xFFFF6B6B),
      title: 'Đề thi thử THPT Quốc gia 2026',
      subtitle: '- Môn Toán (Lần 1)',
      time: '120 phút',
      questions: '50 câu hỏi',
      taken: '2,150 lượt thi',
    ),
    Exam(
      id: '2',
      subjectId: 'english',
      level: 'TRUNG BÌNH',
      levelColor: const Color(0xFF1CC88A),
      title: 'Kiểm tra định kỳ Tiếng Anh 12',
      subtitle: 'Unit 4: Urbanisation',
      time: '45 phút',
      questions: '30 câu hỏi',
      taken: '5,541 lượt thi',
    ),
    Exam(
      id: '3',
      subjectId: 'logic',
      level: 'KHÓ',
      levelColor: const Color(0xFFFF6B6B),
      title: 'Luyện thi Đánh giá năng lực',
      subtitle: 'ĐHQG - Tư duy định tính',
      time: '120 phút',
      questions: '60 câu hỏi',
      taken: '8,120 lượt thi',
    ),
    Exam(
      id: '4',
      subjectId: 'literature',
      level: 'DỄ',
      levelColor: const Color(0xFF4E73DF),
      title: 'Tổng ôn tập Ngữ Văn',
      subtitle: 'Nghị luận xã hội',
      time: '60 phút',
      questions: '10 câu hỏi',
      taken: '2,390 lượt thi',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    //Logic lọc danh sách đề thi
    final filteredExams = _selectedSubjectId == 'all'
        ? mockExams
        : mockExams.where((e) => e.subjectId == _selectedSubjectId).toList();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Thư viện đề thi thử',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        // hành động của icon thông báo (nếu có)
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const _SearchBar(),
            const SizedBox(height: 12),
            //Truyền callback onChanged để nhận ID từ CategoryTabs
            CategoryTabs(
              onChanged: (id) {
                setState(() {
                  _selectedSubjectId = id;
                });
              },
            ),
            const SizedBox(height: 16),
            const _SectionHeader(),
            const SizedBox(height: 12),
            
            // Đổ data sau khi đã lọc
            if (filteredExams.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("Chưa có đề thi cho môn này"),
                ),
              )
            else
            // Nếu có đề thi thì hiển thị danh sách
              ...filteredExams.map((item) => _ExamCard(exam: item)),
          ],
        ),
      ),
    );
  }
}

// --- SEARCH BAR ---
class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm đề thi...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }
}

// --- CATEGORY TABS ---
class CategoryTabs extends StatefulWidget {
  final Function(String) onChanged; // Callback truyền ID ra ngoài
  const CategoryTabs({super.key, required this.onChanged});

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  // Mock data môn học, thực tế sẽ fetch từ API
  List<Subject> _subjects = [];
  String _selectedId = 'all';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(seconds: 1)); 
    if (mounted) {
      setState(() {
        _subjects = [
          Subject(id: 'all', title: 'Tất cả'),
          Subject(id: 'math', title: 'Toán học'),
          Subject(id: 'literature', title: 'Ngữ văn'),
          Subject(id: 'logic', title: 'ĐGNL'),
          Subject(id: 'english', title: 'Tiếng Anh'),
        ];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 36,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _subjects.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = _subjects[index];
          final isSelected = _selectedId == item.id;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedId = item.id);
              widget.onChanged(item.id); // Gọi callback báo cho cha
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                // Đổi màu nền và viền khi được chọn
                color: isSelected ? const Color(0xFF2E6BFF) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? const Color(0xFF2E6BFF) : const Color(0xFFE5E7EB),
                ),
              ),
              child: Text(
                item.title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- SECTION HEADER ---
class _SectionHeader extends StatelessWidget {
  const _SectionHeader();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'ĐỀ THI NỔI BẬT',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Xem tất cả',
            style: TextStyle(color: Color(0xFF2E6BFF), fontSize: 12),
          ),
        ),
      ],
    );
  }
}

// --- EXAM CARD ---
class _ExamCard extends StatelessWidget {
  final Exam exam;
  const _ExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: exam.levelColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  exam.level,
                  style: TextStyle(
                    color: exam.levelColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
              // Đẩy lượt thi ra sát bên phải
              const Spacer(),
              Text(
                exam.taken,
                style: const TextStyle(fontSize: 11, color: Colors.black45),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            exam.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 2),
          Text(
            exam.subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.black45),
              const SizedBox(width: 4),
              Text(exam.time, style: const TextStyle(fontSize: 11, color: Colors.black45)),
              const SizedBox(width: 16),
              const Icon(Icons.list_alt, size: 14, color: Colors.black45),
              const SizedBox(width: 4),
              Text(exam.questions, style: const TextStyle(fontSize: 11, color: Colors.black45)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 40,
            // Nút thi ngay 
            child: ElevatedButton(
              // xử lý sự kiện khi nhấn vào nút thi ngay
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const ExamWaitingRoomScreen()));},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E6BFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('Thi ngay', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}