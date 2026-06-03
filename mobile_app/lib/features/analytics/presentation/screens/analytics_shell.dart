import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/performance_bloc/performance_bloc.dart';
import '../bloc/prediction_bloc/prediction_bloc.dart';
import '../bloc/mistake_bank_bloc/mistake_bank_bloc.dart';
import '../../data/datasources/error_bank_remote_datasource.dart';
import '../../data/repositories/error_bank_repository_impl.dart';

class AnalyticsShell extends StatelessWidget {
  final Widget child;

  const AnalyticsShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PerformanceBloc()),
        BlocProvider(create: (_) => PredictionBloc()),
        BlocProvider(
          create: (_) => MistakeBankBloc(
            repository: ErrorBankRepositoryImpl(
              ErrorBankRemoteDataSourceImpl(),
            ),
          ),
        ),
      ],
      child: child,
    );
  }
}
