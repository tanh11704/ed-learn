import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  runApp(const EdTechApp());
}

class EdTechApp extends StatelessWidget {
  const EdTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
      ],
      child: MaterialApp.router(
        title: 'EdTech Super App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1890FF)),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}