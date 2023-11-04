part of 'edit_task_bloc.dart';

@immutable
final class EditTaskState extends Equatable {
  const EditTaskState({
    this.taskSaveStatus = RequestStatus.initial,
    this.taskToEdit,
    this.title = '',
    this.description = '',
  });

  factory EditTaskState.fromTaskToEdit(Task taskToEdit) => EditTaskState(
        taskToEdit: taskToEdit,
        title: taskToEdit.title,
        description: taskToEdit.description,
      );

  final RequestStatus taskSaveStatus;
  final Task? taskToEdit;
  final String title;
  final String description;

  EditTaskState copyWith({
    RequestStatus? taskSaveStatus,
    Task? Function()? taskToEdit,
    String? title,
    String? description,
  }) {
    return EditTaskState(
      taskSaveStatus: taskSaveStatus ?? this.taskSaveStatus,
      taskToEdit: taskToEdit != null ? taskToEdit() : this.taskToEdit,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  bool get isCreating => taskToEdit == null;

  @override
  List<Object?> get props => [taskSaveStatus, taskToEdit, title, description];
}
