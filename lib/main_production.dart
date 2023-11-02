import 'package:flutter/cupertino.dart';
import 'package:local_timer_api/local_timer_api.dart';
import 'package:time_tracker/bootstrap.dart';

/// Production entry point
///
/// Sets up any production specific configuration
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final timerApi = LocalTimerApi(database: AppDatabase());

  bootstrap(timerApi: timerApi);
}
