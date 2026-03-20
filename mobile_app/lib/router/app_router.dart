import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_shell.dart';
import '../features/home/home_screen.dart';
// Import các màn hình dummy đã tạo ở Thao tác 1
// import '../features/learning/learning_screen.dart';
// import '../features/ai_solver/camera_screen.dart';
// import '../features/mock_exam/exam_screen.dart';
// import '../features/profile/profile_screen.dart';

// Dùng Riverpod để quản lý Router
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      // Luồng có chứa Bottom Nav Bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/learning', builder: (context, state) => const Scaffold(body: Center(child: Text('Học tập'))))]), // Thay bằng LearningScreen
          StatefulShellBranch(routes: [GoRoute(path: '/exam', builder: (context, state) => const Scaffold(body: Center(child: Text('Thi thử'))))]), // Thay bằng ExamScreen
          StatefulShellBranch(routes: [GoRoute(path: '/profile', builder: (context, state) => const Scaffold(body: Center(child: Text('Cá nhân'))))]), // Thay bằng ProfileScreen
        ],
      ),

      // Các luồng KHÔNG chứa Nav Bar (màn hình phủ toàn dải)
      GoRoute(
        path: '/camera',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('📸 Màn hình Camera Quét Đề (Full Screen)')),
        ), // Thay bằng CameraScreen
      ),
    ],
  );
});