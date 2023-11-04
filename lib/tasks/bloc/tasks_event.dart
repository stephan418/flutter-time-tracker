part of 'tasks_bloc.dart';

sealed class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

final class TasksSubscriptionRequested extends TasksEvent {
  const TasksSubscriptionRequested();
}

final class TasksTaskDeleted extends TasksEvent {
  const TasksTaskDeleted({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
