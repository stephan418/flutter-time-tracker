import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_timer_api/local_timer_api.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:time_tracker/global/global.dart';
import 'package:timer_repository/timer_repository.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({
    required SessionRepository sessionRepository,
    required TaskRepository taskRepository,
    required PreferencesRepository preferencesRepository,
  })  : _sessionRepository = sessionRepository,
        _taskRepository = taskRepository,
        _preferencesRepository = preferencesRepository,
        super(const TimerState()) {
    on<TimerSubscriptionRequested>(_onSubscriptionRequested);
    on<TimerStarted>(_onTimerStarted);
    on<TimerTicked>(_onTimerTicked);
    on<TimerStopped>(_onTimerStopped);
    on<TimerReset>(_onTimerReset);
    on<TimerTaskSelected>(_onTaskSelected, transformer: restartable());
    on<_TimerTaskReloadRequested>(_onTaskReloadRequested);
    on<_TimerSaveRequested>(_onTimerSaveRequested);
  }

  final SessionRepository _sessionRepository;
  final TaskRepository _taskRepository;
  final PreferencesRepository _preferencesRepository;

  Future<void> _onSubscriptionRequested(
    TimerSubscriptionRequested event,
    Emitter<TimerState> emit,
  ) async {
    assert(
      state.status == TimerStatus.initial,
      'to request a subscription, the timer must be in initial state',
    );

    emit(state.copyWith(taskLoadStatus: RequestStatus.loading));

    final lastUsedTaskId =
        await _preferencesRepository.getLastUsedTaskId().first;

    add(TimerTaskSelected(taskId: lastUsedTaskId));
  }

  Future<void> _onTaskSelected(
    TimerTaskSelected event,
    Emitter<TimerState> emit,
  ) async {
    add(_TimerTaskReloadRequested(taskId: event.taskId));

    emit(state.copyWith(durationLoadStatus: RequestStatus.loading));

    final Stream<int> stream;

    if (event.taskId == null) {
      stream = _sessionRepository.getAllTimeSessionDuration();
    } else {
      stream =
          _sessionRepository.getAllTimeSessionDurationByTaskId(event.taskId!);
    }

    await emit.forEach(
      stream,
      onData: (duration) => state.copyWith(
        durationLoadStatus: RequestStatus.success,
        savedDuration: duration,
        status: TimerStatus.ready,
      ),
      onError: (_, __) => state.copyWith(
        durationLoadStatus: RequestStatus.failure,
      ),
    );
  }

  Future<void> _onTaskReloadRequested(
    _TimerTaskReloadRequested event,
    Emitter<TimerState> emit,
  ) async {
    TimerState onError(TimerState state) =>
        state.copyWith(taskLoadStatus: RequestStatus.failure);

    if (event.taskId != null) {
      await emit.forEach(
        _taskRepository.getTask(event.taskId!),
        onData: (task) {
          return task != null
              ? state.copyWith(
                  taskLoadStatus: RequestStatus.success,
                  task: () => task,
                )
              : onError(state);
        },
        onError: (_, __) => onError(state),
      );
    } else {
      emit(
        state.copyWith(
          taskLoadStatus: RequestStatus.initial,
          task: () => null,
        ),
      );
    }
  }

  void _onTimerStarted(TimerStarted event, Emitter<TimerState> emit) {
    assert(
      state.status == TimerStatus.ready,
      'to be started, the timer must be in ready state',
    );

    emit(state.copyWith(status: TimerStatus.running, startedAt: DateTime.now));
  }

  void _onTimerTicked(TimerTicked event, Emitter<TimerState> emit) {
    assert(
      state.status == TimerStatus.running,
      'to tick, the timer must be in running state',
    );

    emit(state.copyWith(elapsedDuration: event.elapsed));
  }

  void _onTimerStopped(TimerStopped event, Emitter<TimerState> emit) {
    assert(
      state.status == TimerStatus.running,
      'to be stopped, the timer must be in running state',
    );

    emit(state.copyWith(status: TimerStatus.stopped));
    add(const _TimerSaveRequested());
  }

  void _onTimerReset(TimerReset event, Emitter<TimerState> emit) {
    emit(
      state.copyWith(
        status: TimerStatus.ready,
        elapsedDuration: 0,
        saveStatus: RequestStatus.initial,
        startedAt: () => null,
      ),
    );
  }

  Future<void> _onTimerSaveRequested(
    _TimerSaveRequested event,
    Emitter<TimerState> emit,
  ) async {
    final session = Session(
      seconds: state.elapsedDuration,
      startedAt: state.startedAt!,
      taskId: state.task?.id,
    );

    await _sessionRepository.saveOrUpdateSession(session);
    if (session.taskId != null) {
      await _preferencesRepository.saveLastUsedTaskId(session.taskId!);
    }

    add(const TimerReset());
  }
}
