import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/learning_cache_service.dart';
import '../../data/datasources/learning_remote_datasource.dart';
import '../../data/datasources/rag_chat_remote_datasource.dart';
import '../../data/models/course_models.dart';
import '../../data/repositories/learning_repository_impl.dart';

class LessonPlayScreen extends StatefulWidget {
  final String lessonId;
  final String lessonName;
  final String moduleName;
  final String? courseId;
  final String? initialVideoUrl;
  final String? initialPdfUrl;

  const LessonPlayScreen({
    super.key,
    this.lessonId = '1',
    this.lessonName = 'Advanced Calculus: Partial Derivatives & Chain Rule',
    this.moduleName = 'Mathematics',
    this.courseId,
    this.initialVideoUrl,
    this.initialPdfUrl,
  });

  @override
  State<LessonPlayScreen> createState() => _LessonPlayScreenState();
}

class _LessonPlayScreenState extends State<LessonPlayScreen> {
  int _selectedTabIndex = 0; // 0: Theory, 1: Attachments, 2: Discussion
  final LearningRepositoryImpl _repository = LearningRepositoryImpl(
    LearningRemoteDataSourceImpl(),
  );
  final LearningCacheService _cacheService = LearningCacheService();
  bool _isLoading = true;
  String? _errorMessage;
  LessonDetail? _lessonDetail;
  bool _isCompleting = false;
  bool _isCompleted = false;
  YoutubePlayerController? _youtubeController;
  String? _activeYoutubeVideoId;

  @override
  void initState() {
    super.initState();
    _applyInitialLesson();
    _loadCompletionState();
    _loadLesson();
  }

  Future<void> _loadCompletionState() async {
    if (widget.courseId == null || widget.courseId!.isEmpty) return;
    final completedLessonIds = await _cacheService.getCompletedLessonIds(
      widget.courseId!,
    );
    if (!mounted) return;
    setState(() {
      _isCompleted = completedLessonIds.contains(widget.lessonId);
    });
  }

  void _applyInitialLesson() {
    final hasInitialVideo =
        widget.initialVideoUrl != null && widget.initialVideoUrl!.isNotEmpty;
    final hasInitialPdf =
        widget.initialPdfUrl != null && widget.initialPdfUrl!.isNotEmpty;
    if (!hasInitialVideo && !hasInitialPdf) return;

    _lessonDetail = LessonDetail(
      id: widget.lessonId,
      chapterId: '',
      title: widget.lessonName,
      videoUrl: widget.initialVideoUrl,
      pdfUrl: widget.initialPdfUrl,
      orderIndex: 0,
      isPreview: false,
    );
    _syncYoutubeController(widget.initialVideoUrl);
  }

