import 'package:flutter/cupertino.dart';
import 'package:local_preferences_api/local_preferences_api.dart';
import 'package:local_timer_api/local_timer_api.dart';
import 'package:time_tracker/bootstrap.dart';

/// Production entry point
///
/// Sets up any production specific configuration
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // The TimerApi and AppDatabase are set up here because these may change
  // depending on the flavor / environment in the future
  final timerApi = LocalTimerApi(database: AppDatabase());

  final preferencesApi =
      LocalPreferencesApi(plugin: await SharedPreferences.getInstance());

  await bootstrap(
    timerApi: timerApi,
    preferencesApi: preferencesApi,
  );
}
