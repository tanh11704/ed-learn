// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Đảm bảo import đúng tên package của bạn
import 'package:mobile_app/main.dart'; 

void main() {
  testWidgets('App bootstraps and shows Bottom Navigation Bar', (WidgetTester tester) async {
    // 1. Build ứng dụng của chúng ta
    // Bỏ ProviderScope đi vì EdTechApp đã tự bọc MultiBlocProvider rồi
    await tester.pumpWidget(const EdTechApp());

    // 2. Chờ cho tất cả các animation và GoRouter điều hướng xong
    await tester.pumpAndSettle();

    // 3. Kiểm tra xem ứng dụng có khởi chạy thành công và hiển thị các tab không
    expect(find.text('Trang chủ'), findsOneWidget);
    expect(find.text('Học tập'), findsOneWidget);
    
    // (Tùy chọn) Kiểm tra xem nút Camera có xuất hiện không
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });
}