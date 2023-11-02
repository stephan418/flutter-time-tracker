import 'package:flutter/cupertino.dart';
import 'package:local_timer_api/local_timer_api.dart';
import 'package:time_tracker/bootstrap.dart';

/// Development entry point
///
/// Sets up any development specific configuration
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // The TimerApi and AppDatabase are set up here because these may change
  // depending on the flavor / environment in the future
  final timerApi = LocalTimerApi(database: AppDatabase());

  bootstrap(timerApi: timerApi);
}
