import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Riverpod provider that owns the app router.
///
/// Keep routing configuration in one place and make it easy to inject
/// dependencies (auth state, repositories, etc.) later.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const _HomePage();
        },
      ),
    ],
  );
});

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EdLearn')),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
