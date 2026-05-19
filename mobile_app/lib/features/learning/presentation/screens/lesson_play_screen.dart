import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/learning_cache_service.dart';
import '../../data/datasources/learning_remote_datasource.dart';
import '../../data/models/course_models.dart';
import '../../data/repositories/learning_repository_impl.dart';

class LessonPlayScreen extends StatefulWidget {
  final String lessonId;
  final String lessonName;
  final String moduleName;
  final String? courseId;

  const LessonPlayScreen({
    Key? key,
    this.lessonId = '1',
    this.lessonName = 'Advanced Calculus: Partial Derivatives & Chain Rule',
    this.moduleName = 'Mathematics',
    this.courseId,
  }) : super(key: key);

  @override
  State<LessonPlayScreen> createState() => _LessonPlayScreenState();
}

class _LessonPlayScreenState extends State<LessonPlayScreen> {
  int _selectedTabIndex = 0; // 0: Theory, 1: Attachments, 2: Discussion
  final LearningRepositoryImpl _repository =
      LearningRepositoryImpl(LearningRemoteDataSourceImpl());
  final LearningCacheService _cacheService = LearningCacheService();
  bool _isLoading = true;
  String? _errorMessage;
  LessonDetail? _lessonDetail;
  bool _isCompleting = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final lesson = await _repository.playLesson(widget.lessonId);
      setState(() {
        _lessonDetail = lesson;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _completeLesson() async {
    if (_isCompleted) return;
    setState(() {
      _isCompleting = true;
    });

    try {
      await _repository.completeLesson(widget.lessonId);
      if (widget.courseId != null && widget.courseId!.isNotEmpty) {
        await _cacheService.addCompletedLesson(
          widget.courseId!,
          widget.lessonId,
        );
      }
      if (!mounted) return;
      setState(() {
        _isCompleted = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã hoàn thành bài học!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể hoàn thành: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }

  String _formatDuration(int? minutes) {
    if (minutes == null || minutes <= 0) return '';
    if (minutes < 60) return '$minutes phút';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h giờ' : '$h giờ $m phút';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chia sẻ bài học')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Lỗi: $_errorMessage'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _loadLesson,
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildVideoPlayer(),
                        _buildLessonInfo(),
                        _buildTabNavigation(),
                        _buildTabContent(),
                        _buildCompleteButton(),
                      ],
                    ),
                  ),
      ),
    );
  }

  // ==================== VIDEO PLAYER ====================
  Widget _buildVideoPlayer() {
    final hasVideo = _lessonDetail?.videoUrl != null &&
        _lessonDetail!.videoUrl!.isNotEmpty;
    final durationLabel = _formatDuration(_lessonDetail?.durationMinutes);

    return Container(
      height: 240,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Play button overlay
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1a1f3a),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: GestureDetector(
                onTap: hasVideo
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Video: ${_lessonDetail!.videoUrl}'),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasVideo
                        ? Icons.play_arrow_rounded
                        : Icons.videocam_off_outlined,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),

          // Video URL badge (top left)
          if (hasVideo)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.videocam, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'VIDEO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Duration badge (bottom right)
          if (durationLabel.isNotEmpty)
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  durationLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Completed overlay
          if (_isCompleted)
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'Đã hoàn thành',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== LESSON INFO ====================
  Widget _buildLessonInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.moduleName.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Lesson name
          Text(
            _lessonDetail?.title ?? widget.lessonName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),

          // Instructor info
          Row(
            children: [
              const Icon(Icons.person_rounded, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Professor Alán Turing • Department of Pure Mathematics',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Duration & Preview row
          Row(
            children: [
              // Duration from API
              if (_lessonDetail?.durationMinutes != null &&
                  _lessonDetail!.durationMinutes! > 0) ...[
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.schedule_rounded,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        _formatDuration(_lessonDetail!.durationMinutes),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Preview badge
              if (_lessonDetail?.isPreview == true)
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.lock_open_rounded,
                          size: 14, color: Color(0xFF34D399)),
                      const SizedBox(width: 6),
                      Text(
                        'Xem thử miễn phí',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF34D399),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== TAB NAVIGATION ====================
  Widget _buildTabNavigation() {
    final tabs = ['Theory', 'Attachments', 'Discussion'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedTabIndex = index),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ==================== TAB CONTENT ====================
  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildTheoryTab();
      case 1:
        return _buildAttachmentsTab();
      case 2:
        return _buildDiscussionTab();
      default:
        return const SizedBox.shrink();
    }
  }

  // ==================== THEORY TAB ====================
  Widget _buildTheoryTab() {
    final description = _lessonDetail?.description;
    final hasDescription =
        description != null && description.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lesson title
          Text(
            _lessonDetail?.title ?? widget.lessonName,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Description from API or empty state
          if (hasDescription)
            Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.7,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 18, color: Colors.grey[400]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Nội dung bài học chưa có mô tả. Vui lòng xem video để học.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Video URL section (if available)
          if (_lessonDetail?.videoUrl != null &&
              _lessonDetail!.videoUrl!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.play_circle_outline,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Video bài học',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _lessonDetail!.videoUrl!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ==================== ATTACHMENTS TAB ====================
  Widget _buildAttachmentsTab() {
    final attachments = <Map<String, dynamic>>[];
    if (_lessonDetail?.pdfUrl != null && _lessonDetail!.pdfUrl!.isNotEmpty) {
      attachments.add({
        'name': _lessonDetail!.pdfUrl!.split('/').last,
        'size': 'PDF',
        'icon': Icons.picture_as_pdf,
        'color': Colors.red,
      });
    }

    if (attachments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Text(
          'Chưa có tài liệu đính kèm.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(attachments.length, (index) {
            final file = attachments[index];
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đang tải xuống: ${file['name']}')),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (file['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        file['icon'] as IconData,
                        color: file['color'] as Color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file['name'] as String,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            file['size'] as String,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.download_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCompleteButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ElevatedButton.icon(
        onPressed: (_isCompleting || _isCompleted) ? null : _completeLesson,
        icon: Icon(
          _isCompleted
              ? Icons.check_circle
              : Icons.check_circle_outline,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isCompleted ? Colors.green : AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              _isCompleted ? Colors.green.withOpacity(0.8) : null,
          disabledForegroundColor:
              _isCompleted ? Colors.white : null,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        label: Text(
          _isCompleting
              ? 'Đang cập nhật...'
              : _isCompleted
                  ? 'Đã hoàn thành'
                  : 'Hoàn thành bài học',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ==================== DISCUSSION TAB ====================
  Widget _buildDiscussionTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Input field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_circle, color: AppColors.primary, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Đặt câu hỏi hoặc bình luận...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.send_rounded, color: AppColors.primary, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sample comments
          _buildCommentItem(
            name: 'Sarah Johnson',
            time: '2 giờ trước',
            comment: 'Bài giảng này rất hay! Nhưng em không hiểu phần chain rule, có thể giải thích lại được không?',
            likes: 12,
            replies: 3,
          ),
          const SizedBox(height: 12),
          _buildCommentItem(
            name: 'Prof. Alan Turing',
            time: '1 giờ trước',
            comment: 'Chain rule là áp dụng quy tắc tích phân cho các hàm hợp. Em xem lại slide 15 sẽ rõ hơn.',
            likes: 24,
            replies: 1,
            isInstructor: true,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ==================== COMMENT ITEM ====================
  Widget _buildCommentItem({
    required String name,
    required String time,
    required String comment,
    required int likes,
    required int replies,
    bool isInstructor = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isInstructor ? AppColors.primary.withOpacity(0.05) : AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isInstructor ? AppColors.primary.withOpacity(0.2) : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_circle, color: AppColors.primary, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (isInstructor) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Giảng viên',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.favorite_border, size: 16, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                '$likes',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                '$replies trả lời',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
