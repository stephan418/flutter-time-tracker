part of 'timer_bloc.dart';

enum TimerStatus { initial, ready, running, stopped }

final class TimerState extends Equatable {
  const TimerState({
    this.status = TimerStatus.initial,
    this.taskLoadStatus = RequestStatus.initial,
    this.durationLoadStatus = RequestStatus.initial,
    this.saveStatus = RequestStatus.initial,
    this.savedDuration = 0,
    this.elapsedDuration = 0,
    this.startedAt,
    this.task,
  });

  final TimerStatus status;

  final RequestStatus taskLoadStatus;
  final RequestStatus durationLoadStatus;
  final RequestStatus saveStatus;

  final int savedDuration;
  final int elapsedDuration;

  final Task? task;

  int get totalDuration => savedDuration + elapsedDuration;

  final DateTime? startedAt;

  TimerState copyWith({
    TimerStatus? status,
    RequestStatus? taskLoadStatus,
    RequestStatus? durationLoadStatus,
    RequestStatus? saveStatus,
    int? savedDuration,
    int? elapsedDuration,
    Task? Function()? task,
    DateTime? Function()? startedAt,
  }) {
    return TimerState(
      status: status ?? this.status,
      taskLoadStatus: taskLoadStatus ?? this.taskLoadStatus,
      durationLoadStatus: durationLoadStatus ?? this.durationLoadStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      savedDuration: savedDuration ?? this.savedDuration,
      elapsedDuration: elapsedDuration ?? this.elapsedDuration,
      task: task != null ? task() : this.task,
      startedAt: startedAt != null ? startedAt() : this.startedAt,
    );
  }

  @override
  List<Object?> get props => [
        status,
        taskLoadStatus,
        durationLoadStatus,
        saveStatus,
        savedDuration,
        elapsedDuration,
        task,
        startedAt,
      ];
}
