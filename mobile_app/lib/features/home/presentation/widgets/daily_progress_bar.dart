import 'package:flutter/material.dart';

class DailyProgressBar extends StatelessWidget {
  final int progress; // 0-100
  final String message;
  
  const DailyProgressBar({
    Key? key,
    required this.progress,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tiến độ hàng ngày', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),),
              Text('$progress%',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              )
            ],
          ),
          const SizedBox(height: 12),
          //Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[500]!),
            ),
          ),
          const SizedBox(height: 12),

          // Message
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),

        ],
      ),
    );
  }
}
