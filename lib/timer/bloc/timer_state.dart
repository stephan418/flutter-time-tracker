part of 'timer_bloc.dart';

enum TimerStatus { initial, ready, running, stopped }

final class TimerState extends Equatable {
  const TimerState({
    this.status = TimerStatus.initial,
    this.sessionLoadStatus = RequestStatus.initial,
    this.saveStatus = RequestStatus.initial,
    this.savedDuration = 0,
    this.elapsedDuration = 0,
    this.startedAt,
  });

  final TimerStatus status;

  final RequestStatus sessionLoadStatus;
  final RequestStatus saveStatus;

  final int savedDuration;
  final int elapsedDuration;

  int get totalDuration => savedDuration + elapsedDuration;

  final DateTime? startedAt;

  TimerState copyWith({
    TimerStatus? status,
    RequestStatus? sessionLoadStatus,
    RequestStatus? saveStatus,
    int? totalDuration,
    int? elapsedDuration,
    DateTime? Function()? startedAt,
  }) {
    return TimerState(
      status: status ?? this.status,
      sessionLoadStatus: sessionLoadStatus ?? this.sessionLoadStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      savedDuration: totalDuration ?? this.savedDuration,
      elapsedDuration: elapsedDuration ?? this.elapsedDuration,
      startedAt: startedAt != null ? startedAt() : this.startedAt,
    );
  }

  @override
  List<Object?> get props =>
      [status, sessionLoadStatus, saveStatus, savedDuration, elapsedDuration];
}
