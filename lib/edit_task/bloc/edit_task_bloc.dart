import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_timer_api/local_timer_api.dart';
import 'package:time_tracker/global/global.dart';
import 'package:timer_repository/timer_repository.dart';

part 'edit_task_event.dart';
part 'edit_task_state.dart';

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState> {
  EditTaskBloc({required TaskRepository taskRepository, Task? taskToEdit})
      : _taskRepository = taskRepository,
        super(
          taskToEdit == null
              ? const EditTaskState()
              : EditTaskState.fromTaskToEdit(taskToEdit),
        ) {
    on<EditTaskTitleChanged>(_onTitleChanged);
    on<EditTaskDescriptionChanged>(_onDescriptionChanged);
    on<EditTaskTaskSubmitted>(_onSubmitted);
  }

  final TaskRepository _taskRepository;

  void _onTitleChanged(
    EditTaskTitleChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(
    EditTaskDescriptionChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onSubmitted(
    EditTaskTaskSubmitted event,
    Emitter<EditTaskState> emit,
  ) async {
    emit(state.copyWith(taskSaveStatus: RequestStatus.loading));

    final task = (state.taskToEdit ?? Task(title: '', description: ''))
        .copyWith(title: state.title, description: state.description);

    try {
      await _taskRepository.saveOrUpdateTask(task);
      emit(state.copyWith(taskSaveStatus: RequestStatus.success));
    } catch (e) {
      emit(state.copyWith(taskSaveStatus: RequestStatus.failure));
    }
  }
}
