import 'package:flutter/material.dart';

class CameraPipView extends StatelessWidget {
  final double size;
  final Widget? child;

  const CameraPipView({
    super.key,
    this.size = 52,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2563EB), width: 2),
      ),
      child: CircleAvatar(
        backgroundColor: const Color(0xFFE5E7EB),
        child: child ?? const Icon(Icons.person, color: Color(0xFF6B7280)),
      ),
    );
  }
}
