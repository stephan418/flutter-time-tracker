import 'package:timer_api/timer_api.dart';

/// {@template task_repository}
/// The principal interface for working with `Task` objects
/// {@endtemplate}
class TaskRepository {
  /// {@macro task_repository}
  const TaskRepository({required TimerApi api}) : _api = api;

  final TimerApi _api;

  /// Gets all tasks
  ///
  /// Updates a new task list whenever the tasks are updated.
  Stream<List<Task>> getTasks() => _api.getTasks();

  /// Saves or updates a task
  ///
  /// If the task's id is set, it is presumed already existing and updated
  Future<void> saveOrUpdateTask(Task task) {
    if (task.id == null) {
      return _saveTask(task);
    }

    return _updateTask(task);
  }

  /// Deletes a single task
  Future<void> deleteTask(String id) => _api.deleteTask(id);

  Future<void> _saveTask(Task task) => _api.saveTask(task);

  Future<void> _updateTask(Task task) => _api.updateTask(task);
}
