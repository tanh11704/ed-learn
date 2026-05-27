import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/learning_cache_service.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../data/datasources/learning_remote_datasource.dart';
import '../../data/models/course_models.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/learning_repository_impl.dart';

class ModuleDetailScreen extends StatefulWidget {
  final String moduleId;
  final String moduleName;
  final String? courseId;

  const ModuleDetailScreen({
    Key? key,
    this.moduleId = 'pandas-analysis',
    this.moduleName = 'Pandas Analysis',
    this.courseId,
  }) : super(key: key);

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  final LearningRepositoryImpl _repository =
      LearningRepositoryImpl(LearningRemoteDataSourceImpl());
  final LearningCacheService _cacheService = LearningCacheService();
  List<Lesson> lessons = [];
  bool _isLoading = true;
  String? _errorMessage;
  ChapterDetail? _chapter;

  static const _generatedFlashcardSuffix = '-generated-flashcard';
  static const _generatedExerciseSuffix = '-generated-exercise';

  @override
  void initState() {
    super.initState();
    _loadChapterDetail();
  }

  Future<void> _loadChapterDetail({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (widget.courseId == null || widget.courseId!.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Thiếu thông tin khóa học.';
      });
      return;
    }

    try {
      final detail = await _repository.getCourseDetail(
        widget.courseId!,
        forceRefresh: forceRefresh,
      );
      final completedLessonIds =
          await _cacheService.getCompletedLessonIds(widget.courseId!);
      final chapter = detail.chapters.firstWhere(
        (item) => item.id == widget.moduleId,
        orElse: () => detail.chapters.isNotEmpty ? detail.chapters.first : ChapterDetail(
          id: '',
          courseId: widget.courseId!,
          title: widget.moduleName,
          orderIndex: 0,
          lessons: [],
        ),
      );

      final tokenStorage = TokenStorageService();
      final accessToken = await tokenStorage.getAccessToken();
      final canAccessAll = accessToken != null;

      final mappedLessons = chapter.lessons
          .map(
            (lesson) {
              final isCompleted = completedLessonIds.contains(lesson.id);
              final isAccessible = lesson.isPreview || canAccessAll;
              final status = isCompleted
                  ? LessonStatus.completed
                  : isAccessible
                      ? LessonStatus.available
                      : LessonStatus.locked;
              return Lesson(
                id: lesson.id,
                name: lesson.title,
                title: lesson.title,
                duration: '0 phút',
                status: status,
                type: _inferLessonType(lesson.title),
                videoUrl: lesson.videoUrl,
                description: lesson.description,
              );
            },
          )
          .toList();

      final hasFlashcard =
          mappedLessons.any((lesson) => lesson.type == LessonType.flashcard);
      final hasExercise =
          mappedLessons.any((lesson) => lesson.type == LessonType.exercise);
      final fallbackStatus =
          canAccessAll || chapter.lessons.any((lesson) => lesson.isPreview)
              ? LessonStatus.available
              : LessonStatus.locked;

      if (!hasFlashcard) {
        mappedLessons.add(
          Lesson(
            id: '${chapter.id}$_generatedFlashcardSuffix',
            name: 'Flashcard ${chapter.title}',
            title: 'Flashcard ${chapter.title}',
            duration: 'Ôn tập nhanh',
            status: fallbackStatus,
            type: LessonType.flashcard,
          ),
        );
      }

      if (!hasExercise) {
        mappedLessons.add(
          Lesson(
            id: '${chapter.id}$_generatedExerciseSuffix',
            name: 'Bài tập ${chapter.title}',
            title: 'Bài tập ${chapter.title}',
            duration: 'Luyện tập',
            status: fallbackStatus,
            type: LessonType.exercise,
          ),
        );
      }

      setState(() {
        _chapter = chapter;
        lessons = mappedLessons;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  LessonType _inferLessonType(String title) {
    final normalized = title.toLowerCase();
    if (normalized.contains('flashcard') ||
        normalized.contains('flash card') ||
        normalized.contains('thẻ')) {
      return LessonType.flashcard;
    }
    if (normalized.contains('exercise') ||
        normalized.contains('bài tập') ||
        normalized.contains('luyện tập') ||
        normalized.contains('quiz') ||
        normalized.contains('kiểm tra')) {
      return LessonType.exercise;
    }
    return LessonType.video;
  }

  Color _lessonAccentColor(Lesson lesson) {
    if (lesson.isExercise) return Colors.orange;
    if (lesson.isFlashcard) return Colors.purple;
    return const Color(0xFF2563EB);
  }

  Color _lessonBackgroundColor(Lesson lesson) {
    if (lesson.isExercise) return Colors.orange.shade50;
    if (lesson.isFlashcard) return Colors.purple.shade50;
    return Colors.blue.shade50;
  }

  IconData _lessonIcon(Lesson lesson) {
    if (lesson.isExercise) return Icons.assignment_outlined;
    if (lesson.isFlashcard) return Icons.style_outlined;
    return Icons.play_circle_outline;
  }

  String _lessonTypeLabel(Lesson lesson) {
    if (lesson.isExercise) return 'EXERCISE';
    if (lesson.isFlashcard) return 'FLASHCARD';
    return 'VIDEO';
  }

  bool _isGeneratedLesson(Lesson lesson) {
    return lesson.id.endsWith(_generatedFlashcardSuffix) ||
        lesson.id.endsWith(_generatedExerciseSuffix);
  }

  @override
  Widget build(BuildContext context) {
    final progressLessons =
        lessons.where((lesson) => !_isGeneratedLesson(lesson)).toList();
    int completedCount = progressLessons
        .where((lesson) => lesson.status == LessonStatus.completed)
        .length;
    double progress = progressLessons.isEmpty
        ? 0
        : (completedCount / progressLessons.length) * 100;
    final activeIndex = lessons.indexWhere((lesson) => lesson.isAvailable);

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                        onPressed: () => _loadChapterDetail(forceRefresh: true),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => _loadChapterDetail(forceRefresh: true),
                  child: CustomScrollView(
                    slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      pinned: true,
                      titleSpacing: 0,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _chapter?.title ?? widget.moduleName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Tài liệu dạy + ${lessons.length} bài học',
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
                              '$completedCount/${progressLessons.length} bài học hoàn thành',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

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
                                final isActive = index == activeIndex;
                                final accentColor = _lessonAccentColor(lesson);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  child: GestureDetector(
                                    onTap: isLocked
                                        ? null
                                        : () {
                                            if (lesson.isExercise) {
                                              context.push(
                                                '/learning/quiz-start',
                                                extra: {
                                                  'quizName': lesson.name,
                                                  'moduleName': _chapter?.title ?? widget.moduleName,
                                                },
                                              );
                                            } else if (lesson.isFlashcard) {
                                              context.push(
                                                '/learning/flashcard-start',
                                                extra: {
                                                  'lessonId': lesson.id,
                                                  'moduleName': _chapter?.title ?? widget.moduleName,
                                                },
                                              );
                                            } else {
                                              context.push(
                                                '/learning/lesson-play',
                                                extra: {
                                                  'lessonId': lesson.id,
                                                  'lessonName': lesson.name,
                                                  'moduleName': _chapter?.title ?? widget.moduleName,
                                                  'courseId': widget.courseId,
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
                                          color: isActive
                                              ? const Color(0xFF2563EB)
                                              : Colors.grey[200]!,
                                          width: isActive ? 2 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: isCompleted
                                                  ? Colors.green[50]
                                                  : isLocked
                                                      ? Colors.grey[200]
                                                      : _lessonBackgroundColor(lesson),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                isCompleted
                                                    ? Icons.check_circle
                                                    : isLocked
                                                        ? Icons.lock
                                                        : _lessonIcon(lesson),
                                                color: isCompleted
                                                    ? Colors.green
                                                    : isLocked
                                                        ? Colors.grey
                                                        : accentColor,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '${index + 1}. ${lesson.name}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          color: isLocked
                                                              ? Colors.grey[400]
                                                              : Colors.black,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
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
                                                if (lesson.progress != null &&
                                                    lesson.progress!.isNotEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 6),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(2),
                                                      child: SizedBox(
                                                        height: 4,
                                                        width: 60,
                                                        child: LinearProgressIndicator(
                                                          value: double.tryParse(
                                                                lesson.progress!
                                                                    .replaceAll('%', ''),
                                                              ) ??
                                                              0 / 100,
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
                                              _lessonTypeLabel(lesson),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: lesson.isExercise
                                                    ? Colors.orange
                                                    : lesson.isFlashcard
                                                        ? Colors.purple
                                                        : accentColor,
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
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],
                  ),
                ),
    );
  }
}
