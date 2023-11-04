part of 'task_selector_bloc.dart';

sealed class TaskSelectorEvent extends Equatable {
  const TaskSelectorEvent();

  @override
  List<Object?> get props => [];
}

class TaskSelectorSubscriptionRequested extends TaskSelectorEvent {
  const TaskSelectorSubscriptionRequested();
}
