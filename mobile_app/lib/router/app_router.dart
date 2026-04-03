import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/home/presentation/screens/home_screen.dart';
import 'package:mobile_app/features/home/presentation/screens/schedule_screen.dart';
import 'package:mobile_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:mobile_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:mobile_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:mobile_app/features/learning/presentation/screens/learning_path_screen.dart';
import 'package:mobile_app/features/learning/presentation/screens/module_detail_screen.dart';
import 'package:mobile_app/features/learning/presentation/screens/lesson_play_screen.dart';
import 'package:mobile_app/features/learning/presentation/screens/quiz_screen.dart';
import 'package:mobile_app/features/learning/presentation/screens/quiz_result_screen.dart';
import 'package:mobile_app/features/learning/presentation/screens/quiz_review_screen.dart';
import 'package:mobile_app/features/learning/presentation/screens/flashcard_screen.dart';
import 'package:mobile_app/features/learning/presentation/bloc/flashcard_bloc.dart';
import 'package:mobile_app/features/ai_solver/presentation/screens/ai_solver_screen.dart';
import 'package:mobile_app/features/ai_solver/presentation/screens/image_crop_screen.dart';
import 'package:mobile_app/features/ai_solver/presentation/screens/analyzing_screen.dart';
import 'package:mobile_app/features/ai_solver/presentation/screens/solution_detail_screen.dart';
import 'package:mobile_app/features/ai_solver/presentation/screens/ai_tutor_chat_screen.dart';
import 'package:mobile_app/features/ai_solver/presentation/screens/notebook_screen.dart';
import 'package:mobile_app/features/ai_solver/presentation/bloc/scanner_bloc/scanner_bloc.dart';
import 'package:mobile_app/features/ai_solver/presentation/bloc/scanner_bloc/scanner_event.dart';
import 'package:mobile_app/features/ai_solver/presentation/bloc/solution_bloc/solution_bloc.dart';
import 'package:mobile_app/features/ai_solver/presentation/bloc/solution_bloc/solution_event.dart';
import 'package:mobile_app/features/ai_solver/presentation/bloc/ai_chat_bloc/ai_chat_bloc.dart';
import 'package:mobile_app/features/ai_solver/presentation/bloc/ai_chat_bloc/ai_chat_event.dart';
import 'package:mobile_app/features/ai_solver/presentation/bloc/notebook_bloc/notebook_bloc.dart';
import 'package:mobile_app/features/ai_solver/presentation/bloc/notebook_bloc/notebook_event.dart';

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

// Khởi tạo trực tiếp GoRouter 
final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch( 
          routes: [
            GoRoute(
              name: 'home',
              path: '/home',
              builder: (context, state) => BlocProvider(
                create: (context) => HomeBloc(
                  HomeRepositoryImpl(
                    HomeRemoteDatasourceImpl(),
                  ),
                ),
                child: const HomeScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'schedule',
                  builder: (context, state) => BlocProvider(
                    create: (context) => HomeBloc(
                      HomeRepositoryImpl(
                        HomeRemoteDatasourceImpl(),
                      ),
                    ),
                    child: const ScheduleScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/learning',
              builder: (context, state) => const LearningPathScreen(),
              routes: [
                GoRoute(
                  path: 'module-detail',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    return ModuleDetailScreen(
                      moduleId: extra?['moduleId'] ?? 'pandas-analysis',
                      moduleName: extra?['moduleName'] ?? 'Pandas Analysis',
                    );
                  },
                ),
                GoRoute(
                  path: 'lesson-play',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    return LessonPlayScreen(
                      lessonId: extra?['lessonId'] ?? '1',
                      lessonName: extra?['lessonName'] ?? 'Intro to Dataframes',
                      moduleName: extra?['moduleName'] ?? 'Pandas Analysis',
                    );
                  },
                ),
                GoRoute(
                  path: 'quiz-start',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    return QuizScreen(
                      quizName: extra?['quizName'] ?? 'Quiz',
                      moduleName: extra?['moduleName'] ?? 'Module',
                    );
                  },
                ),
                GoRoute(
                  path: 'quiz-result',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    return QuizResultScreen(
                      correctCount: extra?['correctCount'] ?? 0,
                      totalCount: extra?['totalCount'] ?? 0,
                      minutes: extra?['minutes'] ?? 0,
                      quizName: extra?['quizName'] ?? 'Quiz',
                      userAnswers: extra?['userAnswers'] ?? {},
                      questions: extra?['questions'] ?? [],
                    );
                  },
                ),
                GoRoute(
                  path: 'quiz-review',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    return QuizReviewScreen(
                      quizName: extra?['quizName'] ?? 'Quiz',
                      userAnswers: extra?['userAnswers'] ?? {},
                      questions: extra?['questions'] ?? [],
                      correctCount: extra?['correctCount'] ?? 0,
                      totalCount: extra?['totalCount'] ?? 0,
                    );
                  },
                ),
                GoRoute(
                  path: 'flashcard-start',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    return BlocProvider(
                      create: (context) => FlashcardBloc(),
                      child: FlashcardScreen(
                        lessonId: extra?['lessonId'] ?? 'lesson-1',
                        moduleName: extra?['moduleName'] ?? 'Module',
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(routes: [GoRoute(path: '/exam', builder: (context, state) => const Scaffold(body: Center(child: Text('Thi thử'))))]),
        StatefulShellBranch(routes: [GoRoute(path: '/profile', builder: (context, state) => const Scaffold(body: Center(child: Text('Cá nhân'))))]),
      ],
    ),
    GoRoute(
      path: '/camera',
      builder: (context, state) => const AiSolverScreen(),
    ),
    GoRoute(
      path: '/camera/crop',
      builder: (context, state) => const ImageCropScreen(),
    ),
    GoRoute(
      path: '/camera/analyzing',
      builder: (context, state) => BlocProvider(
        create: (context) => ScannerBloc()..add(const StartScanning()),
        child: const AnalyzingScreen(),
      ),
    ),
    GoRoute(
      path: '/camera/solution-detail',
      builder: (context, state) => BlocProvider(
        create: (context) => SolutionBloc()..add(const LoadSolution()),
        child: const SolutionDetailScreen(),
      ),
    ),
    GoRoute(
      path: '/camera/ai-tutor-chat',
      builder: (context, state) => BlocProvider(
        create: (context) => AiChatBloc()..add(const LoadChatHistory()),
        child: const AiTutorChatScreen(),
      ),
    ),
    GoRoute(
      path: '/camera/notebook',
      builder: (context, state) => BlocProvider(
        create: (context) => NotebookBloc()..add(const LoadNotebooks()),
        child: const NotebookScreen(),
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