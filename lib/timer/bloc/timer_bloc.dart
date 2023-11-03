import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_timer_api/local_timer_api.dart';
import 'package:time_tracker/global/global.dart';
import 'package:timer_repository/timer_repository.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required SessionRepository sessionRepository})
      : _sessionRepository = sessionRepository,
        super(const TimerState()) {
    on<TimerSubscriptionRequested>(_onSubscriptionRequested);
    on<TimerStarted>(_onTimerStarted);
    on<TimerTicked>(_onTimerTicked);
    on<TimerStopped>(_onTimerStopped);
    on<TimerReset>(_onTimerReset);
    on<_TimerSaveRequested>(_onTimerSaveRequested);
  }

  final SessionRepository _sessionRepository;

  Future<void> _onSubscriptionRequested(
    TimerSubscriptionRequested event,
    Emitter<TimerState> emit,
  ) async {
    assert(
      state.status == TimerStatus.initial,
      'to request a subscription, the timer must be in initial state',
    );

    emit(state.copyWith(sessionLoadStatus: RequestStatus.loading));

    await emit.forEach(
      _sessionRepository.getAllTimeSessionDuration(),
      onData: (duration) => state.copyWith(
        sessionLoadStatus: RequestStatus.success,
        totalDuration: duration,
        status: TimerStatus.ready,
      ),
      onError: (_, __) => state.copyWith(
        sessionLoadStatus: RequestStatus.failure,
      ),
    );
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
    final session =
        Session(seconds: state.elapsedDuration, startedAt: state.startedAt!);

    await _sessionRepository.saveOrUpdateSession(session);
    add(const TimerReset());
  }
}
