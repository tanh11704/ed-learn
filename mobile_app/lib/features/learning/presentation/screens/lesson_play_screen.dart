import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class LessonPlayScreen extends StatefulWidget {
  final String lessonId;
  final String lessonName;
  final String moduleName;

  const LessonPlayScreen({
    Key? key,
    this.lessonId = '1',
    this.lessonName = 'Advanced Calculus: Partial Derivatives & Chain Rule',
    this.moduleName = 'Mathematics',
  }) : super(key: key);

  @override
  State<LessonPlayScreen> createState() => _LessonPlayScreenState();
}

class _LessonPlayScreenState extends State<LessonPlayScreen> {
  int _selectedTabIndex = 0; // 0: Theory, 1: Attachments, 2: Discussion

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ==================== VIDEO PLAYER ====================
              _buildVideoPlayer(),

              // ==================== LESSON INFO ====================
              _buildLessonInfo(),

              // ==================== TAB NAVIGATION ====================
              _buildTabNavigation(),

              // ==================== TAB CONTENT ====================
              _buildTabContent(),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== VIDEO PLAYER ====================
  Widget _buildVideoPlayer() {
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
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1a1f3a),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ),

          // Duration badge
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '12:45 / 45:00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Progress bar indicator
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: LinearProgressIndicator(
                value: 0.28, // 12:45 / 45:00
                minHeight: 4,
                backgroundColor: Colors.grey[700],
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
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
            widget.lessonName,
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

          // Duration & Difficulty row
          Row(
            children: [
              // Duration
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      '45 phút',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Difficulty
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.trending_up_rounded, size: 14, color: Color(0xFFFFB84D)),
                    const SizedBox(width: 6),
                    Text(
                      'Trung bình',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary section
          Text(
            'Introduction to Partial Derivatives',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'In mathematics, a partial derivative of a function of several variables is its derivative with respect to one of those variables, with the others held constant. Partial derivatives are used in vector calculus and differential geometry.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),

          // Formula section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              'ƒₓ(x, y) = lim_{h→0} [f(x+h, y) - f(x, y)] / h',
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Courier',
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Historical note
          Text(
            'The symbol ∂ used to denote partial derivatives is a modification of the ordinary d of calculus. It was first used in mathematics by Marquis de Condorcet in 1770 for partial differences.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ==================== ATTACHMENTS TAB ====================
  Widget _buildAttachmentsTab() {
    final attachments = [
      {
        'name': 'Lecture_Notes_04.pdf',
        'size': '2.4 MB',
        'icon': Icons.picture_as_pdf,
        'color': Colors.red,
      },
      {
        'name': 'Exercise_Set_04.docx',
        'size': '1.2 MB',
        'icon': Icons.description,
        'color': Colors.blue,
      },
      {
        'name': 'Solution_Guide.pdf',
        'size': '3.1 MB',
        'icon': Icons.picture_as_pdf,
        'color': Colors.red,
      },
    ];

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
