import 'package:drift/drift.dart';
import 'package:local_timer_api/src/database.dart';
import 'package:timer_api/timer_api.dart';

/// {@template local_timer_api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class LocalTimerApi extends TimerApi {
  /// {@macro local_timer_api}
  LocalTimerApi({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  @override
  Stream<List<Task>> getTasks() {
    return _database.select(_database.taskItems).watch();
  }

  @override
  Future<void> saveOrUpdateTask(Task task) {
    if (task.id == null) {
      return _database.into(_database.taskItems).insert(
            TaskItemsCompanion.insert(
              title: task.title,
              description: task.description,
            ),
          );
    } else {
      return (_database.update(_database.taskItems)
            ..where((table) => table.id.equals(task.id!)))
          .write(
        TaskItemsCompanion.insert(
            title: task.title, description: task.description),
      );
    }
  }

  @override
  Future<void> deleteTask(String id) {
    return (_database.delete(_database.taskItems)
          ..where((table) => table.id.equals(id)))
        .go();
  }

  @override
  Stream<List<Session>> getSessions() {
    return _database.select(_database.sessionItems).watch();
  }

  @override
  Stream<int> getAllTimeSessionDuration() {
    final totalSeconds = _database.sessionItems.seconds.sum();

    final query = _database.selectOnly(_database.sessionItems)
      ..addColumns([totalSeconds]);

    return query.map((row) => row.read(totalSeconds) ?? 0).watchSingle();
  }

  @override
  Future<void> saveOrUpdateSession(Session session) {
    if (session.id == null) {
      return _database.into(_database.sessionItems).insert(
            SessionItemsCompanion.insert(
              seconds: session.seconds,
              startedAt: session.startedAt,
              taskId: Value(session.taskId),
            ),
          );
    } else {
      return (_database.update(_database.sessionItems)
            ..where((table) => table.id.equals(session.id!)))
          .write(
        SessionItemsCompanion.insert(
          seconds: session.seconds,
          startedAt: session.startedAt,
          taskId: Value(session.taskId),
        ),
      );
    }
  }

  @override
  Future<void> deleteSession(String id) {
    return (_database.delete(_database.sessionItems)
          ..where((table) => table.id.equals(id)))
        .go();
  }
}
