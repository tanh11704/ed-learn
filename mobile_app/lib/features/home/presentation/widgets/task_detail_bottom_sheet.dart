import 'package:flutter/material.dart';
import '../bloc/home_state.dart';

class TaskDetailBottomSheet extends StatelessWidget {
  final Task task;
  final VoidCallback onMarkCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskDetailBottomSheet({
    Key? key,
    required this.task,
    required this.onMarkCompleted,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile header
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.orange[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Chào buổi sáng',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Nguyễn Văn A',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Icon(
                              Icons.notifications_outlined,
                              color: Colors.grey[500],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Task title
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Info row: time, building, reward
                        Row(
                          children: [
                            _buildInfoItem(
                              icon: Icons.access_time,
                              label: '45 phút',
                              sublabel: 'THỜI GIAN',
                            ),
                            const SizedBox(width: 20),
                            _buildInfoItem(
                              icon: Icons.location_on_outlined,
                              label: 'Trung bình',
                              sublabel: 'MỨC ĐỘ',
                            ),
                            const SizedBox(width: 20),
                            _buildInfoItem(
                              icon: Icons.star_outline,
                              label: '+50 XP',
                              sublabel: 'THƯỞNG',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Task description
                        const Text(
                          'Chi tiết bài tập',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task.description.isNotEmpty
                              ? task.description
                              : 'Bài tập bao gồm kiến thức về Giải tích và Hình học không gian lớp 12. Hãy chuẩn bị giấy nháp trước khi bắt đầu bài thi.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Start button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: onMarkCompleted,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Bắt đầu ngay',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Skip button
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: onDelete,
                            child: const Text(
                              'Để sau',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String sublabel,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.grey[600], size: 24),
          const SizedBox(height: 8),
          Text(
            sublabel,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
