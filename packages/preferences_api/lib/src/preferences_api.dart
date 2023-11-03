import 'package:preferences_api/preferences_api.dart';

/// {@template preferences_api}
/// An abstraction for data access to locally persisted preferences and state
/// {@endtemplate}
abstract class PreferencesApi {
  /// {@macro preferences_api}
  const PreferencesApi();

  /// Gets the preferences instance
  ///
  /// Emits whenever there is a change to the preferences.
  Stream<Preferences?> getPreferences();

  /// Saves the preferences instance
  Future<void> savePreferences(Preferences preferences);
}
