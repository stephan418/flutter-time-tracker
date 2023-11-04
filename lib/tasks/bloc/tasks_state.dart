part of 'tasks_bloc.dart';

final class TasksState extends Equatable {
  const TasksState({
    this.tasksLoadStatus = RequestStatus.initial,
    this.tasks = const [],
  });

  final RequestStatus tasksLoadStatus;
  final List<Task> tasks;

  TasksState copyWith({
    RequestStatus? tasksLoadStatus,
    List<Task>? tasks,
  }) {
    return TasksState(
      tasksLoadStatus: tasksLoadStatus ?? this.tasksLoadStatus,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [tasksLoadStatus, tasks];
}
