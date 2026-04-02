import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/lesson_model.dart';

class ModuleDetailScreen extends StatefulWidget {
  final String moduleId;
  final String moduleName;

  const ModuleDetailScreen({
    Key? key,
    this.moduleId = 'pandas-analysis',
    this.moduleName = 'Pandas Analysis',
  }) : super(key: key);

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  // Mock data - Thay bằng API later
  late List<Lesson> lessons;

  @override
  void initState() {
    super.initState();
    _initializeLessons();
  }

  void _initializeLessons() {
    lessons = [
      Lesson(
        id: '1',
        name: 'Giới thiệu về Pandas',
        duration: '12 phút',
        status: LessonStatus.completed,
        progress: '100%',
        type: LessonType.video,
      ),
      Lesson(
        id: '2',
        name: 'Cấu trúc dữ liệu Pandas',
        duration: '18 phút',
        status: LessonStatus.available,
        progress: '30%',
        type: LessonType.video,
      ),
      Lesson(
        id: '3',
        name: 'Lọc và chọn dữ liệu',
        duration: '22 phút',
        status: LessonStatus.available,
        type: LessonType.video,
      ),
      Lesson(
        id: '4',
        name: 'Xử lý dữ liệu thiếu',
        duration: '15 phút',
        status: LessonStatus.available,
        type: LessonType.video,
      ),
      Lesson(
        id: '5',
        name: 'Phân tích thống kê cơ bản',
        duration: '28 phút',
        status: LessonStatus.available,
        type: LessonType.video,
      ),
      Lesson(
        id: '6',
        name: 'Ôn tập kiến thức',
        duration: '20 phút',
        status: LessonStatus.available,
        type: LessonType.flashcard,
      ),
      Lesson(
        id: '7',
        name: 'Ôn tập kiến thức 2',
        duration: '25 phút',
        status: LessonStatus.available,
        type: LessonType.flashcard,
      ),
      Lesson(
        id: '8',
        name: 'Bài tập rèn luyện lọc dữ liệu',
        duration: '30 phút',
        status: LessonStatus.available,
        type: LessonType.exercise,
      ),
      Lesson(
        id: '9',
        name: 'Kiểm tra đánh giá chương',
        duration: '45 phút',
        status: LessonStatus.locked,
        type: LessonType.exercise,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = lessons.where((l) => l.status == LessonStatus.completed).length;
    double progress = (completedCount / lessons.length) * 100;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.moduleName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Tài liệu dạy + 05 bài học',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Module progress section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tiến độ học quán',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${progress.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      minHeight: 6,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF2563EB),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$completedCount/${lessons.length} bài học hoàn thành',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Danh sách bài học
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'DANH SÁCH BÀI HỌC',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: List.generate(lessons.length, (index) {
                      final lesson = lessons[index];
                      final isCompleted = lesson.isCompleted;
                      final isLocked = lesson.isLocked;
                      final isActive = index == 1; // 2nd lesson is active

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: GestureDetector(
                          onTap: isLocked
                              ? null
                              : () {
                                  if (lesson.isExercise) {
                                    // Navigate to quiz
                                    context.push(
                                      '/learning/quiz-start',
                                      extra: {
                                        'quizName': lesson.name,
                                        'moduleName': widget.moduleName,
                                      },
                                    );
                                  } 
                                  else if (lesson.isFlashcard) {
                                    // Navigate to flashcard
                                    context.push(
                                      '/learning/flashcard-start',
                                      extra: {
                                        'lessonId': lesson.id,
                                        'moduleName': widget.moduleName,
                                      },
                                    );
                                  }
                                  else {
                                    // Navigate to lesson play
                                    context.push(
                                      '/learning/lesson-play',
                                      extra: {
                                        'lessonId': lesson.id,
                                        'lessonName': lesson.name,
                                        'moduleName': widget.moduleName,
                                      },
                                    );
                                  }
                                },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.white : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive ? const Color(0xFF2563EB) : Colors.grey[200]!,
                                width: isActive ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Lesson icon/status
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? Colors.green[50]
                                        : isLocked
                                            ? Colors.grey[200]
                                            : Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      isCompleted
                                          ? Icons.check_circle
                                          : isLocked
                                              ? Icons.lock
                                              : Icons.play_circle_outline,
                                      color: isCompleted
                                          ? Colors.green
                                          : isLocked
                                              ? Colors.grey
                                              : const Color(0xFF2563EB),
                                      size: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Lesson info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${index + 1}. ${lesson.name}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: isLocked
                                                  ? Colors.grey[400]
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        lesson.duration,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      if (lesson.progress != null && lesson.progress!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(2),
                                            child: SizedBox(
                                              height: 4,
                                              width: 60,
                                              child: LinearProgressIndicator(
                                                value: double.tryParse(
                                                      lesson.progress!.replaceAll('%', ''),
                                                    ) ??
                                                    0 /
                                                    100,
                                                backgroundColor: Colors.grey[200],
                                                valueColor:
                                                    const AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF2563EB),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                // Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: lesson.isExercise
                                        ? Colors.orange[50]
                                        : lesson.isFlashcard
                                            ? Colors.purple[50]
                                            : Colors.blue[50],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    lesson.isExercise
                                        ? 'EXERCISE'
                                        : lesson.isFlashcard
                                            ? 'FLASHCARD'
                                            : 'VIDEO',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: lesson.isExercise
                                          ? Colors.orange
                                          : lesson.isFlashcard
                                              ? Colors.purple
                                              : const Color(0xFF2563EB),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
