import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_shell.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/assessment/presentation/screens/intro_assessment_screen.dart';
import '../features/assessment/presentation/screens/testing_screen.dart';
import '../features/assessment/presentation/screens/result_analysis_screen.dart';
import '../features/assessment/presentation/screens/target_university_screen.dart';
import '../features/assessment/presentation/screens/target_score_screen.dart';
import '../features/assessment/presentation/screens/learning_schedule_screen.dart';
import '../features/assessment/presentation/screens/ai_processing_screen.dart';
import '../features/assessment/presentation/screens/ai_done_screen.dart';
import '../features/assessment/presentation/screens/universities_screen.dart';
import '../features/home/home_screen.dart';

// Khởi tạo trực tiếp GoRouter 
final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/learning', builder: (context, state) => const Scaffold(body: Center(child: Text('Học tập'))))]),
        StatefulShellBranch(routes: [GoRoute(path: '/exam', builder: (context, state) => const Scaffold(body: Center(child: Text('Thi thử'))))]),
        StatefulShellBranch(routes: [GoRoute(path: '/profile', builder: (context, state) => const Scaffold(body: Center(child: Text('Cá nhân'))))]),
      ],
    ),
    GoRoute(
      path: '/camera',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('📸 Màn hình Camera (Full Screen)')),
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/assessment/intro',
      builder: (context, state) => const IntroAssessmentScreen(),
    ),
    GoRoute(
      path: '/assessment/testing',
      builder: (context, state) => const TestingScreen(),
    ),
    GoRoute(
      path: '/assessment/result',
      builder: (context, state) => const ResultAnalysisScreen(),
    ),
    GoRoute(
      path: '/assessment/target-university',
      builder: (context, state) => const TargetUniversityScreen(),
    ),
    GoRoute(
      path: '/assessment/target-score',
      builder: (context, state) => const TargetScoreScreen(),
    ),
    GoRoute(
      path: '/assessment/learning-schedule',
      builder: (context, state) => const LearningScheduleScreen(),
    ),
    GoRoute(
      path: '/assessment/ai-processing',
      builder: (context, state) => const AiProcessingScreen(),
    ),
    GoRoute(
      path: '/assessment/ai-done',
      builder: (context, state) => const AiDoneScreen(),
    ),
    GoRoute(
      path: '/assessment/universities',
      builder: (context, state) => const UniversitiesScreen(),
    ),
  ],
);