  Future<void> _loadLesson() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final lesson = await _repository.playLesson(widget.lessonId);
      final completedLessonIds =
          widget.courseId == null || widget.courseId!.isEmpty
          ? <String>{}
          : await _cacheService.getCompletedLessonIds(widget.courseId!);
      setState(() {
        _lessonDetail = lesson;
        _isCompleted = completedLessonIds.contains(widget.lessonId);
        _isLoading = false;
      });
      _syncYoutubeController(lesson.videoUrl);
    } catch (e) {
      if (_lessonDetail != null) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Không tải được chi tiết bài học, đang dùng dữ liệu video có sẵn. ($e)',
              ),
            ),
          );
        }
        return;
      }
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
      await _markLessonCompleted(
        'Đã hoàn thành bài học!',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      await _markLessonCompleted(
        'Đã lưu hoàn thành trên máy. Backend chưa ghi nhận: ${e.toString().replaceFirst('Exception: ', '')}',
        backgroundColor: Colors.orange,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }

  Future<void> _markLessonCompleted(
    String message, {
    required Color backgroundColor,
  }) async {
    if (widget.courseId != null && widget.courseId!.isNotEmpty) {
      await _cacheService.addCompletedLesson(widget.courseId!, widget.lessonId);
    }
    if (!mounted) return;
    setState(() {
      _isCompleted = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAiTutor,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.auto_awesome_rounded),
        label: const Text(
          'Hỏi AI',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Chia sẻ bài học')));
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
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 96,
                ),
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

  void _syncYoutubeController(String? videoUrl) {
    final videoId = _extractYoutubeVideoId(videoUrl);
    if (videoId == null || videoId.isEmpty) {
      _youtubeController?.close();
      _youtubeController = null;
      _activeYoutubeVideoId = null;
      return;
    }

    if (_activeYoutubeVideoId == videoId && _youtubeController != null) return;

    _youtubeController?.close();
    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
        enableCaption: true,
        playsInline: true,
        strictRelatedVideos: true,
      ),
    );
    _activeYoutubeVideoId = videoId;
  }

  String? _extractYoutubeVideoId(String? url) {
    final value = url?.trim();
    if (value == null || value.isEmpty) return null;

    final uri = Uri.tryParse(value);
    if (uri == null) return null;

    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    if (uri.host.contains('youtube.com') ||
        uri.host.contains('youtube-nocookie.com')) {
      final watchId = uri.queryParameters['v'];
      if (watchId != null && watchId.isNotEmpty) return watchId;

      final segments = uri.pathSegments;
      final embedIndex = segments.indexWhere(
        (segment) => segment == 'embed' || segment == 'shorts',
      );
      if (embedIndex >= 0 && segments.length > embedIndex + 1) {
        return segments[embedIndex + 1];
      }
    }

    return null;
  }

  @override
  void dispose() {
    _youtubeController?.close();
    super.dispose();
  }

  void _openAiTutor() {
    if (widget.courseId == null || widget.courseId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không tìm thấy course_id cho bài học này.'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _LessonAiTutorSheet(
          courseId: widget.courseId!,
          lessonId: widget.lessonId,
          lessonTitle: _lessonDetail?.title ?? widget.lessonName,
        );
      },
    );
  }

  // ==================== VIDEO PLAYER ====================
  Widget _buildVideoPlayer() {
    final hasVideo =
        _lessonDetail?.videoUrl != null && _lessonDetail!.videoUrl!.isNotEmpty;
    final durationLabel = _formatDuration(_lessonDetail?.durationMinutes);
    final youtubeController = _youtubeController;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: youtubeController != null
            ? YoutubePlayer(
                controller: youtubeController,
                aspectRatio: 16 / 9,
                autoFullScreen: true,
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: const Color(0xFF1a1f3a),
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.3),
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
                  if (hasVideo)
                    Positioned(
                      bottom: 14,
                      left: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.68),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Link video không phải YouTube hoặc chưa hỗ trợ phát trực tiếp.',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (durationLabel.isNotEmpty)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
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
                ],
              ),
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
              color: AppColors.primary.withValues(alpha: 0.1),
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
              const Icon(
                Icons.person_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
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
                      const Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
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
                      const Icon(
                        Icons.lock_open_rounded,
                        size: 14,
                        color: Color(0xFF34D399),
                      ),
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
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
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
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
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
    final hasDescription = description != null && description.trim().isNotEmpty;

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
                  Icon(Icons.info_outline, size: 18, color: Colors.grey[400]),
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
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.play_circle_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
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
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
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
                        color: (file['color'] as Color).withValues(alpha: 0.1),
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
                        color: AppColors.primary.withValues(alpha: 0.1),
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
    if (_isCompleted) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.35)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Text(
                'Đã hoàn thành bài học',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ElevatedButton.icon(
        onPressed: _isCompleting ? null : _completeLesson,
        icon: const Icon(Icons.check_circle_outline),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isCompleted ? Colors.green : AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _isCompleted
              ? Colors.green.withValues(alpha: 0.8)
              : null,
          disabledForegroundColor: _isCompleted ? Colors.white : null,
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
                const Icon(
                  Icons.account_circle,
                  color: AppColors.primary,
                  size: 36,
                ),
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
                const Icon(
                  Icons.send_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sample comments
          _buildCommentItem(
            name: 'Sarah Johnson',
            time: '2 giờ trước',
            comment:
                'Bài giảng này rất hay! Nhưng em không hiểu phần chain rule, có thể giải thích lại được không?',
            likes: 12,
            replies: 3,
          ),
          const SizedBox(height: 12),
          _buildCommentItem(
            name: 'Prof. Alan Turing',
            time: '1 giờ trước',
            comment:
                'Chain rule là áp dụng quy tắc tích phân cho các hàm hợp. Em xem lại slide 15 sẽ rõ hơn.',
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
        color: isInstructor
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isInstructor
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_circle,
                color: AppColors.primary,
                size: 32,
              ),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
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
              Icon(
                Icons.chat_bubble_outline,
                size: 16,
                color: Colors.grey[500],
              ),
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

class _LessonAiTutorSheet extends StatefulWidget {
  final String courseId;
  final String lessonId;
  final String lessonTitle;

  const _LessonAiTutorSheet({
    required this.courseId,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  State<_LessonAiTutorSheet> createState() => _LessonAiTutorSheetState();
}

class _LessonAiTutorSheetState extends State<_LessonAiTutorSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RagChatRemoteDataSource _dataSource = RagChatRemoteDataSource();
  final List<RagChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final question = _controller.text.trim();
    if (question.isEmpty || _isLoading) return;

    final history = _messages
        .where(
          (message) => message.role == 'user' || message.role == 'assistant',
        )
        .toList();

    setState(() {
      _messages.add(RagChatMessage(role: 'user', content: question));
      _isLoading = true;
      _errorMessage = null;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final response = await _dataSource.chat(
        courseId: widget.courseId,
        lessonId: widget.lessonId,
        question: question,
        chatHistory: history.length > 6
            ? history.sublist(history.length - 6)
            : history,
      );
      if (!mounted) return;
      setState(() {
        _messages.add(
          RagChatMessage(
            role: 'assistant',
            content: response.answer.isEmpty
                ? 'AI chưa tìm thấy câu trả lời phù hợp trong bài học.'
                : response.answer,
            sources: response.sources,
            confidence: response.confidence,
            usedFallback: response.usedFallback,
          ),
        );
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.78,
        minChildSize: 0.45,
        maxChildSize: 0.94,
        builder: (context, _) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: _messages.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: _messages.length + (_isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_isLoading && index == _messages.length) {
                              return _buildLoadingBubble();
                            }
                            return _buildMessage(_messages[index]);
                          },
                        ),
                ),
                if (_errorMessage != null) _buildError(),
                _buildInputBar(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gia sư AI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.lessonTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology_alt_outlined,
                color: AppColors.primary,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hỏi dựa trên nội dung bài học',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AI sẽ tìm trong nội dung đã được đồng bộ và hiển thị nguồn tham chiếu sau câu trả lời.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(RagChatMessage message) {
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: isUser ? null : double.infinity,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LessonAiFormattedText(
              text: message.content,
              color: isUser ? Colors.white : AppColors.textPrimary,
            ),
            if (!isUser &&
                (message.usedFallback || message.confidence != null)) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (message.confidence != null)
                    _buildMetaChip(
                      'Độ tin cậy ${message.confidence!.toStringAsFixed(2)}',
                    ),
                  if (message.usedFallback) _buildMetaChip('Fallback'),
                ],
              ),
            ],
            if (!isUser && message.sources.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildSources(message.sources),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetaChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSources(List<RagSource> sources) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(
          'Nguồn tham chiếu (${sources.length})',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        children: sources.map(_buildSourceItem).toList(),
      ),
    );
  }

  Widget _buildSourceItem(RagSource source) {
    final title = source.sectionTitle.isNotEmpty
        ? source.sectionTitle
        : source.lessonTitle;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.isEmpty ? 'Đoạn bài học' : title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${source.sectionType.isEmpty ? 'section' : source.sectionType} · score ${source.score.toStringAsFixed(2)}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (source.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              source.text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'AI đang tìm trong bài học...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Text(
        _errorMessage!,
        style: AppTextStyles.caption.copyWith(color: const Color(0xFFB91C1C)),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: 'Hỏi về bài học này...',
                  border: InputBorder.none,
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: _isLoading ? Colors.grey[300] : AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _isLoading ? null : _send,
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonAiFormattedText extends StatelessWidget {
  final String text;
  final Color color;

  const _LessonAiFormattedText({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines.length, (index) {
        final line = lines[index];
        final normalizedLine = _normalizeMarkdownLine(line);
        if (normalizedLine.trim().isEmpty) {
          return const SizedBox(height: 8);
        }

        return Padding(
          padding: EdgeInsets.only(bottom: index == lines.length - 1 ? 0 : 6),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 2,
            runSpacing: 4,
            children: _buildInlineParts(normalizedLine),
          ),
        );
      }),
    );
  }

  String _normalizeMarkdownLine(String line) {
    return line
        .replaceAll(RegExp(r'^\s*#{1,6}\s+'), '')
        .replaceAll(RegExp(r'^\s*[-*]\s+'), '• ')
        .replaceAll(RegExp(r'\*\*'), '');
  }

  List<Widget> _buildInlineParts(String line) {
    final widgets = <Widget>[];
    final regex = RegExp(r'\$([^$]+)\$');
    var start = 0;

    for (final match in regex.allMatches(line)) {
      if (match.start > start) {
        widgets.add(_plainText(line.substring(start, match.start)));
      }

      final expression = match.group(1)?.trim() ?? '';
      if (expression.isNotEmpty) {
        widgets.add(_mathText(expression));
      }

      start = match.end;
    }

    if (start < line.length) {
      widgets.add(_plainText(line.substring(start)));
    }

    return widgets;
  }

  Widget _plainText(String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Text(
      value,
      style: AppTextStyles.bodyMedium.copyWith(color: color, height: 1.45),
    );
  }

  Widget _mathText(String expression) {
    return Math.tex(
      expression,
      textStyle: AppTextStyles.bodyMedium.copyWith(color: color, height: 1.45),
      mathStyle: MathStyle.text,
      onErrorFallback: (error) => Text(
        expression,
        style: AppTextStyles.bodyMedium.copyWith(color: color, height: 1.45),
      ),
    );
  }
}
