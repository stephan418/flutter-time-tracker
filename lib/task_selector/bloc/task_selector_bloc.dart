import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_timer_api/local_timer_api.dart';
import 'package:time_tracker/global/global.dart';
import 'package:timer_repository/timer_repository.dart';

part 'task_selector_event.dart';
part 'task_selector_state.dart';

class TaskSelectorBloc extends Bloc<TaskSelectorEvent, TaskSelectorState> {
  TaskSelectorBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const TaskSelectorState()) {
    on<TaskSelectorSubscriptionRequested>(_onSubscriptionRequested);
  }

  final TaskRepository _taskRepository;

  Future<void> _onSubscriptionRequested(
    TaskSelectorSubscriptionRequested event,
    Emitter<TaskSelectorState> emit,
  ) async {
    emit(state.copyWith(loadStatus: RequestStatus.loading));

    await emit.forEach(
      _taskRepository.getTasks(),
      onData: (tasks) => state.copyWith(
        loadStatus: RequestStatus.success,
        tasks: tasks,
      ),
      onError: (_, __) => state.copyWith(
        loadStatus: RequestStatus.failure,
      ),
    );
  }
}
