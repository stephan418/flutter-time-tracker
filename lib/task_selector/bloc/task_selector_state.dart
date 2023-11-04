part of 'task_selector_bloc.dart';

final class TaskSelectorState extends Equatable {
  const TaskSelectorState({
    this.loadStatus = RequestStatus.initial,
    this.tasks = const [],
  });

  final RequestStatus loadStatus;

  final List<Task> tasks;

  TaskSelectorState copyWith({RequestStatus? loadStatus, List<Task>? tasks}) {
    return TaskSelectorState(
      loadStatus: loadStatus ?? this.loadStatus,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [loadStatus, tasks];
}
