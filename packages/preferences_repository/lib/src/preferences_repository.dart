import 'package:preferences_api/preferences_api.dart';

/// {@template preferences_repository}
/// The principal interface for working with locally persisted preferences
/// {@endtemplate}
class PreferencesRepository {
  /// {@macro preferences_repository}
  const PreferencesRepository({required PreferencesApi api}) : _api = api;

  final PreferencesApi _api;

  Stream<Preferences?> _getPreferences() => _api.getPreferences();

  Future<void> _savePreferences(Preferences preferences) =>
      _api.savePreferences(preferences);

  /// Gets the id of the last worked on task
  Stream<String?> getLastUsedTaskId() =>
      _getPreferences().map((preferences) => preferences?.lastTaskId);

  /// Saves the id of the last worked on task
  Future<void> saveLastUsedTaskId(String id) async {
    final preferences = await _getPreferences().first;

    if (preferences == null) {
      return _savePreferences(Preferences(lastTaskId: id));
    }

    return _savePreferences(preferences.copyWith(lastTaskId: id));
  }
}
