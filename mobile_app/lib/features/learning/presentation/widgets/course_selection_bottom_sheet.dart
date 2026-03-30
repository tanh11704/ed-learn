import 'package:flutter/material.dart';

class CourseSelectionBottomSheet extends StatefulWidget {
  final VoidCallback? onHideNavBar;
  final VoidCallback? onShowNavBar;

  const CourseSelectionBottomSheet({
    Key? key,
    this.onHideNavBar,
    this.onShowNavBar,
  }) : super(key: key);

  @override
  State<CourseSelectionBottomSheet> createState() =>
      _CourseSelectionBottomSheetState();
}

class _CourseSelectionBottomSheetState
    extends State<CourseSelectionBottomSheet> {
  late String selectedCourseId;

  // Mock data được cập nhật lại icon cho giống ảnh
  final List<Map<String, dynamic>> courses = [
    {
      'id': 'khoa-hoc-du-lieu',
      'name': 'Khoa học dữ liệu',
      'description': 'Cấp độ Trung cấp',
      'icon': Icons.bar_chart,
    },
    {
      'id': 'toan-hoc-12',
      'name': 'Toán học 12',
      'description': 'Đang học bài 5',
      'icon': Icons.functions, // Icon Sigma giống thiết kế
    },
    {
      'id': 'luyen-thi-ielts',
      'name': 'Luyện thi IELTS 7.0',
      'description': 'Đang học bài 2',
      'icon': Icons.language, // Icon quả địa cầu
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedCourseId = courses[0]['id'];
    widget.onHideNavBar?.call();
  }

  @override
  void dispose() {
    widget.onShowNavBar?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              // 1. Drag Handle (Thanh kéo xám trên cùng)
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 2. Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
                    IconButton(
                      icon: const Icon(Icons.close, size: 24, color: Colors.black54),
                      onPressed: () => Navigator.pop(context),
                      splashRadius: 24,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // 3. Danh sách môn học
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: List.generate(courses.length, (index) {
                    final course = courses[index];
                    final isSelected = selectedCourseId == course['id'];

                    // Định nghĩa màu sắc theo trạng thái để giống hệt UI
                    final bgColor = isSelected ? const Color(0xFFF4F8FF) : const Color(0xFFF3F4F6); // Blue nhạt vs Xám nhạt
                    final borderColor = isSelected ? const Color(0xFF2563EB) : Colors.transparent;
                    final iconBgColor = isSelected ? const Color(0xFFDBEAFE) : const Color(0xFFE5E7EB);
                    final iconColor = isSelected ? const Color(0xFF2563EB) : const Color(0xFF6B7280);
                    final titleColor = isSelected ? const Color(0xFF2563EB) : Colors.black87;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCourseId = course['id'];
                        });
                        Future.delayed(const Duration(milliseconds: 250), () {
                          Navigator.pop(context);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: bgColor,
                            border: Border.all(
                              color: borderColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20), // Bo góc tròn hơn giống ảnh
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                            child: Row(
                              children: [
                                // Icon Box
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: iconBgColor,
                                    shape: BoxShape.circle, // Đổi sang hình tròn
                                  ),
                                  child: Icon(
                                    course['icon'],
                                    color: iconColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Text Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course['name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: titleColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        course['description'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Trailing Icon (Dấu tick xanh HOẶC Mũi tên xám)
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF2563EB),
                                    size: 26,
                                  )
                                else
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.black38,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 8),

              // 4. Nút Khám phá thêm khóa học
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    // Xử lý thêm khóa học
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      // Viền nét đứt (Dùng viền liền xám nhạt làm fallback, nếu muốn đứt hẳn bạn cài package dotted_border nhé)
                      border: Border.all(color: Colors.grey.shade300, width: 1.5), 
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add, color: Color(0xFF2563EB), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Khám phá thêm khóa học',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              
              // Divider mờ
              const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),

              // 5. Cài đặt lộ trình (Bỏ nền xám, dùng nền trắng hoàn toàn)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
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
                          Icon(Icons.flag_outlined, color: Colors.grey[600], size: 22), // Đổi icon cờ
                          const SizedBox(width: 16),
                          Text(
                            'Thay đổi mục tiêu điểm số', // Cập nhật text chuẩn thiết kế
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}