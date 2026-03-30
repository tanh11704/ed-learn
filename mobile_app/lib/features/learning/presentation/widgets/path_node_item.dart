import 'package:flutter/material.dart';

enum LessonNodeStatus { mastered, current, locked }

class PathNodeItem extends StatelessWidget {
  final String lessonName;
  final LessonNodeStatus status;
  final String? masteredDate;
  final int? levelRequired;
  final VoidCallback? onTap;

  const PathNodeItem({
    Key? key,
    required this.lessonName,
    required this.status,
    this.masteredDate,
    this.levelRequired,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color nodeColor;
    IconData nodeIcon;
    double nodeSize;
    BoxShadow? nodeShadow;

    switch (status) {
      case LessonNodeStatus.mastered:
        nodeColor = const Color(0xFF1a1f3a);
        nodeIcon = Icons.check;
        nodeSize = 64;
        nodeShadow = null;
        break;
      case LessonNodeStatus.current:
        nodeColor = const Color(0xFF2563EB);
        nodeIcon = Icons.rocket_launch;
        nodeSize = 90;
        nodeShadow = BoxShadow(
          color: const Color(0xFF2563EB).withOpacity(0.4),
          blurRadius: 20,
          spreadRadius: 8,
        );
        break;
      case LessonNodeStatus.locked:
        nodeColor = Colors.grey[300]!;
        nodeIcon = Icons.lock;
        nodeSize = 64;
        nodeShadow = null;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: nodeSize,
            height: nodeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: nodeColor,
              boxShadow: nodeShadow != null ? [nodeShadow] : [],
            ),
            child: Icon(
              nodeIcon,
              color: status == LessonNodeStatus.locked ? Colors.grey[600] : Colors.white,
              size: nodeSize * 0.4,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 90,
            child: Column(
              children: [
                Text(
                  lessonName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (status == LessonNodeStatus.mastered && masteredDate != null)
                  Text(
                    'Hoàn thành\n$masteredDate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      height: 1.2,
                    ),
                  )
                else if (status == LessonNodeStatus.current)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Đang học',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else if (status == LessonNodeStatus.locked && levelRequired != null)
                  Text(
                    'Mở khóa\nLevel $levelRequired',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      height: 1.2,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
