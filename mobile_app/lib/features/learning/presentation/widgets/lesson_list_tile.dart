import 'package:flutter/material.dart';

enum LessonTileStatus { locked, available, completed }

class LessonListTile extends StatelessWidget {
  final String lessonName;
  final String duration;
  final LessonTileStatus status;
  final String? progress;
  final VoidCallback? onTap;

  const LessonListTile({
    Key? key,
    required this.lessonName,
    required this.duration,
    required this.status,
    this.progress,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    IconData iconData;
    bool isLocked = status == LessonTileStatus.locked;

    switch (status) {
      case LessonTileStatus.completed:
        iconColor = const Color(0xFF1a1f3a);
        iconData = Icons.check_circle;
        break;
      case LessonTileStatus.available:
        iconColor = const Color(0xFF2563EB);
        iconData = Icons.play_circle;
        break;
      case LessonTileStatus.locked:
        iconColor = Colors.grey[400]!;
        iconData = Icons.lock;
        break;
    }

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isLocked ? Colors.grey[300]! : const Color(0xFF2563EB),
            width: status == LessonTileStatus.completed ? 0 : 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isLocked ? Colors.grey[50] : Colors.white,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withOpacity(0.1),
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Lesson info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lessonName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (progress != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '• $progress hoàn thành',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Arrow icon for available lessons
            if (!isLocked)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }
}
