import 'package:timer_api/timer_api.dart';

/// {@template session_repository}
/// The principal interface for working with `Session` objects
/// {@endtemplate}
class SessionRepository {
  /// {@macro session_repository}
  const SessionRepository({required TimerApi api}) : _api = api;

  final TimerApi _api;

  /// Gets all sessions
  ///
  /// Emits a new session list whenever the tasks are updated.
  Stream<List<Session>> getSessions() => _api.getSessions();

  /// Gets the running duration of all sessions
  ///
  /// Emits a new value whenever the sessions are updated.
  Stream<int?> getAllTimeSessionDuration() => _api.getAllTimeSessionDuration();

  /// Saves or updates a session
  ///
  /// If the session's id is set, it is presumed already existing and updated.
  Future<void> saveOrUpdateSession(Session session) {
    if (session.id == null) {
      return _saveSession(session);
    }

    return _updateSession(session);
  }

  /// Deletes a single session
  Future<void> deleteSession(String id) => _api.deleteSession(id);

  Future<void> _saveSession(Session session) => _api.saveSession(session);

  Future<void> _updateSession(Session session) => _api.updateSession(session);
}
