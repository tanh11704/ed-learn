import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/learning_cache_service.dart';
import '../../data/datasources/learning_remote_datasource.dart';
import '../../data/models/course_models.dart';
import '../../data/repositories/learning_repository_impl.dart';
import '../widgets/path_node_item.dart';
import '../widgets/course_selection_bottom_sheet.dart';

class LearningPathScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const LearningPathScreen({
    Key? key,
    this.courseId = 'data-science',
    this.courseName = 'Data Science',
  }) : super(key: key);

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  final LearningRepositoryImpl _repository =
      LearningRepositoryImpl(LearningRemoteDataSourceImpl());
  final LearningCacheService _cacheService = LearningCacheService();
  List<_LessonItem> lessons = [];
  CourseSummary? _selectedCourse;
  bool _isLoading = true;
  String? _errorMessage;
  int _completedLessonsCount = 0;
  int _totalLessonsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<CourseSummary> myCourses = [];
      try {
        myCourses = await _repository.getMyCourses(forceRefresh: forceRefresh);
      } catch (_) {
        myCourses = [];
      }

      final publicCourses = await _repository.getCourses(
        page: 0,
        size: 12,
        forceRefresh: forceRefresh,
      );

      CourseSummary? selected = myCourses.firstWhere(
        (course) => course.id == widget.courseId,
        orElse: () => myCourses.isNotEmpty ? myCourses.first : CourseSummary(id: '', title: ''),
      );

      if (selected.id.isEmpty) {
        selected = publicCourses.firstWhere(
          (course) => course.id == widget.courseId,
          orElse: () => publicCourses.isNotEmpty ? publicCourses.first : CourseSummary(id: '', title: ''),
        );
      }

      if (selected.id.isEmpty) {
        setState(() {
          lessons = [];
          _selectedCourse = null;
          _isLoading = false;
        });
        return;
      }

      _selectedCourse = selected;
      await _loadCourseDetail(selected.id, forceRefresh: forceRefresh);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCourseDetail(String courseId, {bool forceRefresh = false}) async {
    try {
      final detail = await _repository.getCourseDetail(courseId, forceRefresh: forceRefresh);
      final completedLessonIds =
          await _cacheService.getCompletedLessonIds(courseId);
      final chapters = detail.chapters.toList()
        ..sort(_compareChaptersForPath);

      final updatedLessons = <_LessonItem>[];
      int totalLessons = 0;
      int completedLessons = 0;
      bool currentAssigned = false;

      for (final chapter in chapters) {
        final chapterLessons = chapter.lessons.toList()
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        totalLessons += chapterLessons.length;
        final completedInChapter = chapterLessons
            .where((lesson) => completedLessonIds.contains(lesson.id))
            .length;
        completedLessons += completedInChapter;

        LessonNodeStatus status;
        String? note;
        if (chapterLessons.isNotEmpty && completedInChapter == chapterLessons.length) {
          status = LessonNodeStatus.mastered;
          note = 'Hoàn thành ${chapterLessons.length}/${chapterLessons.length} bài học';
        } else if (!currentAssigned) {
          status = LessonNodeStatus.current;
          currentAssigned = true;
        } else {
          status = LessonNodeStatus.locked;
          note = 'Chưa mở khóa';
        }

        updatedLessons.add(
          _LessonItem(
            id: chapter.id,
            name: chapter.title,
            status: status,
            masteredDate: note,
          ),
        );
      }

      setState(() {
        lessons = updatedLessons;
        _completedLessonsCount = completedLessons;
        _totalLessonsCount = totalLessons;
        _selectedCourse = CourseSummary(
          id: detail.id,
          title: detail.title,
          description: detail.description,
          subject: detail.subject,
          thumbnailUrl: detail.thumbnailUrl,
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showCourseSelection() async {
    final selected = await showModalBottomSheet<CourseSummary>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) => CourseSelectionBottomSheet(
        selectedCourseId: _selectedCourse?.id,
      ),
    );

    if (selected != null && selected.id != _selectedCourse?.id) {
      setState(() {
        _selectedCourse = selected;
        _isLoading = true;
        _errorMessage = null;
      });
      await _loadCourseDetail(selected.id);
    }
  }

  int _compareChaptersForPath(ChapterDetail left, ChapterDetail right) {
    final leftChapterNumber = _chapterNumberFromTitle(left.title);
    final rightChapterNumber = _chapterNumberFromTitle(right.title);

    if (leftChapterNumber != null && rightChapterNumber != null) {
      final byChapterNumber = leftChapterNumber.compareTo(rightChapterNumber);
      if (byChapterNumber != 0) return byChapterNumber;
    }

    final byOrderIndex = left.orderIndex.compareTo(right.orderIndex);
    if (byOrderIndex != 0) return byOrderIndex;

    return left.title.compareTo(right.title);
  }

  int? _chapterNumberFromTitle(String title) {
    final match = RegExp(
      r'(?:chuong|chương|chapter)\s*(\d+)',
      caseSensitive: false,
    ).firstMatch(title);
    return match == null ? null : int.tryParse(match.group(1)!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Lỗi: $_errorMessage'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _loadInitialData(forceRefresh: true),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () => _loadInitialData(forceRefresh: true),
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 120),
                        children: [
                          _buildProgressCard(),
                          _buildTimeline(),
                        ],
                      ),
                    ),
                    if (lessons.isNotEmpty)
                      Positioned(
                        bottom: 24,
                        left: 16,
                        right: 16,
                        child: _buildNextUpCard(),
                      ),
                  ],
                ),
    );
  }

  // ==================== APP BAR ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0, // Chống đổi màu nền khi cuộn trên Material 3
      titleSpacing: 0,
      leading: Center(
        child: InkWell(
          onTap: _showCourseSelection,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF), // Nền xanh nhạt cho nút menu
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.menu, color: Color(0xFF2563EB), size: 20),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedCourse?.title ?? widget.courseName,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Text(
            'Intermediate Level',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF), // Xanh nhạt
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.star, color: Color(0xFF2563EB), size: 14),
                SizedBox(width: 4),
                Text(
                  '2,450 XP',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== PROGRESS CARD ====================
  Widget _buildProgressCard() {
    if (lessons.isEmpty) {
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        ),
        child: const Text(
          'Chưa có nội dung học tập cho khóa học này.',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
        ),
      );
    }

  int completedCount = _completedLessonsCount;
  int totalCount = _totalLessonsCount;
  double progress = totalCount == 0 ? 0 : completedCount / totalCount;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'OVERALL PROGRESS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                '$completedCount/$totalCount Lessons',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== TIMELINE ====================
  Widget _buildTimeline() {
    if (lessons.isEmpty) {
      return const SizedBox.shrink();
    }
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Đường dọc mờ chạy giữa timeline
        Positioned(
          top: 40,
          bottom: 40,
          child: Container(
            width: 2,
            color: const Color(0xFFE2E8F0),
          ),
        ),
        
        // Danh sách các node
        Column(
          children: List.generate(lessons.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 48), // Khoảng cách giữa các node
              child: _buildTimelineNode(lessons[index], index),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTimelineNode(_LessonItem lesson, int index) {
    // Xử lý node Mastered (Hoàn thành) - Zíc zắc trái/phải
    if (lesson.status == LessonNodeStatus.mastered) {
      bool isLeft = index % 2 == 0;
      
      Widget nodeCircle = Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A), // Màu xanh đen sậm
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 28),
      );

      Widget textContent = Column(
        crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            lesson.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            lesson.masteredDate ?? '',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: isLeft 
            ? [
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                nodeCircle, 
                const SizedBox(width: 16), 
                textContent,
              ]
            : [
                textContent, 
                const SizedBox(width: 16), 
                nodeCircle,
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              ],
        ),
      );
    } 
    // Xử lý node Current (Đang học) - Chính giữa, to và phát sáng
    else if (lesson.status == LessonNodeStatus.current) {
      return GestureDetector(
        onTap: () {
          context.push(
            '/learning/module-detail',
            extra: {
              'moduleId': lesson.id,
              'moduleName': lesson.name,
              'courseId': _selectedCourse?.id,
            },
          );
        },
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.3),
                    blurRadius: 24,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.rocket_launch, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              lesson.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2563EB), // Chữ màu xanh giống viền
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'CURRENT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      );
    } 
    // Xử lý node Locked (Khóa) - Chính giữa, màu xám
    else {
      return Opacity(
        opacity: 0.5,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9), // Xám nhạt
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
              ),
              child: const Icon(Icons.lock_outline, color: Color(0xFF94A3B8), size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              lesson.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lesson.masteredDate ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
  }

  // ==================== NEXT UP CARD ====================
  Widget _buildNextUpCard() {
    if (lessons.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Play Icon Circle
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded, color: Color(0xFF2563EB), size: 28),
          ),
          const SizedBox(width: 16),
          
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'NEXT UP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lessons
                      .firstWhere(
                        (l) => l.status == LessonNodeStatus.current,
                        orElse: () => lessons.first,
                      )
                      .name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          
          // Start Button
          ElevatedButton(
            onPressed: () {
              final currentLesson = lessons.firstWhere(
                (l) => l.status == LessonNodeStatus.current,
                orElse: () => lessons.first,
              );

              context.push(
                '/learning/module-detail',
                extra: {
                  'moduleId': currentLesson.id,
                  'moduleName': currentLesson.name,
                  'courseId': _selectedCourse?.id,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'START',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class _LessonItem {
  final String id;
  final String name;
  final LessonNodeStatus status;
  final String? masteredDate;

  _LessonItem({
    required this.id,
    required this.name,
    required this.status,
    this.masteredDate,
  });
}
