import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/app/routes/routes.dart';
import 'package:time_tracker/theme/theme.dart';
import 'package:time_tracker/ticker/bloc/ticker_bloc.dart';
import 'package:time_tracker/ticker/ticker.dart';
import 'package:timer_repository/timer_repository.dart';

/// App entrypoint widget
class App extends StatelessWidget {
  const App({
    required this.sessionRepository,
    required this.taskRepository,
    super.key,
  });

  final SessionRepository sessionRepository;
  final TaskRepository taskRepository;

  @override
  Widget build(BuildContext context) {
    // Provide all repositories to the entire widget tree
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: sessionRepository),
        RepositoryProvider.value(value: taskRepository),
      ],
      child: BlocProvider<TickerBloc>(
        create: (context) => TickerBloc(ticker: const Ticker()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: TimeTrackerTheme.light,
      darkTheme: TimeTrackerTheme.dark,
      routerConfig: goRouterConfig,
    );
  }
}
