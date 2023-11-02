import 'package:timer_api/src/models/session.dart';
import 'package:timer_api/src/models/task.dart';

/// {@template timer_api}
/// Access point for the timer API
///
/// This is an abstraction. Implementations for different use cases (such as
/// on-device storage) exist in other packages
/// {@endtemplate}
abstract class TimerApi {
  /// {@macro timer_api}
  const TimerApi();

  // ***** //
  // Tasks //
  // ***** //

  /// Gets all tasks
  ///
  /// Emits a new task list whenever the tasks are updated.
  Stream<List<Task>> getTasks();

  /// Saves a single task which must have a null id
  Future<void> saveTask(Task task);

  /// Updates a single task by its id.
  Future<void> updateTask(Task task);

  /// Deletes a single task by its id
  Future<void> deleteTask(String id);

  // ******** //
  // Sessions //
  // ******** //

  /// Gets all sessions
  ///
  /// Emits a new task list whenever the sessions are updated.
  Stream<List<Session>> getSessions();

  /// Gets the running duration of all sessions
  ///
  /// Emits a new value whenever the sessions are updated.
  Stream<int?> getAllTimeSessionDuration();

  /// Saves a single session which must have a null id
  Future<void> saveSession(Session session);

  /// Updates a single session by its id
  Future<void> updateSession(Session session);

  /// Deletes a single session by its id
  Future<void> deleteSession(String id);
}
