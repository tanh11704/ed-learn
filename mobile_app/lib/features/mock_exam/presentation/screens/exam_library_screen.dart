import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/mock_exam/data/model/exam.dart';
import 'package:mobile_app/features/mock_exam/data/model/subject.dart';
import 'package:mobile_app/features/mock_exam/data/models/exam_session_args.dart';
import 'package:mobile_app/features/mock_exam/data/repositories/exam_repository_impl.dart';

class ExamLibraryScreen extends StatefulWidget {
  const ExamLibraryScreen({super.key});

  @override
  State<ExamLibraryScreen> createState() => _ExamLibraryScreenState();
}

class _ExamLibraryScreenState extends State<ExamLibraryScreen> {
  final _repository = ExamRepositoryImpl();

  String _selectedSubjectId = 'all';
  List<Exam> _exams = [];
  List<Subject> _subjects = [Subject(id: 'all', title: 'Tất cả')];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  Future<void> _loadExams() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiExams = await _repository.getAvailableExams();
      final exams = apiExams.map(Exam.fromApi).toList();
      final subjectMap = <String, String>{};
      for (final exam in exams) {
        subjectMap[exam.subjectId] = _labelFromSubjectKey(exam.subjectId);
      }

      if (!mounted) return;
      setState(() {
        _exams = exams;
        _subjects = [
          Subject(id: 'all', title: 'Tất cả'),
          ...subjectMap.entries.map((e) => Subject(id: e.key, title: e.value)),
        ];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _exams = [];
        _subjects = [Subject(id: 'all', title: 'Tất cả')];
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  String _labelFromSubjectKey(String key) {
    return key
        .split('_')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final filteredExams = _selectedSubjectId == 'all'
        ? _exams
        : _exams.where((e) => e.subjectId == _selectedSubjectId).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Thư viện đề thi thử',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadExams,
            icon: const Icon(Icons.refresh, color: Colors.black54),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadExams,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    const _SearchBar(),
                    const SizedBox(height: 12),
                    CategoryTabs(
                      subjects: _subjects,
                      selectedId: _selectedSubjectId,
                      onChanged: (id) {
                        setState(() => _selectedSubjectId = id);
                      },
                    ),
                    const SizedBox(height: 16),
                    const _SectionHeader(),
                    const SizedBox(height: 12),
                    if (filteredExams.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('Chưa có đề thi được phát hành'),
                        ),
                      )
                    else
                      ...filteredExams.map((item) => _ExamCard(exam: item)),
                  ],
                ),
              ),
      ),
    );
  }
}

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

class CategoryTabs extends StatelessWidget {
  final List<Subject> subjects;
  final String selectedId;
  final ValueChanged<String> onChanged;

  const CategoryTabs({
    super.key,
    required this.subjects,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: subjects.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = subjects[index];
          final isSelected = selectedId == item.id;

          return GestureDetector(
            onTap: () => onChanged(item.id),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2E6BFF) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2E6BFF)
                      : const Color(0xFFE5E7EB),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'ĐỀ THI ĐÃ PHÁT HÀNH',
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
    );
  }
}

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
            color: Colors.black.withValues(alpha: 0.02),
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
                  color: exam.levelColor.withValues(alpha: 0.1),
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
              Text(
                exam.time,
                style: const TextStyle(fontSize: 11, color: Colors.black45),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.list_alt, size: 14, color: Colors.black45),
              const SizedBox(width: 4),
              Text(
                exam.questions,
                style: const TextStyle(fontSize: 11, color: Colors.black45),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                context.push(
                  '/exam/exam-waiting-room',
                  extra: ExamSessionArgs(
                    examId: exam.id,
                    examTitle: exam.title,
                    durationMinutes: exam.durationMinutes,
                    gradeLevel: 12,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E6BFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Thi ngay',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
