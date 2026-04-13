import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';

class ProfileStatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const ProfileStatItem({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFFAAD14)),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
