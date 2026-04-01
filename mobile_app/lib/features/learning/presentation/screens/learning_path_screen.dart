import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Reuse the enum and widget from widgets folder so there's a single source of truth
import '../widgets/path_node_item.dart';
// Note: Bạn có thể bỏ comment dòng dưới nếu vẫn muốn dùng bottom sheet cũ của bạn
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
  late List<_LessonItem> lessons;

  @override
  void initState() {
    super.initState();
    _initializeLessons();
  }

  void _initializeLessons() {
    lessons = [
      _LessonItem(
        id: '1',
        name: 'Python Basics',
        status: LessonNodeStatus.mastered,
        masteredDate: 'Mastered on Oct 12',
      ),
      _LessonItem(
        id: '2',
        name: 'Data Structures',
        status: LessonNodeStatus.mastered,
        masteredDate: 'Mastered on Oct 24',
      ),
      _LessonItem(
        id: '3',
        name: 'Pandas Analysis',
        status: LessonNodeStatus.current,
      ),
      _LessonItem(
        id: '4',
        name: 'Visualization',
        status: LessonNodeStatus.locked,
        masteredDate: 'Unlocks at Level 15',
      ),
      _LessonItem(
        id: '5',
        name: 'Machine Learning',
        status: LessonNodeStatus.locked,
        masteredDate: 'Unlocks at Level 20',
      ),
    ];
  }

  void _showCourseSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) => const CourseSelectionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Nền xám rất nhạt giống thiết kế
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Nội dung chính có thể cuộn
          ListView(
            padding: const EdgeInsets.only(bottom: 120), // Để khoảng trống cho NextUp Card
            children: [
              _buildProgressCard(),
              _buildTimeline(),
            ],
          ),
          
          // Thẻ Next Up nổi ở dưới
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
            widget.courseName,
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
    int completedCount = lessons.where((l) => l.status == LessonNodeStatus.mastered).length;
    double progress = completedCount / lessons.length;

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
                '$completedCount/${lessons.length} Lessons',
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
          // Navigate to module detail screen when clicking current lesson node
          context.push(
            '/learning/module-detail',
            extra: {
              'moduleId': lesson.id,
              'moduleName': lesson.name,
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
                  'Intro to Dataframes', // Hardcode theo UI mockup hoặc dùng currentLesson.name
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
              // Lấy bài học current
              final currentLesson = lessons.firstWhere(
                (l) => l.status == LessonNodeStatus.current,
                orElse: () => lessons.first,
              );
              
              // Navigate trực tiếp tới lesson play screen (bỏ qua module detail)
              context.push(
                '/learning/lesson-play',
                extra: {
                  'lessonId': currentLesson.id,
                  'lessonName': currentLesson.name,
                  'moduleName': 'Pandas Analysis',
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