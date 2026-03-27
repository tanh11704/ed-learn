import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  runApp(const EdTechApp());
}

// Khởi tạo dependencies
final authRemoteDataSource = AuthRemoteDatasourceImpl();
final authRepository = AuthRepositoryImpl(authRemoteDataSource);
class EdTechApp extends StatelessWidget {
  const EdTechApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRemoteDataSource),
        ),
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