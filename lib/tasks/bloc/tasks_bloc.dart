import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_timer_api/local_timer_api.dart';
import 'package:time_tracker/global/global.dart';
import 'package:timer_repository/timer_repository.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const TasksState()) {
    on<TasksSubscriptionRequested>(_onSubscriptionRequested);
    on<TasksTaskDeleted>(_onTaskDeleted);
  }

  final TaskRepository _taskRepository;

  Future<void> _onSubscriptionRequested(
    TasksSubscriptionRequested event,
    Emitter<TasksState> emit,
  ) async {
    emit(state.copyWith(tasksLoadStatus: RequestStatus.loading));

    await emit.forEach(
      _taskRepository.getTasks(),
      onData: (tasks) => state.copyWith(
        tasksLoadStatus: RequestStatus.success,
        tasks: tasks,
      ),
      onError: (_, __) => state.copyWith(
        tasksLoadStatus: RequestStatus.failure,
      ),
    );
  }

  Future<void> _onTaskDeleted(
    TasksTaskDeleted event,
    Emitter<TasksState> emit,
  ) async {
    await _taskRepository.deleteTask(event.id);
  }
}
