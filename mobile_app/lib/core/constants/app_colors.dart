import 'package:flutter/material.dart';

class AppColors {
  // Ngăn không cho khởi tạo class này (chỉ dùng static)
  AppColors._();

  // Màu chủ đạo (Primary)
  static const Color primary = Color(0xFF1890FF); // Xanh dương EdTech
  static const Color primaryLight = Color(0xFFE6F7FF);
  static const Color primaryDark = Color(0xFF0050B3);

  // Màu trạng thái (Semantic Colors)
  static const Color success = Color(0xFF52C41A); // Xanh lá (chấm điểm đúng)
  static const Color error = Color(0xFFFF4D4F);   // Đỏ (chấm điểm sai/cảnh báo)
  static const Color warning = Color(0xFFFAAD14); // Vàng cam (chờ duyệt/nhắc nhở)

  // Màu Nền & Xám (Neutrals - dùng cho text và background)
  static const Color background = Color(0xFFF5F7FA); // Nền xám nhạt cho app
  static const Color white = Color(0xFFFFFFFF);
  
  static const Color textPrimary = Color(0xFF1F2937); // Đen xám cho tiêu đề
  static const Color textSecondary = Color(0xFF6B7280); // Xám nhạt cho mô tả
  static const Color border = Color(0xFFE5E7EB); // Viền input, divider
}