import 'package:flutter/material.dart';

import '../../data/datasources/learning_remote_datasource.dart';
import '../../data/models/course_models.dart';
import '../../data/repositories/learning_repository_impl.dart';

class CourseSelectionBottomSheet extends StatefulWidget {
  final VoidCallback? onHideNavBar;
  final VoidCallback? onShowNavBar;
  final String? selectedCourseId;

  const CourseSelectionBottomSheet({
    super.key,
    this.onHideNavBar,
    this.onShowNavBar,
    this.selectedCourseId,
  });

  @override
  State<CourseSelectionBottomSheet> createState() =>
      _CourseSelectionBottomSheetState();
}

class _CourseSelectionBottomSheetState
    extends State<CourseSelectionBottomSheet> {
  late String selectedCourseId;
  final LearningRepositoryImpl _repository =
      LearningRepositoryImpl(LearningRemoteDataSourceImpl());

  bool _isLoading = true;
  bool _isEnrolling = false;
  bool _showExploreCourses = false;
  String? _errorMessage;
  List<CourseSummary> _myCourses = [];
  List<CourseSummary> _publicCourses = [];

  @override
  void initState() {
    super.initState();
    widget.onHideNavBar?.call();
    selectedCourseId = widget.selectedCourseId ?? '';
    _loadCourses();
  }

  @override
  void dispose() {
    widget.onShowNavBar?.call();
    super.dispose();
  }

  Future<void> _loadCourses({bool forceRefresh = false}) async {
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
        size: 24,
        forceRefresh: forceRefresh,
      );

      final selected = widget.selectedCourseId ??
          (myCourses.isNotEmpty ? myCourses.first.id : selectedCourseId);

      if (!mounted) return;
      setState(() {
        _myCourses = myCourses;
        _publicCourses = publicCourses;
        selectedCourseId = selected;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _enrollCourse(CourseSummary course) async {
    setState(() => _isEnrolling = true);

    try {
      await _repository.enrollCourse(course.id);
      await _loadCourses(forceRefresh: true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã đăng ký khóa học ${course.title}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể đăng ký: $e')),
      );
    } finally {
      if (mounted) setState(() => _isEnrolling = false);
    }
  }

  List<CourseSummary> get _exploreCourses {
    final enrolledIds = _myCourses.map((course) => course.id).toSet();
    return _publicCourses
        .where((course) => !enrolledIds.contains(course.id))
        .toList();
  }

  IconData _courseIcon(CourseSummary course) {
    final subject = (course.subject ?? '').toLowerCase();
    if (subject.contains('math') || subject.contains('toán')) {
      return Icons.functions;
    }
    if (subject.contains('english') || subject.contains('ielts')) {
      return Icons.language;
    }
    if (subject.contains('data')) {
      return Icons.bar_chart;
    }
    return Icons.school;
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF94A3B8),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        message,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
    );
  }

  Widget _buildCourseTile({
    required CourseSummary course,
    required bool isSelected,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final bgColor =
        isSelected ? const Color(0xFFF4F8FF) : const Color(0xFFF3F4F6);
    final borderColor =
        isSelected ? const Color(0xFF2563EB) : Colors.transparent;
    final iconBgColor =
        isSelected ? const Color(0xFFDBEAFE) : const Color(0xFFE5E7EB);
    final iconColor =
        isSelected ? const Color(0xFF2563EB) : const Color(0xFF6B7280);
    final titleColor = isSelected ? const Color(0xFF2563EB) : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_courseIcon(course), color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        course.subject ??
                            course.description ??
                            'Khóa học phổ biến',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExploreButton(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: count == 0
            ? null
            : () {
                setState(() => _showExploreCourses = !_showExploreCourses);
              },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _showExploreCourses ? Icons.expand_less : Icons.add,
                color: const Color(0xFF2563EB),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _showExploreCourses
                    ? 'Thu gọn khóa học'
                    : 'Khám phá thêm khóa học',
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsLinks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(Icons.settings, color: Colors.grey[600], size: 22),
                const SizedBox(width: 16),
                Text(
                  'Tùy chỉnh lộ trình hiện tại',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(Icons.flag_outlined, color: Colors.grey[600], size: 22),
                const SizedBox(width: 16),
                Text(
                  'Thay đổi mục tiêu điểm số',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exploreCourses = _exploreCourses;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chuyển đổi môn học',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            size: 22,
                            color: Colors.black54,
                          ),
                          onPressed: () => _loadCourses(forceRefresh: true),
                          splashRadius: 22,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.black54,
                          ),
                          onPressed: () => Navigator.pop(context),
                          splashRadius: 24,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                )
              else if (_errorMessage != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        _errorMessage ?? 'Đã xảy ra lỗi',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _loadCourses,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Khóa học của tôi'),
                      if (_myCourses.isEmpty)
                        _buildEmptyMessage(
                          'Bạn chưa đăng ký khóa học nào.',
                        )
                      else
                        ..._myCourses.map(
                          (course) => _buildCourseTile(
                            course: course,
                            isSelected: selectedCourseId == course.id,
                            onTap: () {
                              setState(() => selectedCourseId = course.id);
                              Future.delayed(
                                const Duration(milliseconds: 250),
                                () {
                                  if (mounted) Navigator.pop(context, course);
                                },
                              );
                            },
                            trailing: selectedCourseId == course.id
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF2563EB),
                                    size: 26,
                                  )
                                : const Icon(
                                    Icons.chevron_right,
                                    color: Colors.black38,
                                    size: 24,
                                  ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      _buildExploreButton(exploreCourses.length),
                      if (_showExploreCourses) ...[
                        const SizedBox(height: 12),
                        _buildSectionHeader('Khám phá thêm khóa học'),
                        if (exploreCourses.isEmpty)
                          _buildEmptyMessage(
                            'Không còn khóa học mới để đăng ký.',
                          )
                        else
                          ...exploreCourses.map(
                            (course) => _buildCourseTile(
                              course: course,
                              isSelected: false,
                              trailing: TextButton(
                                onPressed: _isEnrolling
                                    ? null
                                    : () => _enrollCourse(course),
                                child: const Text('Đăng ký'),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              const Divider(
                height: 1,
                color: Color(0xFFF3F4F6),
                thickness: 1.5,
              ),
              _buildSettingsLinks(),
            ],
          ),
        ),
      ),
    );
  }
}
