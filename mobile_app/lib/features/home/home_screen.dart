import 'package:flutter/material.dart';
import '../../core/constants/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Trang Chủ', style: AppTextStyles.heading1),
      ),
    );
  }
}