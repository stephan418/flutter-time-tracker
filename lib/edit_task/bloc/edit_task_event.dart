part of 'edit_task_bloc.dart';

@immutable
sealed class EditTaskEvent extends Equatable {
  const EditTaskEvent();

  @override
  List<Object?> get props => [];
}

final class EditTaskTitleChanged extends EditTaskEvent {
  const EditTaskTitleChanged({required this.title});

  final String title;

  @override
  List<Object?> get props => [title];
}

class EditTaskDescriptionChanged extends EditTaskEvent {
  const EditTaskDescriptionChanged({required this.description});

  final String description;

  @override
  List<Object> get props => [];
}

class EditTaskTaskSubmitted extends EditTaskEvent {
  const EditTaskTaskSubmitted();
}
