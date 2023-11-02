import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:local_timer_api/local_timer_api.dart';
import 'package:time_tracker/app/app.dart';
import 'package:timer_repository/timer_repository.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// Sets up any flavor-independent configuration and bootstraps the app
Future<void> bootstrap({required TimerApi timerApi}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final taskRepository = TaskRepository(api: timerApi);
  final sessionRepository = SessionRepository(api: timerApi);

  runApp(
    App(taskRepository: taskRepository, sessionRepository: sessionRepository),
  );
}
