import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: EdTechApp()));
}
class EdTechApp extends ConsumerWidget { 
  const EdTechApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider); // Gọi Router từ Riverpod

    return MaterialApp.router(
      title: 'EdTech Super App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1890FF)), // AppColors.primary
        useMaterial3: true,
      ),
      routerConfig: router, // Cắm GoRouter vào đây
    );
  }
}